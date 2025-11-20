-- ~/.config/nvim/lua/Plugins/others/twilight.lua
return {
	"folke/twilight.nvim",
	config = function()
		require("twilight").setup({
			dimming = {
				alpha = 0.2, -- amount of dimming
				color = { "Normal", "#ffffff" },
				term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
				inactive = true, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
			},
			context = 10, -- amount of lines to show around the current line
			treesitter = true,
			expand = {
				"function",
				"method",
				"table",
				"if_statement",
			},
			exclude = {},
		})
	end,
}
