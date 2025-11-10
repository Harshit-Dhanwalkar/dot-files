/*
 *  Copyright (C) 2019-2020 Scoopta
 *  This file is part of Wofi
 *  Wofi is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Wofi is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Wofi.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <map.h>
#include <utils.h>
#include <config.h>
#include <utils_g.h>
#include <widget_builder.h>

#include <sys/socket.h>
#include <sys/un.h>

#include <gio/gio.h>
#include <gio/gdesktopappinfo.h>
#include <gtk/gtk.h>

#include <json-glib/json-glib.h>

static const char* arg_names[] = {"display_appid"};

static struct mode* mode;
static int display_appid;

struct entry {
	char *title;
	char *appid;
	char *class;
	int id;
};

struct node {
	struct entry* entry;
	struct wl_list link;
};

static struct wl_list entries;
static struct map* desktop_map;

static void add_to_desktop_map(gpointer data, gpointer user_data)
{
	((void)user_data);
	GDesktopAppInfo *dai = G_DESKTOP_APP_INFO(data);
	if (g_desktop_app_info_get_is_hidden(dai) || g_desktop_app_info_get_nodisplay(dai))
		return;
	GAppInfo *info = G_APP_INFO(data);
	const char* name = g_app_info_get_display_name(info);
	if (!map_contains(desktop_map, name)) {
		g_object_ref(dai);
		map_put_void(desktop_map, name, dai);
	}
	const char* exec = g_app_info_get_executable(info);
	const char* slash = strrchr(exec, '/');
	if (slash)
		exec = slash + 1;
	if (!map_contains(desktop_map, exec)) {
		g_object_ref(dai);
		map_put_void(desktop_map, exec, dai);
	}
	const char* class = g_desktop_app_info_get_startup_wm_class(dai);
	if (class && !map_contains(desktop_map, class)) {
		g_object_ref(dai);
		map_put_void(desktop_map, class, dai);
	}
	char* icon = g_desktop_app_info_get_string(dai, "Icon");
	if (icon) {
		if (!map_contains(desktop_map, icon)) {
			g_object_ref(dai);
			map_put_void(desktop_map, icon, dai);
		}
		free(icon);
	}
}

static void populate_desktop_map()
{
	/* Create map */
	desktop_map = map_init_void();
	/* Get info from desktop files */
	GList *list = g_app_info_get_all();
	g_list_foreach(list, add_to_desktop_map, NULL);
	/* Free all but ones put on desktop_map */
	g_list_free_full(g_steal_pointer (&list), g_object_unref);
}

static void recurse_con_nodes(JsonObject *current);

static void con_nodes(JsonArray *array, guint index, JsonNode *elem, void *gdata)
{
	((void)array);
	((void)index);
	((void)gdata);
	JsonObject *node = json_node_get_object(elem);
	if (!node)
		return;

	const gchar* type = json_object_get_string_member(node, "type");
	if (!type || (strcmp(type, "con") && strcmp(type, "floating_con")))
		return;

	const gchar* shell = NULL;
	if (json_object_has_member(node, "shell")) {
		/* Avoid assert warning by testing member presence before. */
		shell = json_object_get_string_member(node, "shell");
	}
	if (!shell) {
		const gchar* layout = json_object_get_string_member(node, "layout");
		if (strcmp(layout, "none")) {
			/* splith or splitv layout node. */
			recurse_con_nodes(node);
		}
		return;
	}

	long id = json_object_get_int_member(node, "id");
	const gchar* name = json_object_get_string_member(node, "name");
	const gchar* appid = NULL;
	const gchar* class = NULL;
	if (strcmp(shell, "xdg_shell") == 0) {
		/* Get app_id */
		appid = json_object_get_string_member(node, "app_id");
	} else if (strcmp(shell, "xwayland") == 0) {
		/* Get window_properties.class */
		JsonNode *n = json_object_get_member(node, "window_properties");
		if (n) {
			JsonObject *o = json_node_get_object(n);
			if (o) {
				class = json_object_get_string_member(o, "class");
			} else {
				fprintf(stderr, "Cannot get object from window_properties member of id %ld!\n", id);
			}
		}
	}

	// Add entry for this window.
	{
		struct node* node = (struct node*)malloc(sizeof(struct node));
		struct entry* entry = (struct entry*)malloc(sizeof(struct entry));
		entry->title = strdup(name);
		entry->appid = appid ? strdup(appid) : NULL;
		entry->class = class ? strdup(class) : NULL;
		entry->id = id;
		node->entry = entry;
		wl_list_insert(&entries, &node->link);
	}
}

static void recurse_con_nodes(JsonObject *current)
{
	JsonArray *nodes;
	nodes = json_object_get_array_member(current, "nodes");
	if (nodes && json_array_get_length(nodes) > 0) {
		json_array_foreach_element(nodes, con_nodes, NULL);
	}
	nodes = json_object_get_array_member(current, "floating_nodes");
	if (nodes && json_array_get_length(nodes) > 0) {
		json_array_foreach_element(nodes, con_nodes, NULL);
	}
}

static void workspace_nodes(JsonArray *array, guint index, JsonNode *elem, void *gdata)
{
	((void)array);
	((void)index);
	((void)gdata);
	JsonObject *workspace = json_node_get_object(elem);
	if (workspace)
		recurse_con_nodes(workspace);
}

static void output_nodes(JsonArray *array, guint index, JsonNode *elem, void *gdata)
{
	((void)array);
	((void)index);
	((void)gdata);
	JsonObject *output = json_node_get_object(elem);
	if (!output)
		return;

	JsonArray *nodes;
	nodes = json_object_get_array_member(output, "nodes");
	if (nodes && json_array_get_length(nodes) > 0) {
		json_array_foreach_element(nodes, workspace_nodes, NULL);
	}
}

static int populate_entries()
{
	// Connect to sway unix socket to send get_tree command.
	char *swaysock = getenv("SWAYSOCK");
	if (!swaysock)
		return -1;
	int ret = 0;

	int s = socket(AF_UNIX, SOCK_STREAM, 0);
	if (s < 0)
		return -1;

	struct sockaddr_un sun;
	size_t sun_len = strlen(swaysock) + 1;
	if (sun_len > sizeof(sun.sun_path)) {
		ret = -2;
		goto error;
	}
	sun_len += offsetof(struct sockaddr_un, sun_path);
	sun.sun_family = AF_UNIX;
	strcpy(sun.sun_path, swaysock);

	ret = connect(s, (const struct sockaddr *) &sun, sun_len);
	if (ret == -1) {
		fprintf(stderr, "The server is down.\n");
		goto error;
	}

	const char cmd[] = "i3-ipc\0\0\0\0\4\0\0\0";
	ret = write(s, cmd, sizeof(cmd) - 1);
	if (ret < 0)
		goto error;

	unsigned char header[sizeof(cmd) - 1];
	ret = read(s, header, sizeof(header));
	if (ret < 0)
		goto error;

	size_t length = header[6] + (header[7] << 8) + (header[8] << 16) + (header[9] << 24);
	char *buffer = malloc(length + 1);
	unsigned offset = 0;
	do {
		ret = read(s, buffer + offset, length - offset);
		if (ret < 0)
			break;
		offset += ret;
	} while (offset < length);
	buffer[offset] = 0;

	wl_list_init(&entries);

	// Parse json using libjson-glib-dev.
	JsonParser *parser = json_parser_new();
	GError *error;
	if (json_parser_load_from_data(parser, buffer, length, &error)) {
		JsonObject *root = json_node_get_object(json_parser_get_root(parser));
		JsonArray *outputs = json_object_get_array_member(root, "nodes");
		if (outputs)
			json_array_foreach_element(outputs, output_nodes, NULL);
	} else {
		/* JSON parsing error */
		fprintf(stderr, "Failure to parse JSON.\n");
	}
	g_object_unref(parser);
	free(buffer);
error:
	close(s);
	return ret;
}

static struct widget* create_widget(GDesktopAppInfo* info, struct entry *entry)
{
	struct widget_builder* builder = wofi_widget_builder_init(mode, 1);

	if(wofi_allow_images()) {
		GIcon* icon = info ? g_app_info_get_icon(G_APP_INFO(info)) : NULL;
		GdkPixbuf* pixbuf;

		if(G_IS_FILE_ICON(icon)) {
			GFile* file = g_file_icon_get_file(G_FILE_ICON(icon));
			char* path = g_file_get_path(file);
			pixbuf = gdk_pixbuf_new_from_file(path, NULL);
			free(path);
		} else {
			GtkIconTheme* theme = gtk_icon_theme_get_default();
			GtkIconInfo* info = NULL;
			if(icon != NULL) {
				const gchar* const* icon_names = g_themed_icon_get_names(G_THEMED_ICON(icon));
				info = gtk_icon_theme_choose_icon_for_scale(theme, (const gchar**) icon_names,
									    wofi_get_image_size(), wofi_get_window_scale(), 0);
			}
			if(info == NULL) {
				info = gtk_icon_theme_lookup_icon_for_scale(theme, "application-x-executable",
									    wofi_get_image_size(), wofi_get_window_scale(), 0);
			}
			pixbuf = gtk_icon_info_load_icon(info, NULL);
		}

		pixbuf = utils_g_resize_pixbuf(pixbuf, wofi_get_image_size() * wofi_get_window_scale(), GDK_INTERP_BILINEAR);

		wofi_widget_builder_insert_image(builder, pixbuf, "icon", NULL);
		g_object_unref(pixbuf);
	}

	if(display_appid) {
		void *ret;
		if (entry->appid)
			ret = wofi_widget_builder_insert_text(builder, entry->appid, "appid", NULL);
		else if(entry->class)
			ret = wofi_widget_builder_insert_text(builder, entry->class, "appid", NULL);
		else
			ret = wofi_widget_builder_insert_text(builder, "unknown", "appid", NULL);
		GtkWidget* appid = GTK_WIDGET(ret);
		gtk_box_set_child_packing (GTK_BOX(builder->box), appid, false, false, 8, GTK_PACK_START);
	}

	GtkWidget* title = GTK_WIDGET(wofi_widget_builder_insert_text(builder, entry->title, "title", NULL));
	gtk_box_set_child_packing(GTK_BOX(builder->box), title, true, true, 0, GTK_PACK_START);

	char* action = malloc(32);
	if(wofi_allow_markup())
		snprintf(action, 32, "<i>(%u)</i>", entry->id);
	else
		snprintf(action, 32, "(%u)", entry->id);
	wofi_widget_builder_insert_text(builder, action, "id", NULL);

	/* Set widget action text */
	snprintf(action, 32, "%u", entry->id);
	wofi_widget_builder_set_action(builder, action);

	free(action);

	/* Set search text */
	char* search_txt = utils_concat(3, entry->title, entry->appid ?: "", entry->class ?: "");
	wofi_widget_builder_set_search_text(builder, search_txt);
	free(search_txt);

	/* Return widget */
	return wofi_widget_builder_get_widget(builder);
}

void wofi_switcher_init(struct mode* this, struct map* config)
{
	mode = this;
	display_appid = strcmp(config_get(config, "display_appid", "false"), "true") == 0;

	populate_desktop_map();
	populate_entries();
}

struct widget* wofi_switcher_get_widget(void)
{
	// Loop all entries and create widgets using desktop map to retrieve info.
	struct node* node, *tmp;
	wl_list_for_each_reverse_safe(node, tmp, &entries, link) {
		struct entry *entry = node->entry;
		gpointer data = NULL;
		struct widget* widget;

		if (entry->appid)
			data = map_get(desktop_map, entry->appid);
		if (!data && entry->class)
			data = map_get(desktop_map, entry->class);
		if (!data) {
			// TODO: Try hard using each word in title.
			if (entry->appid && strlen(entry->appid) == 0) {
				// Empty appid, may be Slack.
				if (strstr(entry->title, "Slack"))
					data = map_get(desktop_map, "Slack");
			}
		}

		widget = create_widget(data ? G_DESKTOP_APP_INFO(data) : NULL, entry);

		wl_list_remove(&node->link);
		free(node);
		free(entry->title);
		if (entry->appid) free(entry->appid);
		if (entry->class) free(entry->class);
		free(entry);

		if (widget)
			return widget;
		/* else try next one */
	}
	/* TODO: Cleanup desktop_map. */
	return NULL;
}

void wofi_switcher_exec(const gchar* cmd) {
	char id[32];
	snprintf(id, 32, "[con_id=%s]", cmd);
	char *params[4];
	params[0] = "swaymsg";
	params[1] = id;
	params[2] = "focus";
	params[3] = NULL;
	execvp(params[0], &params[0]);
}

const char** wofi_switcher_get_arg_names(void) {
	return arg_names;
}

size_t wofi_switcher_get_arg_count(void) {
	return sizeof(arg_names) / sizeof(char*);
}

bool wofi_switcher_no_entry(void) {
	return true;
}
