-- ~/.config/nvim/lua/Plugins/vimtex.lua
return {
	"lervag/vimtex",
	lazy = false, -- no lazy load VimTeX
	-- tag = "v2.15",
	ft = { "tex" }, -- Load plugin only for TeX
	config = function()
		vim.g.tex_flavor = "latex"
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_quickfix_mode = 0
		vim.opt.conceallevel = 2
		vim.g.tex_conceal = "abdmg"
		vim.g.tex_conceal_frac = 1
		vim.g.tex_superscripts = "[0-9a-zA-W.,:;+-<>/()=]"
		vim.g.tex_subscripts = "[0-9aehijklmnoprstuvx,+-/().]"
		vim.cmd("syntax enable")

		vim.g.vimtex_compiler_method = "latexmk" -- for better Asymptote support
		-- vim.g.vimtex_compiler_method = "custom"
		vim.g.vimtex_compiler_latexmk = {
			build_dir = "",
			continuous = 1,
			callback = 1,
			executable = "latexmk",
			options = {
				-- "-ps",
				"-pdf",
				"-shell-escape",
				"-verbose",
				"-interaction=nonstopmode",
				"-synctex=1",
				"-file-line-error",
				-- "%f",
			},
		}
	end,
}
