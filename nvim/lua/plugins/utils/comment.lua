-- ~/.config/nvim/lua/plugins/utils/comment.lua

return {
	"numToStr/Comment.nvim",
	lazy = false, -- load early so mappings work immediately

	config = function()
		require("Comment").setup({
			-- create_mappings = false,
			extra = {
				ft = {
					asm = { " ;" },
					s = { " ;" },
				},
			},
			-- keys = {
			-- 	{
			-- 		"<C-/>",
			-- 		function()
			-- 			require("Comment.api").toggle.linewise.current()
			-- 		end,
			-- 		mode = {
			-- 			"n",
			-- 			"i",
			-- 		},
			-- 		desc = "Comment/uncomment line",
			-- 	},
			-- 	{
			-- 		"<C-_>",
			-- 		function()
			-- 			require("Comment.api").toggle.linewise.current()
			-- 		end,
			-- 		mode = {
			-- 			"n",
			-- 			"i",
			-- 		},
			-- 		desc = "Comment/uncomment line",
			-- 	},
			-- 	{
			-- 		"<C-/>",
			-- 		"<Esc><Cmd>lua require('Comment.api').locked('toggle.linewise')(vim.fn.visualmode())<CR>gv",
			-- 		mode = "x",
			-- 		desc = "Comment/uncomment selection",
			-- 		silent = true,
			-- 		remap = false,
			-- 	},
			-- 	{
			-- 		"<C-_>",
			-- 		"<Esc><Cmd>lua require('Comment.api').locked('toggle.linewise')(vim.fn.visualmode())<CR>gv",
			-- 		mode = "x",
			-- 		desc = "Comment/uncomment selection",
			-- 		silent = true,
			-- 		remap = false,
			-- 	},
			-- },
		})
	end,
}
