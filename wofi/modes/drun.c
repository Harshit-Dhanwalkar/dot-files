/*
 *  Copyright (C) 2019-2025 Scoopta
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

#include <stdio.h>
#include <libgen.h>

#include <sys/stat.h>

#include <map.h>
#include <utils.h>
#include <config.h>
#include <utils_g.h>
#include <widget_builder_api.h>

#include <gtk/gtk.h>
#include <gio/gdesktopappinfo.h>

static const char* arg_names[] = {"print_command", "display_generic", "disable_prime", "print_desktop_file", "ignore_metadata"};

static struct mode* mode;

struct desktop_entry {
	char* full_path;
	struct wl_list link;
};

static struct map* entries;
static struct map* desktop_map;
static struct wl_list desktop_entries;

static bool print_command;
static bool display_generic;
static bool disable_prime;
static bool print_desktop_file;
static bool ignore_metadata;

static char* get_search_text(GDesktopAppInfo* info)
{
	const char* id = g_app_info_get_id(G_APP_INFO(info));
	const char* name = g_app_info_get_display_name(G_APP_INFO(info));
	const char* exec = g_app_info_get_executable(G_APP_INFO(info));
	const char* description = g_app_info_get_description(G_APP_INFO(info));
	const char* categories = g_desktop_app_info_get_categories(info);
	const char* const* keywords = g_desktop_app_info_get_keywords(info);
	const char* generic_name = g_desktop_app_info_get_generic_name(info);

	char* keywords_str = strdup("");

	if(keywords != NULL) {
		for(size_t count = 0; keywords[count] != NULL; ++count) {
			char* tmp = utils_concat(2, keywords_str, keywords[count]);
			free(keywords_str);
			keywords_str = tmp;
		}
	}

	char* ret;

	if(ignore_metadata) {
		ret = strdup(name);
	} else {
		ret = utils_concat(7, name, id,
							exec == NULL ? "" : exec,
							description == NULL ? "" : description,
							categories == NULL ? "" : categories,
							keywords_str,
							generic_name == NULL ? "" : generic_name);
	}

	free(keywords_str);
	return ret;
}

static bool populate_widget(GDesktopAppInfo* info, char* action, struct widget_builder* builder)
{
	int freename = false;
	const char* name;
	char* generic_name = strdup("");
	if(action == NULL) {
		name = g_app_info_get_display_name(G_APP_INFO(info));
		if(display_generic) {
			const char* gname = g_desktop_app_info_get_generic_name(info);
			if(gname != NULL) {
				free(generic_name);
				generic_name = utils_concat(3, " (", gname, ")");
			}
		}
	} else {
		name = g_desktop_app_info_get_action_name(info, action);
		freename = true;
	}
	if(name == NULL) {
		free(generic_name);
		return false;
	}

	if(wofi_allow_images()) {
		GIcon* icon = g_app_info_get_icon(G_APP_INFO(info));
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
				info = gtk_icon_theme_choose_icon_for_scale(theme, (const gchar**) icon_names, wofi_get_image_size(), wofi_get_window_scale(), 0);
			}
			if(info == NULL) {
				info = gtk_icon_theme_lookup_icon_for_scale(theme, "application-x-executable", wofi_get_image_size(), wofi_get_window_scale(), 0);
			}
			pixbuf = gtk_icon_info_load_icon(info, NULL);
		}

		if(pixbuf == NULL) {
			goto img_fail;
		}

		pixbuf = utils_g_resize_pixbuf(pixbuf, wofi_get_image_size() * wofi_get_window_scale(), GDK_INTERP_BILINEAR);

		wofi_widget_builder_insert_image(builder, pixbuf, "icon", NULL);
		g_object_unref(pixbuf);
	}

	img_fail:
	wofi_widget_builder_insert_text(builder, name, "name", NULL);
	wofi_widget_builder_insert_text(builder, generic_name, "generic-name", NULL);
	free(generic_name);
	if (freename)
		free((char*)name);

	/* Set widget action text */
	char *id = strdup(g_app_info_get_id(G_APP_INFO(info)));
	if(action == NULL) {
		wofi_widget_builder_set_action(builder, id);
	} else {
		char* action_txt = utils_concat(3, id, " ", action);
		wofi_widget_builder_set_action(builder, action_txt);
		free(action_txt);
	}
	free(id);

	/* Set search text */
	char* search_txt = get_search_text(info);
	wofi_widget_builder_set_search_text(builder, search_txt);
	free(search_txt);

	return true;
}

static const gchar* const* get_actions(GDesktopAppInfo* info, size_t* action_count)
{
	const gchar* const* actions = g_desktop_app_info_list_actions(info);
	unsigned count = 0;
	for(; actions[count]; count++);
	*action_count = count;
	return actions;
}

static struct widget_builder* populate_actions(char* id)
{
	GDesktopAppInfo *info = G_DESKTOP_APP_INFO(map_get(desktop_map, id));
	if (info == NULL)
		return NULL;
	size_t action_count;
	const gchar* const* action_names = get_actions(info, &action_count);
	action_count++;

	struct widget_builder* builder = wofi_widget_builder_init(mode, action_count);
	if(!populate_widget(info, NULL, builder)) {
		wofi_widget_builder_free(builder);
		return NULL;
	}
	for(size_t count = 1; count < action_count; ++count) {
		populate_widget(info, (gchar*)action_names[count - 1],
				wofi_widget_builder_get_idx(builder, count));
	}
	return builder;
}

static struct widget* create_widget(char* id)
{
	if(map_contains(entries, id))
		return NULL;// Avoid create duplicate.
	struct widget_builder* builder = populate_actions(id);
	if(builder == NULL) {
		wofi_remove_cache(mode, id);
		return NULL;
	}
	struct widget* ret = wofi_widget_builder_get_widget(builder);
	map_put(entries, id, "true");
	return ret;
}

static void add_to_desktop_map(gpointer data, gpointer user_data)
{
	((void)user_data);
	GDesktopAppInfo *dai = G_DESKTOP_APP_INFO(data);
	if (g_desktop_app_info_get_is_hidden(dai) || g_desktop_app_info_get_nodisplay(dai))
		return;
	GAppInfo *info = G_APP_INFO(data);
	const char *id = g_app_info_get_id(info);
	if (map_contains(desktop_map, id))
		return; // Duplicate!
	g_object_ref(dai); // Increment reference counter.
	map_put_void(desktop_map, id, dai);
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

static int insert_to_desktop_entries(void *key, void *value, void *data)
{
	((void)value);
	((void)data);
	const char *id = (const char *)key;
	struct desktop_entry* entry = malloc(sizeof(struct desktop_entry));
	entry->full_path = strdup(id);
	wl_list_insert(&desktop_entries, &entry->link);
	return false;
}

void wofi_drun_init(struct mode* this, struct map* config) {
	mode = this;

	print_command = strcmp(config_get(config, "print_command", "false"), "true") == 0;
	display_generic = strcmp(config_get(config, "display_generic", "false"), "true") == 0;
	disable_prime = strcmp(config_get(config, "disable_prime", "false"), "true") == 0;
	print_desktop_file = strcmp(config_get(config, "print_desktop_file", "false"), "true") == 0;
	ignore_metadata = strcmp(config_get(config, "ignore_metadata", "false"), "true") == 0;

	populate_desktop_map();

	wl_list_init(&desktop_entries);

	/* Read cache and invalidate missing */
	struct wl_list* cache = wofi_read_cache(mode);
	struct cache_line* node, *tmp;
	wl_list_for_each_safe(node, tmp, cache, link) {
		if (!map_contains(desktop_map, node->line)) {
			wofi_remove_cache(mode, node->line);
			free(node->line);
		} else {
			struct desktop_entry* entry = malloc(sizeof(struct desktop_entry));
			entry->full_path = node->line;
			wl_list_insert(&desktop_entries, &entry->link);
		}
		wl_list_remove(&node->link);
		free(node);
	}
	free(cache);
	/* Populate desktop_entries list */
	map_foreach(desktop_map, insert_to_desktop_entries, NULL);
	/* Prepare map use to detect duplicate */
	entries = map_init();
}

struct widget* wofi_drun_get_widget(void) {
	struct desktop_entry* node, *tmp;
	wl_list_for_each_reverse_safe(node, tmp, &desktop_entries, link) {
		struct widget* widget = create_widget(node->full_path);
		wl_list_remove(&node->link);
		free(node->full_path);
		free(node);
		if(widget)
			return widget;
	}
	return NULL;
}

static void launch_done(GObject* obj, GAsyncResult* result, gpointer data) {
	GError* err = NULL;
	int ret;
	if(g_app_info_launch_uris_finish(G_APP_INFO(obj), result, &err)) {
		ret = 0;
	} else if(err != NULL) {
		char* cmd = data;
		fprintf(stderr, "%s cannot be executed: %s\n", cmd, err->message);
		g_error_free(err);
		ret = 1;
	} else {
		char* cmd = data;
		fprintf(stderr, "%s cannot be executed\n", cmd);
		ret = 1;
	}
	if (data)
		free(data);
	wofi_exit(ret);
}

static void set_dri_prime(GDesktopAppInfo* info) {
	bool dri_prime = g_desktop_app_info_get_boolean(info, "PrefersNonDefaultGPU");
	if(dri_prime && !disable_prime) {
		setenv("DRI_PRIME", "1", true);
	}
}

static bool uses_dbus(GDesktopAppInfo* info) {
	return g_desktop_app_info_get_boolean(info, "DBusActivatable");
}

static char* get_cmd(GAppInfo* info) {
	const char* cmd = g_app_info_get_commandline(info);
	size_t cmd_size = strlen(cmd);
	char* new_cmd = calloc(1, cmd_size + 1);
	size_t new_cmd_count = 0;
	for(size_t count = 0; count < cmd_size; ++count) {
		if(cmd[count] == '%') {
			if(cmd[++count] == '%') {
				new_cmd[new_cmd_count++] = cmd[count];
			}
		} else {
			new_cmd[new_cmd_count++] = cmd[count];
		}
	}
	if(new_cmd[--new_cmd_count] == ' ') {
		new_cmd[new_cmd_count] = 0;
	}
	return new_cmd;
}

void wofi_drun_exec(const gchar* cmd)
{
	GDesktopAppInfo *info = G_DESKTOP_APP_INFO(map_get(desktop_map, cmd));
	if(G_IS_DESKTOP_APP_INFO(info)) {
		wofi_write_cache(mode, cmd);
		if(print_command) {
			char* cmd = get_cmd(G_APP_INFO(info));
			printf("%s\n", cmd);
			free(cmd);
			wofi_exit(0);
		} else if(print_desktop_file) {
			printf("%s\n", cmd);
			wofi_exit(0);
		} else {
			set_dri_prime(info);
			if(uses_dbus(info)) {
				gchar *c = strdup(cmd);
				g_app_info_launch_uris_async(G_APP_INFO(info), NULL, NULL, NULL, launch_done, c);
			} else {
				g_app_info_launch_uris(G_APP_INFO(info), NULL, NULL, NULL);
				wofi_exit(0);
			}
		}
	} else if(strrchr(cmd, ' ') != NULL) {
		char* space = strrchr(cmd, ' ');
		*space = 0;
		wofi_write_cache(mode, cmd);
		info = G_DESKTOP_APP_INFO(map_get(desktop_map, cmd));
		char* action = space + 1;
		if(print_command) {
			char* cmd = get_cmd(G_APP_INFO(info));
			printf("%s\n", cmd);
			free(cmd);
			fprintf(stderr, "Printing the command line for an action is not supported\n");
		} else if(print_desktop_file) {
			printf("%s %s\n", cmd, action);
			wofi_exit(0);
		} else {
			set_dri_prime(info);
			g_desktop_app_info_launch_action(info, action, NULL);
		}
		wofi_exit(0);
	} else {
		fprintf(stderr, "%s cannot be executed\n", cmd);
		wofi_exit(1);
	}
}

const char** wofi_drun_get_arg_names(void) {
	return arg_names;
}

size_t wofi_drun_get_arg_count(void) {
	return sizeof(arg_names) / sizeof(char*);
}
