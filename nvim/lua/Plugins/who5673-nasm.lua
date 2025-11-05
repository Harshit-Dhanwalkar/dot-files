-- ~/.config/nvim/lua/Plugins/who5673-nasm.lua
-- Run `:TSInstall nasm`
-- This only trigger/load for filetype nsam, (ft = nasm)
-- So force Neovim to treat .asm and .s as NASM files.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.asm", "*.s" },
	command = "set filetype=nasm",
})
return {
	"Who5673/who5673-nasm",
	dependencies = {
		"L3MON4D3/LuaSnip",
		"hrsh7th/nvim-cmp",
	},
	ft = "nasm",
	lazy = true,
}
