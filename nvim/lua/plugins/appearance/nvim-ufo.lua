-- ~/.config/nvim/lua/Plugins/appearance/nvim-ufo.lua
local ftMap = {
	vim = "indent",
	python = { "indent" },
	git = "",
}

return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async",
	},
	config = function()
		require("ufo").setup({
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }
			end,
			-- open_fold_hl_timeout = 150, -- `0` Disable highlight timeout after opening
			-- close_fold_kinds_for_ft = {
			-- 	default = { "imports", "comment" },
			-- 	json = { "array" },
			-- 	c = { "comment", "region" },
			-- },
			-- close_fold_current_line_for_ft = {
			-- 	default = true,
			-- 	c = false,
			-- },
			preview = {
				win_config = {
					border = { "", "─", "", "", "", "─", "", "" },
					winhighlight = "Normal:Folded",
					winblend = 0,
				},
				mappings = {
					scrollU = "<C-u>",
					scrollD = "<C-d>",
					jumpTop = "[",
					jumpBot = "]",
				},
			},
		})

		vim.o.foldenable = true
		vim.o.foldcolumn = "1" -- '0' is not bad
		vim.o.foldlevel = 99
		vim.o.foldlevelstart = 99

		vim.keymap.set("n", "zR", require("ufo").openAllFolds)
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
		vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
		vim.keymap.set("n", "zm", function()
			require("ufo").closeFoldsWith(1) -- closes current-level fold
		end) -- closeAllFolds == closeFoldsWith(0)
		vim.keymap.set("n", "K", function()
			local winid = require("ufo").peekFoldedLinesUnderCursor()
			if not winid then
				-- choose one of coc.nvim and nvim lsp
				-- vim.fn.CocActionAsync("definitionHover") -- coc.nvim
				vim.lsp.buf.hover()
			end
		end)
	end,
}
