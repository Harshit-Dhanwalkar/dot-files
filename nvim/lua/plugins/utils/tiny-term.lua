-- ~/.config/nvim/lua/plugins/utils/tiny-term.lua

return {
	"jellydn/tiny-term.nvim",
	config = function()
		require("tiny-term").setup()
	end,
}
