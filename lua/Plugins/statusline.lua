-- ~/.config/nvim/lua/Plugins/lualine.lua
-- local function get_time()
-- 	return os.date("%I:%M %p")
-- end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "echasnovski/mini.icons" },
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
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
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
					"diagnostics",
				},
				lualine_x = {
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
