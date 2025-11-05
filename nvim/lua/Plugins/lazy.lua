-- ~/.config/nvim/lua/Plugins/lazy.lua
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
	require("Plugins.autoformat"),
	require("Plugins.autopairs"),
	require("Plugins.bufferline"),
	-- require("Plugins.blink"),
	require("Plugins.comment"),
	require("Plugins.colorscheme"),
	require("Plugins.debug"),
	require("Plugins.diffview"),
	require("Plugins.fidget"),
	require("Plugins.flash"),
	-- require("Plugins.formatting"),
	require("Plugins.gitsigns"),
	require("Plugins.gitstuff"),
	-- require("Plugins.git-worktree"),
	require("Plugins.goto-preview"),
	-- require("Plugins.harpoon"),
	-- require("Plugins.illustrate"),
	require("Plugins.image"),
	require("Plugins.indent-blackline"),
	require("Plugins.mini"),
	require("Plugins.neogit"),
	-- require("Plugins.neotree"),
	require("Plugins.noice"),
	require("Plugins.nvim-cmp"),
	require("Plugins.nvim-ufo"),
	require("Plugins.nvim-tree"),
	require("Plugins.lazydev"),
	require("Plugins.lint"),
	require("Plugins.lsp"),
	require("Plugins.lualine"),
	require("Plugins.luvit-meta"),
	require("Plugins.render-markdown"),
	-- require("Plugins.markown-preview"),
	require("Plugins.carrot"),
	-- require("Plugins.screenkey"),
	-- require("Plugins.showkeys"),
	-- require("Plugins.vim-tmux-navigator"),
	require("Plugins.telescope"),
	require("Plugins.tiny-inline-diagnostic"),
	require("Plugins.tiny-code-action"),
	require("Plugins.treesitter"),
	require("Plugins.treesitter-textobjects"),
	require("Plugins.todo-comments"),
	require("Plugins.treesj"),
	require("Plugins.twilight"),
	require("Plugins.vim-sleuth"),
	require("Plugins.vimtex"),
	require("Plugins.vim-visual-multi"),
	require("Plugins.rust.crates"),
	require("Plugins.rust.rustaceanvim"),
	require("Plugins.rust.rust-vim"),
	require("Plugins.rust.rust-tools"),
	-- require("Plugins.wilder"),
	require("Plugins.webdev.emmet"),
	require("Plugins.webdev.colorizer"),
	require("Plugins.which-key"),
	-- {
	-- 	"stevearc/dressing.nvim",
	-- 	opts = {},
	-- },
	-- {
	--   'mfusseneggger/nvim-dap',
	-- },
	-- project wise search
	--{
	-- 'mileszs/ack.vim'
	-- }
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
	-- "honza/vim-snippets",
	-- "hrsh7th/cmp-vsnip",
	-- "hrsh7th/vim-vsnip",
	-- 'quangnguyen30192/cmp-nvim-ultisnips',
	-- 'dcampos/nvim-snippy',
	-- 'dcampos/cmp-snippy',
	-- 'echasnovski/mini.snippets',
	-- 'abeldekat/cmp-mini-snippets',
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "", --⌘
			config = "", --🛠
			event = "", --📅
			ft = "", --📂
			init = "⚙",
			keys = "",
			plugin = "", --🔌
			runtime = "󰑮", --💻
			require = "󰽥", --🌙
			source = "󰈔", --📄
			start = "", --🚀
			task = "", --📌
			lazy = "󰒲 ", --💤
		},
	},
})
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
