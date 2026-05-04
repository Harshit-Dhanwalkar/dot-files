-- ~/.config/nvim/lua/plugins/appearance/nvim-scrollbar.lua

return {
	"petertriho/nvim-scrollbar",
	event = "BufReadPost",

	config = function()
		require("scrollbar").setup({
			show = true,
			show_in_active_only = false,
			set_highlights = true,
			folds = 1000,
			max_lines = false,
			hide_if_all_visible = false,
			throttle_ms = 100,
			handle = {
				text = " ",
				blend = 30,
				color = "#504945",
				color_nr = nil,
				highlight = "ScrollbarHandle",
				hide_if_all_visible = true,
			},
			marks = {
				Cursor = {
					text = "",
					priority = 0,
					gui = nil,
					color = nil,
					cterm = nil,
					color_nr = nil,
					highlight = "Normal",
				},
				Search = { text = { "-", "=" }, priority = 1, color = "#fe8019", highlight = "ScrollbarSearch" },
				Error = { text = { "-", "=" }, priority = 2, color = "#fb4934", highlight = "ScrollbarError" },
				Warn = { text = { "-", "=" }, priority = 3, color = "#fabd2f", highlight = "ScrollbarWarn" },
				Info = { text = { "-", "=" }, priority = 4, color = "#83a598", highlight = "ScrollbarInfo" },
				Hint = { text = { "-", "=" }, priority = 5, color = "#8ec07c", highlight = "ScrollbarHint" },
				Misc = { text = { "-", "=" }, priority = 6, color = "#d3869b", highlight = "ScrollbarMisc" },
				GitAdd = { text = "│", priority = 7, color = "#b8bb26", cterm = nil, highlight = "ScrollbarGitAdd" },
				GitChange = {
					text = "│",
					priority = 7,
					color = "#fabd2f",
					cterm = nil,
					highlight = "ScrollbarGitChange",
				},
				GitDelete = {
					text = "▁",
					priority = 7,
					color = "#fb4934",
					cterm = nil,
					highlight = "ScrollbarGitDelete",
				},
			},
			excluded_buftypes = { "terminal" },
			excluded_filetypes = { "prompt", "TelescopePrompt", "noice", "NvimTree", "dashboard", "alpha", "lazy" },
			handlers = { cursor = true, diagnostic = true, gitsigns = true, handle = true, search = false },
		})
	end,
}
