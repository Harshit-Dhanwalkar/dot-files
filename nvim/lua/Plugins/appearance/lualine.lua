-- ~/.config/nvim/lua/Plugins/appearance/lualine.lua
-- local function get_time()
-- 	return os.date("%I:%M %p")
-- end
return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"echasnovski/mini.icons",
		"nvim-tree/nvim-web-devicons",
		"AndreM222/copilot-lualine",
	},
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				-- component_separators = { left = "", right = "" },
				component_separators = { left = "\\", right = "/" },
				-- section_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				always_show_tabline = true,
				globalstatus = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
					refresh_time = 16, -- ~60fps
					events = {
						"WinEnter",
						"BufEnter",
						"BufWritePost",
						"SessionLoadPost",
						"FileChangedShellPost",
						"VimResized",
						"Filetype",
						"CursorMoved",
						"CursorMovedI",
						"ModeChanged",
					},
				},
			},
			sections = {
				lualine_a = {
					{
						"mode",
						symbols = {
							normal = "N",
							insert = "I",
							visual = "V",
							replace = "R",
						},
					},
				},
				lualine_b = {
					"branch",
					"diff",
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = "", warn = "", info = "", hint = "" },
					},
				},
				lualine_c = {
					{
						"filename",
						file_status = true,
						newfile_status = false,
						path = 0,
						-- 1: Relative path
						-- 2: Absolute path
						-- 3: Absolute path, with tilde as the home directory
						-- 4: Filename and parent dir, with tilde as the home directory
						shorting_target = 40,
						symbols = {
							modified = "[+]",
							readonly = "[-]",
							unnamed = "[No Name]",
							newfile = "[New]",
						},
					},
				},
				lualine_x = {
					{
						"copilot",
						symbols = {
							status = {
								icons = {
									enabled = "",
									sleep = "", -- auto-trigger disabled
									disabled = "",
									warning = "",
									unknown = "",
								},
								hl = {
									enabled = "#50FA7B",
									sleep = "#AEB7D0",
									disabled = "#6272A4",
									warning = "#FFB86C",
									unknown = "#FF5555",
								},
							},
							spinners = "dots", -- has some premade spinners
							spinner_color = "#6272A4",
						},
						show_colors = false,
						show_loading = true,
					},
					"encoding",
					-- {
					-- 	"encoding",
					-- 	-- Show '[BOM]' when the file has a byte-order mark
					-- 	show_bomb = false,
					-- },
					{
						"fileformat",
						symbols = {
							unix = "", -- e712
							dos = "", -- e70f
							mac = "", -- e711
						},
					},
					{
						"filetype",
						colored = true, -- Displays filetype icon in color if set to true
						icon_only = false, -- Display only an icon for filetype
						icon = { align = "right" },
					},
				},
				-- lualine_y = { "progress" },
				lualine_y = {
					{
						"lsp_status",
						icon = "", -- f013
						symbols = {
							spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
							done = "✓",
							separator = " ",
						},
						ignore_lsp = {},
					},
				},
				-- lualine_z = { get_time, "location" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			-- tabline = {
			-- 	lualine_a = {},
			-- 	lualine_b = { "branch" },
			-- 	lualine_c = { "filename" },
			-- 	lualine_x = {},
			-- 	lualine_y = {},
			-- 	lualine_z = {"tabs"},
			-- },
			-- winbar = {
			-- 	lualine_a = {},
			-- 	lualine_b = {},
			-- 	lualine_c = { "filename" },
			-- 	lualine_x = {},
			-- 	lualine_y = {},
			-- 	lualine_z = {},
			-- },
			-- inactive_winbar = {
			-- 	lualine_a = {},
			-- 	lualine_b = {},
			-- 	lualine_c = { "filename" },
			-- 	lualine_x = {},
			-- 	lualine_y = {},
			-- 	lualine_z = {},
			-- },
			extensions = {},
		})
	end,
}
-- return {
-- 	"nvim-lualine/lualine.nvim",
-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
-- 	config = function()
-- 		local lualine = require("lualine")
-- 		local lazy_status = require("lazy.status") -- to configure lazy pending updates count
--
-- 		local colors = {
-- 			color0 = "#092236",
-- 			color1 = "#ff5874",
-- 			color2 = "#c3ccdc",
-- 			color3 = "#1c1e26",
-- 			color6 = "#a1aab8",
-- 			color7 = "#828697",
-- 			color8 = "#ae81ff",
-- 		}
-- 		local my_lualine_theme = {
-- 			replace = {
-- 				a = { fg = colors.color0, bg = colors.color1, gui = "bold" },
-- 				b = { fg = colors.color2, bg = colors.color3 },
-- 			},
-- 			inactive = {
-- 				a = { fg = colors.color6, bg = colors.color3, gui = "bold" },
-- 				b = { fg = colors.color6, bg = colors.color3 },
-- 				c = { fg = colors.color6, bg = colors.color3 },
-- 			},
-- 			normal = {
-- 				a = { fg = colors.color0, bg = colors.color7, gui = "bold" },
-- 				b = { fg = colors.color2, bg = colors.color3 },
-- 				c = { fg = colors.color2, bg = colors.color3 },
-- 			},
-- 			visual = {
-- 				a = { fg = colors.color0, bg = colors.color8, gui = "bold" },
-- 				b = { fg = colors.color2, bg = colors.color3 },
-- 			},
-- 			insert = {
-- 				a = { fg = colors.color0, bg = colors.color2, gui = "bold" },
-- 				b = { fg = colors.color2, bg = colors.color3 },
-- 			},
-- 		}
--
-- 		local mode = {
-- 			"mode",
-- 			fmt = function(str)
-- 				-- return ' '
-- 				-- displays only the first character of the mode
-- 				return " " .. str
-- 			end,
-- 		}
--
-- 		local diff = {
-- 			"diff",
-- 			colored = true,
-- 			symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
-- 			-- cond = hide_in_width,
-- 		}
--
-- 		local filename = {
-- 			"filename",
-- 			file_status = true,
-- 			path = 0,
-- 		}
--
-- 		local branch = { "branch", icon = { "", color = { fg = "#A6D4DE" } }, "|" }
--
-- 		lualine.setup({
-- 			icons_enabled = true,
-- 			options = {
-- 				theme = my_lualine_theme,
-- 				component_separators = { left = "|", right = "|" },
-- 				section_separators = { left = "|", right = "" },
-- 			},
-- 			sections = {
-- 				lualine_a = { mode },
-- 				lualine_b = { branch },
-- 				lualine_c = { diff, filename },
-- 				lualine_x = {
-- 					{
-- 						-- require("noice").api.statusline.mode.get,
-- 						-- cond = require("noice").api.statusline.mode.has,
-- 						lazy_status.updates,
-- 						cond = lazy_status.has_updates,
-- 						color = { fg = "#ff9e64" },
-- 					},
-- 					-- { "encoding",},
-- 					-- { "fileformat" },
-- 					{ "filetype" },
-- 				},
-- 			},
-- 		})
-- 	end,
-- }
