-- ~/.config/nvim/lua/Plugins/comment.lua
return {
	"numToStr/Comment.nvim",
	config = function()
		require("Comment").setup({
			create_mappings = false,
		})
	end,
}
