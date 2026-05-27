-- ~/.config/nvim/lua/Plugins/appearance/lualine.lua

-- local function get_time()
-- 	return os.date("%I:%M %p")
-- end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"echasnovski/mini.icons",
		"nvim-tree/nvim-web-devicons",
		-- "chrisgrieser/nvim-dr-lsp", -- LSP symbols in lualine
		-- "AndreM222/copilot-lualine",
	},

	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				-- component_separators = { left = "", right = "" },
				component_separators = { left = "\\", right = "/" },
				-- component_separators = { left = "", right = "" },
				-- section_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				-- section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				-- ignore_focus = {},
				ignore_focus = { "help" },
				-- always_divide_middle = true,
				always_divide_middle = false,
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
				-- lualine_a = {
				-- 	{
				-- 		"mode",
				-- 		symbols = {
				-- 			normal = "N",
				-- 			insert = "I",
				-- 			visual = "V",
				-- 			replace = "R",
				-- 		},
				-- 	},
				-- },
				lualine_a = {
					{
						"mode",
						fmt = function(s)
							return s:sub(1, 3)
						end,
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
				-- lualine_b = {
				-- 	{ require("dr-lsp").lspCount },
				-- },
				lualine_c = {
					{
						"filename",
						file_status = true,
						newfile_status = false,
						path = 1,
						-- 0: File name
						-- 1: Relative path
						-- 2: Absolute path
						-- 3: Absolute path, with tilde as the home directory
						-- 4: Filename and parent dir, with tilde as the home directory
						shorting_target = 40,
						symbols = {
							modified = "●",
							readonly = "󰌾",
							unnamed = "[No Name]",
							newfile = "[New]",
						},
					},
				},
				lualine_x = {
					-- {
					-- 	"copilot",
					-- 	symbols = {
					-- 		status = {
					-- 			icons = {
					-- 				enabled = "",
					-- 				sleep = "", -- auto-trigger disabled
					-- 				disabled = "",
					-- 				warning = "",
					-- 				unknown = "",
					-- 			},
					-- 			hl = {
					-- 				enabled = "#50FA7B",
					-- 				sleep = "#AEB7D0",
					-- 				disabled = "#6272A4",
					-- 				warning = "#FFB86C",
					-- 				unknown = "#FF5555",
					-- 			},
					-- 		},
					-- 		spinners = "dots", -- has some premade spinners
					-- 		spinner_color = "#6272A4",
					-- 	},
					-- 	show_colors = false,
					-- 	show_loading = true,
					-- },
					{ "diagnostics", symbols = { error = "E", warn = "W", info = "I", hint = "H" } },
					{
						"encoding",
						-- Show '[BOM]' when the file has a byte-order mark
						show_bomb = false,
					},
					-- {
					-- 	"fileformat",
					-- 	symbols = {
					-- 		unix = "", -- e712
					-- 		dos = "", -- e70f
					-- 		mac = "", -- e711
					-- 	},
					-- },
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
				-- lualine_z = { "location" },
				lualine_z = {
					-- {
					-- 	"location",
					-- 	fmt = function(str)
					-- 		local line, col = str:match("(%d+):(%d+)")
					-- 		return string.format(" %s.%s", line, col)
					-- 	end,
					-- 	-- separator = { left = "", right = " " },
					-- 	separators = { left = "", right = "" },
					-- 	padding = 0,
					-- 	cond = function()
					-- 		local mode = vim.fn.mode()
					-- 		return not (mode == "v" or mode == "V" or mode == "\22")
					-- 			and (vim.v.hlsearch == 0 or vim.fn.getreg("/") == "")
					-- 	end,
					-- },
					{
						"location",
						fmt = function(str)
							local line, col = str:match("(%d+):(%d+)")
							local total_lines = vim.api.nvim_buf_line_count(0)

							-- Return format: line.col/total
							return string.format(" %s.%s/%s", line, col, total_lines)
						end,
						separators = { left = "", right = "" },
						padding = 0,
						cond = function()
							local mode = vim.fn.mode()
							return not (mode == "v" or mode == "V" or mode == "\22")
								and (vim.v.hlsearch == 0 or vim.fn.getreg("/") == "")
						end,
					},
					{
						"searchcount",
						fmt = function(str)
							if str == "" then
								return ""
							end
							local count, of = str:match("(%d+)/(%d+)")
							return string.format(" %s/%s", count, of)
						end,
						-- separator = { left = "", right = "  " },
						separators = { left = "", right = "" },
						padding = 0,
						cond = function()
							local mode = vim.fn.mode()
							return vim.v.hlsearch == 1
								and vim.fn.getreg("/") ~= ""
								and not (mode == "v" or mode == "V" or mode == "\22")
						end,
					},
					{
						"selectioncount",
						fmt = function(str)
							if str == "" then
								return ""
							end

							return string.format(" %s", str)
						end,
						-- separator = { left = " ", right = "  " },
						separators = { left = "", right = "" },
						padding = 0,
					},
				},
			},
			-- inactive_sections = {
			-- 	lualine_a = {},
			-- 	lualine_b = {},
			-- 	lualine_c = { "filename" },
			-- 	lualine_x = { "location" },
			-- 	lualine_y = {},
			-- 	lualine_z = {},
			-- },
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

		vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })

		-- Also clear background for all lualine's internal groups
		local modes_list = { "normal", "insert", "visual", "replace", "command", "inactive", "terminal" }
		for _, mode in ipairs(modes_list) do
			for _, section in ipairs({ "a", "b", "c", "x", "y", "z" }) do
				local hl_group = "lualine_" .. section .. "_" .. mode
				pcall(vim.api.nvim_set_hl, 0, hl_group, { bg = "NONE" })
			end
		end

		-- Remove fillchars to get rid of any leftover separator lines
		vim.opt.fillchars = { vert = " ", stl = " ", stlnc = " " }
	end,
}

-- return {
-- 	"nvim-lualine/lualine.nvim",
-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
--
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
