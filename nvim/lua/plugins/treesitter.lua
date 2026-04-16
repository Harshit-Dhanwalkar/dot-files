-- ~/.config/nvim/lua/Plugins/treesitter.lua
-- npm install -g tree-sitter-cli
-- which tree-sitter
-- tree-sitter --version
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	main = "nvim-treesitter.configs",
	-- See `:help nvim-treesitter`
	dependencies = {
		{ "JoosepAlviste/nvim-ts-context-commentstring" },
		{ "nvim-treesitter/nvim-tree-docs" },
	},
	opts = {
		ensure_installed = {
			"bash",
			"c",
			"cpp",
			"python",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"latex",
			-- "rust",
			"html",
			"css",
			"javascript",
			-- "typescript",
			"json",
			"toml",
			"yaml",
			"query",
			"diff",
			-- "wgsl",
			-- "gdscript",
			-- "gdshader",
			"query",
			"vim",
			"vimdoc",
		},
		auto_install = true, -- Autoinstall languages that are not installed
		sync_install = true,
		autopairs = {
			enable = true,
		},
		highlight = {
			enable = true,
			disable = { "latex" },
			-- additional_vim_regex_highlighting = { "markdown", "ruby" },
		},
		indent = {
			enable = true,
			disable = { "markdown", "ruby" },
		},
		rainbow = {
			enable = true,
			extended_mode = true,
			max_file_lines = nil,
		},
	},
	-- Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
	-- Show current context: https://github.com/nvim-treesitter/nvim-treesitter-context
	-- Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects

	-- vim.api.nvim_create_autocmd("FileType", {
	-- 	pattern = ensure_installed,
	--
	-- 	callback = function(args)
	-- 		local ft = vim.bo[args.buf].filetype
	-- 		local lang = vim.treesitter.language.get_lang(ft)
	-- 		if lang == nil then
	-- 			return
	-- 		end
	--
	-- 		-- check if parser is available
	-- 		local is_parser_available = vim.treesitter.language.add(lang)
	-- 		if not is_parser_available then
	-- 			local available_langs = vim.g.ts_available or nvim_treesitter.get_available()
	-- 			if not vim.g.ts_available then
	-- 				vim.g.ts_available = available_langs
	-- 			end
	--
	-- 			if vim.tbl_contains(available_langs, lang) then
	-- 				-- install treesitter parsers and queries
	-- 				local install_msg = string.format("Installing parsers and queries for %s", lang)
	-- 				vim.print(install_msg)
	-- 				require("nvim-treesitter").install(lang)
	-- 			end
	-- 		end
	--
	-- 		if vim.treesitter.language.add(lang) then
	-- 			-- start treesitter highlighting
	-- 			vim.treesitter.start(args.buf, lang)
	--
	-- 			-- the following two statements will enable treesitter folding
	-- 			-- vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
	-- 			-- vim.wo[0][0].foldmethod = "expr"
	--
	-- 			-- enable treesitter-based indentation
	-- 			-- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	-- 		end
	-- 	end,
	-- }),
}
