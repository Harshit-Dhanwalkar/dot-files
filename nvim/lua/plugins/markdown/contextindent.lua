-- ~/.config/nvim/lua/plugins/markdown/contextindent.lua

return {
	"wurli/contextindent.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("contextindent").setup({
			pattern = "*",
		})
	end,
}
