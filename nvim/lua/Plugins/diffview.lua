-- ~/.config/nvim/lua/Plugins/diffview.lua
return {
	"sindrets/diffview.nvim",
	dependencies = "nvim-lua/plenary.nvim", -- Required dependency
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" }, -- Lazy-load on commands
	config = function()
		require("diffview").setup({
			view = {
				merge_tool = {
					layout = "diff3_mixed", -- Use a diff3 layout for merge conflicts
				},
			},
			keymaps = {
				view = {
					["<leader>e"] = "<cmd>DiffviewToggleFiles<CR>", -- Toggle file panel
					["<leader>q"] = "<cmd>DiffviewClose<CR>", -- Close Diffview
				},
				file_panel = {
					["1"] = "next_entry", -- Move to next file entry
					["2"] = "prev_entry", -- Move to previous file entry
					["<cr>"] = "select_entry", -- Open file diff
				},
				file_history_panel = {
					["g!"] = "options", -- Toggle diff options
					["<leader>q"] = "<cmd>DiffviewClose<CR>", -- Close Diffview
				},
			},
		})
	end,
}
