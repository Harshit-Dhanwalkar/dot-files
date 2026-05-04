-- ~/.config/nvim/lua/Plugins/others/goto-preview.lua

-- return {
-- 	"rmagatti/goto-preview",
-- 	-- event = "BufEnter",
-- 	event = "LspAttach",
-- 	dependencies = "rmagatti/logger.nvim",
--
-- 	config = function()
-- 		require("goto-preview").setup({
-- 			default_mappings = true,
-- 		})
-- 		vim.keymap.set(
-- 			"n",
-- 			"gpd",
-- 			"<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
-- 			{ noremap = true, silent = true }
-- 		)
-- 		vim.keymap.set(
-- 			"n",
-- 			"gpD",
-- 			"<cmd>lua require('goto-preview').goto_preview_declaration()<CR>",
-- 			{ noremap = true, silent = true }
-- 		)
-- 		vim.keymap.set(
-- 			"n",
-- 			"gpr",
-- 			"<cmd>lua require('goto-preview').goto_preview_references()<CR>",
-- 			{ noremap = true, silent = true }
-- 		)
-- 		vim.keymap.set(
-- 			"n",
-- 			"gpi",
-- 			"<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
-- 			{ noremap = true, silent = true }
-- 		)
-- 		vim.keymap.set(
-- 			"n",
-- 			"gP",
-- 			"<cmd>lua require('goto-preview').close_all_win()<CR>",
-- 			{ noremap = true, silent = true }
-- 		)
-- 	end,
-- }

return {
	"rmagatti/goto-preview",
	event = "LspAttach",
	dependencies = "rmagatti/logger.nvim",

	keys = {
		{
			"gpd",
			function()
				require("goto-preview").goto_preview_definition()
			end,
			desc = "Preview definition",
		},
		{
			"gpD",
			function()
				require("goto-preview").goto_preview_declaration()
			end,
			desc = "Preview declaration",
		},
		{
			"gpi",
			function()
				require("goto-preview").goto_preview_implementation()
			end,
			desc = "Preview implementation",
		},
		{
			"gpr",
			function()
				require("goto-preview").goto_preview_references()
			end,
			desc = "Preview references",
		},
		{
			"gP",
			function()
				require("goto-preview").close_all_win()
			end,
			desc = "Close preview windows",
		},
	},

	opts = {
		width = 120,
		height = 15,
		border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" },
		default_mappings = false,
		resize_handling_options = {
			stop_on_insert_leave = false,
			stop_on_insert_key = false,
		},
		debug = false,
		opacity = nil,
		post_open_hook = function(buf, win)
			-- Set keymaps for preview window
			vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = buf, silent = true, desc = "Close preview" })
			vim.keymap.set("n", "<Esc>", "<Cmd>close<CR>", { buffer = buf, silent = true, desc = "Close preview" })
		end,
		-- references = {
		-- 	telescope = require("telescope.themes").get_dropdown({ hide_preview = false }),
		-- },
		focus_on_preview = false,
		dismiss_on_move = false,
		force_close_on_new_c = false,
		hidden = true,
	},
}
