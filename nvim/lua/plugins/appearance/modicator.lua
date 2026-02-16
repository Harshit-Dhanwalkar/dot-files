-- ~/.config/nvim/lua/Plugins/appearance/modicator.lua
return {
	"mawkler/modicator.nvim",
	-- dependencies = 'mawkler/onedark.nvim', -- Add colorscheme plugin here
	init = function()
		-- These are required for Modicator to work
		vim.o.cursorline = true
		vim.o.number = true
		vim.o.termguicolors = true
	end,
	config = function()
		require("modicator").setup({
			show_warnings = true,
			highlights = {
				-- Default options for bold/italic
				defaults = {
					bold = false,
					italic = false,
				},
				-- Use `CursorLine`'s background color for `CursorLineNr`'s background
				use_cursorline_background = false,
			},
			integration = {
				lualine = {
					enabled = true,
					mode_section = nil,
					highlight = "bg",
				},
			},
		})
	end,
}
