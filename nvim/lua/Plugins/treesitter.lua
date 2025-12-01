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
			"vim",
			"vimdoc",
			-- "rust",
			"html",
			"css",
			"javascript",
			-- "typescript",
			"json",
			"query",
			"diff",
			-- "wgsl",
			-- "gdscript",
			-- "gdshader",
		},
		auto_install = true, -- Autoinstall languages that are not installed
		sync_install = true,
		highlight = {
			enable = true,
			disable = { "latex" }, -- Disable Treesitter highlighting for LaTeX
			additional_vim_regex_highlighting = { "markdown", "ruby" },
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
	--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
	--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
	--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
