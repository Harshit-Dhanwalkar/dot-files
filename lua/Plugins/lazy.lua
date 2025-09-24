local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "failed to clone lazy.nvim:\n", "Errormsg" },
			{ out, "Warningmsg" },
			{ "\npress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	opts = {
		rocks = {
			hererocks = false, -- Disable LuaRocks
			enabled = false, -- Disable LuaRocks
		},
	},
	-- Detect tabstop and shiftwidth automatically
	{ "tpope/vim-sleuth" },
	require("Plugins.diffview"),
	require("Plugins.which-key"),
	require("Plugins.neogit"),
	require("Plugins.telescope"),
	require("Plugins.lazydev"),
	require("Plugins.luvit-meta"),
	require("Plugins.nvim-lspconfig"),
	require("Plugins.autoformat"),
	require("Plugins.autocomplete"),
	require("Plugins.colorscheme"),
	require("Plugins.todo-comments"),
	require("Plugins.mini"),
	require("Plugins.bufferline"),
	require("Plugins.comment"),
	require("Plugins.treesitter"),
	require("Plugins.lualine"),
	require("Plugins.nvim-ufo"),
	require("Plugins.noice"),
	require("Plugins.nvim-tree"),
	-- require("Plugins.neotree"),
	require("Plugins.vimtex"),
	-- require("Plugins.harpoon"),
	-- require("Plugins.git-worktree"),
	-- require("Plugins.formatting"),
	require("Plugins.render-markdown"),
	require("Plugins.image"),
	-- {
	-- 	"sirver/ultisnips",
	-- 	config = function()
	-- 		vim.g.UltiSnipsExpandTrigger = -"<tab>"
	-- 		vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
	-- 		vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"
	-- 		vim.g.UltiSnipsSnippetDirectories = { vim.fn.expand("~/.config/nvim/lua/Plugins/UltiSnips") }
	-- 	end,
	-- 	event = "InsertEnter",
	-- },
	-- Add a snippet collection (vim-snippets)
	-- {
	-- 	"honza/vim-snippets",
	-- 	lazy = true, -- Load this plugin lazily
	-- },
	-- "hrsh7th/cmp-vsnip",
	-- "hrsh7th/vim-vsnip",
	-- 'quangnguyen30192/cmp-nvim-ultisnips',
	-- 'dcampos/nvim-snippy',
	-- 'dcampos/cmp-snippy',
	-- 'echasnovski/mini.snippets',
	-- 'abeldekat/cmp-mini-snippets',
	require("Plugins.vim-visual-multi"),
	require("Plugins.tiny-inline-diagnostic"),
	require("Plugins.tiny-code-action"),
	-- require("Plugins.goto-preview"),
	require("Plugins.rust.crates"),
	require("Plugins.rust.rust-vim"),
	require("Plugins.rust.rust-tools"),
	require("Plugins.rust.rustaceanvim"),
	-- {
	--   'mfusseneggger/nvim-dap',
	-- },
	-- {
	-- hrsh7th/nvim-cmp",
	--  table.insert(M.sources, {name = 'crates"}))
	-- },
	-- project wise search
	--{
	-- 'mileszs/ack.vim'
	-- }
	require("Plugins.fidget"),
	require("Plugins.debug"),
	require("Plugins.indent-blackline"),
	require("Plugins.lint"),
	require("Plugins.autopairs"),
	require("Plugins.gitsigns"),
	-- require("Plugins.screenkey"),
	require("Plugins.webdev.emmet"),
	require("Plugins.webdev.colorizer"),
	require("Plugins.illustrate"),
}, {
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
