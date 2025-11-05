-- ~/.config/nvim/lua/Plugins/rust/rust-vim.lua
return {
	"rust-lang/rust.vim",
	ft = "rust",
	init = function()
		vim.g.rustfmt_autosave = 1
	end,
}
