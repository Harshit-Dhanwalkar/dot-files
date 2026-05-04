-- ~/.config/nvim/lua/plugins/utils/vim-illuminate.lua

return {
	"RRethy/vim-illuminate",
	event = "BufReadPost",

	config = function()
		require("illuminate").configure({
			providers = { "lsp", "treesitter", "regex" },
			delay = 200,
			under_cursor = true,
			large_file_cutoff = 2000,
			large_file_overrides = { providers = { "lsp" } },
			filetypes_denylist = { "dirbuf", "dirvish", "fugitive", "NvimTree", "TelescopePrompt", "dashboard" },
		})

		vim.api.nvim_set_hl(0, "IlluminatedWordText", { underline = true })
		vim.api.nvim_set_hl(0, "IlluminatedWordRead", { underline = true })
		vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { underline = true, bold = true })
	end,
}
