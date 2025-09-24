-- ~/.config/nvim/lua/Plugins/nvim-ufo.lua
return {
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		config = function()
			require("ufo").setup({
				provider_selector = function(_, _, _)
					return { "treesitter", "indent" }
				end,
				open_fold_hl_timeout = 0, -- Disable highlight timeout after opening
			})

			vim.o.foldenable = true
			vim.o.foldcolumn = "0" -- '0' is not bad
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99

			-- za to fold at cursor location is already enabled
			vim.keymap.set("n", "zr", require("ufo").openAllFolds)
			vim.keymap.set("n", "zm", require("ufo").closeAllFolds)
		end,
	},
}
