-- ~/.config/nvim/lua/Plugins/treesj.lua
return {
	"Wansmer/treesj",
	keys = {
		"<space>m",
		"<space>j",
		"<space>s",
	},
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("treesj").setup({})
	end,
}
