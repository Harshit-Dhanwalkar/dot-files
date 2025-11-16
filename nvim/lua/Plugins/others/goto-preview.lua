-- ~/.config/nvim/lua/Plugins/others/goto-preview.lua
return {
	"rmagatti/goto-preview",
	event = "BufEnter",
	dependencies = "rmagatti/logger.nvim",
	config = function()
		require("goto-preview").setup({
			default_mappings = true,
		})
		vim.keymap.set(
			"n",
			"gpd",
			"<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
			{ noremap = true, silent = true }
		)
		vim.keymap.set(
			"n",
			"gpr",
			"<cmd>lua require('goto-preview').goto_preview_references()<CR>",
			{ noremap = true, silent = true }
		)
		vim.keymap.set(
			"n",
			"gpi",
			"<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
			{ noremap = true, silent = true }
		)
		vim.keymap.set(
			"n",
			"gP",
			"<cmd>lua require('goto-preview').close_all_win()<CR>",
			{ noremap = true, silent = true }
		)
	end,
}
