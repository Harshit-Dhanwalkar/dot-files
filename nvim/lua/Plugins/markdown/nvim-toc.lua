-- ~/.config/nvim/lua/Plugins/markdown/nvim-toc.lua
-- Switch to https://github.com/YousefHadder/markdown-plus.nvim
return {
	"richardbizik/nvim-toc",
	config = function()
		require("nvim-toc").setup({
			toc_header = "Table of Contents",
		})
	end,
}
