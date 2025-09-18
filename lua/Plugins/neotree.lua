-- ~/.config/nvim/lua/Plugins/neotree.lua
return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		{
			"s1n7ax/nvim-window-picker",
			version = "*",
			config = function()
				require("window-picker").setup({
					autoselect_one = true,
					include_current_win = false,
					filter_rules = {
						-- Filter using buffer options
						bo = {
							-- Ignore the following file types
							filetype = { "neo-tree", "neo-tree-popup", "notify" },
							-- Ignore the following buffer types
							buftype = { "terminal", "quickfix" },
						},
					},
				})
			end,
		},
	},
	config = function()
		require("neo-tree").setup({
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,

			default_component_configs = {
				container = {
					enable_character_fade = true,
				},
				indent = {
					indent_size = 2,
					padding = 1,
					with_markers = true,
					indent_marker = "│",
					last_indent_marker = "└",
					highlight = "NeoTreeIndentMarker",
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
				icon = {
					folder_closed = "",
					folder_open = "",
					folder_empty = "󰜌",
					default = "*",
					highlight = "NeoTreeFileIcon",
					provider = function(icon, node, state)
						if node.type == "file" or node.type == "terminal" then
							local success, web_devicons = pcall(require, "nvim-web-devicons")
							local name = node.type == "terminal" and "terminal" or node.name
							if success then
								local devicon, hl = web_devicons.get_icon(name)
								icon.text = devicon or icon.text
								icon.highlight = hl or icon.highlight
							end
						end
					end,
				},
				modified = {
					symbol = "[+]",
					highlight = "NeoTreeModified",
				},
				name = {
					trailing_slash = false,
					use_git_status_colors = true,
					highlight = "NeoTreeFileName",
				},
				git_status = {
					symbols = {
						added = "",
						modified = "",
						deleted = "✖",
						renamed = "󰁕",
						untracked = "",
						ignored = "",
						unstaged = "󰄱",
						staged = "",
						conflict = "",
					},
				},
				file_size = {
					enabled = true,
					required_width = 64,
				},
				type = {
					enabled = true,
					required_width = 122,
				},
				last_modified = {
					enabled = true,
					required_width = 88,
				},
				created = {
					enabled = true,
					required_width = 110,
				},
				symlink_target = {
					enabled = false,
				},
			},
			--- Git and buffer tab
			source_selector = {
				winbar = true, -- Show the tab selector in the winbar
				content_layout = "center",
				tabs_layout = "equal",
				show_separator_on_edge = true,
				sources = {
					{ source = "filesystem", display_name = "󰉓 FS" },
					{ source = "buffers", display_name = "󰈙 Buffers" },
					{ source = "git_status", display_name = " Git" },
					{ source = "diagnostics", display_name = "󰒡 Diagnostics" },
				},
				highlight_tab = "NeoTreeFileNameOpened",
				highlight_tab_active = "NeoTreeTabActive",
				highlight_background = "NeoTreeTabActive",
				highlight_separator = "NeoTreeTabActive",
				highlight_separator_active = "NeoTreeTabActive",
			},
			---

			window = {
				position = "right",
				width = 40,
				mapping_options = {
					noremap = true,
					nowait = true,
				},
				mappings = {
					["<space>"] = { "toggle_node", nowait = false },
					["<2-LeftMouse>"] = "open",
					["<cr>"] = "open",
					["<esc>"] = "cancel",
					["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
					["l"] = "focus_preview",
					["S"] = "open_split",
					["s"] = "open_vsplit",
					["t"] = "open_tabnew",
					["w"] = "open_with_window_picker",
					["C"] = "close_node",
					["z"] = "close_all_nodes",
					["a"] = { "add", config = { show_path = "none" } },
					["A"] = "add_directory",
					["d"] = "delete",
					["r"] = "rename",
					["y"] = "copy_to_clipboard",
					["x"] = "cut_to_clipboard",
					["p"] = "paste_from_clipboard",
					["c"] = "copy",
					["m"] = "move",
					["q"] = "close_window",
					["R"] = "refresh",
					["?"] = "show_help",
					["<"] = "prev_source",
					[">"] = "next_source",
					["i"] = "show_file_details",
				},
			},
			filesystem = {
				filtered_items = {
					visible = false,
					hide_dotfiles = true,
					hide_gitignored = true,
					hide_hidden = true,
				},
				follow_current_file = {
					enabled = true,
				},
				window = {
					mappings = {
						["<bs>"] = "navigate_up",
						["."] = "set_root",
						["H"] = "toggle_hidden",
						["/"] = "fuzzy_finder",
						["D"] = "fuzzy_finder_directory",
						["#"] = "fuzzy_sorter",
						["f"] = "filter_on_submit",
						["<c-x>"] = "clear_filter",
						["[g"] = "prev_git_modified",
						["]g"] = "next_git_modified",
						["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
						["oc"] = "order_by_created",
						["od"] = "order_by_diagnostics",
						["og"] = "order_by_git_status",
						["om"] = "order_by_modified",
						["on"] = "order_by_name",
						["os"] = "order_by_size",
						["ot"] = "order_by_type",
					},
				},
			},
			buffers = {
				follow_current_file = {
					enabled = true,
					leave_dirs_open = false,
				},
				group_empty_dirs = true,
				show_unloaded = true,
				window = {
					mappings = {
						["bd"] = "buffer_delete",
						["<bs>"] = "navigate_up",
						["."] = "set_root",
						["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
						["oc"] = "order_by_created",
						["od"] = "order_by_diagnostics",
						["om"] = "order_by_modified",
						["on"] = "order_by_name",
						["os"] = "order_by_size",
						["ot"] = "order_by_type",
					},
				},
			},
			git_status = {
				window = {
					position = "float",
					mappings = {
						["A"] = "git_add_all",
						["gu"] = "git_unstage_file",
						["ga"] = "git_add_file",
						["gr"] = "git_revert_file",
						["gc"] = "git_commit",
						["gp"] = "git_push",
						["gg"] = "git_commit_and_push",
						["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
						["oc"] = "order_by_created",
						["od"] = "order_by_diagnostics",
						["om"] = "order_by_modified",
						["on"] = "order_by_name",
						["os"] = "order_by_size",
						["ot"] = "order_by_type",
					},
				},
			},
		})
		-- Keymap to reveal file in Neo-tree
		vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
	end,
}
