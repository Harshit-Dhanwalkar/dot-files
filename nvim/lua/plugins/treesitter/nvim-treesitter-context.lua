-- ~/.config/nvim/lua/plugins/treesitter/nvim-treesitter-context.lua

return {
	"nvim-treesitter/nvim-treesitter-context",
	event = "BufReadPost",

	config = function()
		require("treesitter-context").setup({
			enable = true,
			max_lines = 3,
			min_window_height = 0,
			line_numbers = true,
			multiline_threshold = 20,
			trim_scope = "outer",
			mode = "cursor",
			separator = "─",
			zindex = 20,
		})
		vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#282828" })
		vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = "#fabd2f", bg = "#282828" })
		vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { fg = "#504945" })
	end,
}
