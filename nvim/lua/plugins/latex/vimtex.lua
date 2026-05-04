-- ~/.config/nvim/lua/plugins/vimtex.lua
return {
	"lervag/vimtex",
	lazy = false, -- no lazy load VimTeX
	ft = { "tex" }, -- Load plugin only for TeX

	config = function()
		vim.g.tex_flavor = "latex"
		vim.g.vimtex_view_method = "zathura"
		-- vim.g.vimtex_view_general_viewer = 'okular'
		vim.g.vimtex_quickfix_mode = 0
		vim.opt.conceallevel = 2
		vim.g.vimtex_clean_enabled = 1
		vim.g.tex_conceal = "abdmg"
		vim.g.tex_conceal_frac = 1
		vim.g.tex_superscripts = "[0-9a-zA-W.,:;+-<>/()=]"
		vim.g.tex_subscripts = "[0-9aehijklmnoprstuvx,+-/().]"
		vim.g.texlivePackage = "pkgs.texlive.combined.scheme-full"
		vim.cmd("syntax enable")

		vim.g.vimtex_compiler_method = "latexmk"
		--  vimtex-compiler-latexmk  : http://users.phys.psu.edu/~collins/software/latexmk-jcc
		--  vimtex-compiler-latexrun : https://github.com/aclements/latexrun
		--  vimtex-compiler-tectonic : https://tectonic-typesetting.github.io/
		--  vimtex-compiler-arara    : https://github.com/cereda/arara
		--  vimtex-compiler-generic

		vim.g.vimtex_compiler_latexmk = {
			-- build_dir = "./temp",
			aux_dir = "./aux",
			continuous = 1,
			callback = 1,
			executable = "latexmk",
			options = {
				"-pdf",
				"-shell-escape",
				"-verbose",
				"-interaction=nonstopmode",
				"-synctex=1",
				"-file-line-error",
			},
		}

		vim.g.vimtex_clean_extensions = {
			"aux",
			"bbg",
			"bib",
			"blg",
			"bst",
			"fdb_latexmk",
			"fls",
			"idx",
			"ind",
			"lof",
			"log",
			"lot",
			"nav",
			"out",
			"toc",
			"run.xml",
			"snm",
			"synctex.gz",
			"bbl",
			-- beamer-specific files
			"nav",
			"snm",
			"vrb",
			"vtc",
			"bcf",
			"xml",
			"thm",
			"upa",
			"upb",
		}
	end,
}
