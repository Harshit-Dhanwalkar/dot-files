-- ~/.config/nvim/lua/plugins/utils/comment.lua
return {
	"numToStr/Comment.nvim",
	config = function()
		require("Comment").setup({
			create_mappings = false,
			extra = {
				ft = {
					asm = { " ;" },
					s = { " ;" },
				},
			},
		})
	end,
}
