-- ~/.config/nvim/lua/Plugins/vimtex.lua
return {
	"lervag/vimtex",
	lazy = false, -- no lazy load VimTeX
	-- tag = "v2.15",
	ft = "tex", -- Load plugin only for TeX
	config = function()
		vim.g.tex_flavor = "latex"
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_quickfix_mode = 0
		vim.opt.conceallevel = 2
		vim.g.tex_conceal = "abdmg"
		vim.cmd("syntax enable")
		vim.g.vimtex_compiler_latexmk = {
			build_dir = "",
			continuous = 1,
			options = {
				"-ps",
				-- "-pdf",
				"-shell-escape",
				"-interaction=nonstopmode",
				"-synctex=1",
			},
		}
	end,
}
