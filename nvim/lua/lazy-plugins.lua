-- ~/.config/nvim/lua/lazy.lua
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

	require("Plugins.conform"),
	require("Plugins.autopairs"),
	require("Plugins.appearance.bufferline"),
	-- require("Plugins.appearance.barbecue"),
	require("Plugins.appearance.colorscheme"),
	require("Plugins.appearance.fidget"),
	require("Plugins.appearance.indent-blackline"),
	require("Plugins.appearance.lualine"),
	require("Plugins.appearance.noice"),
	require("Plugins.appearance.modicator"),
	require("Plugins.appearance.lightswtich"),
	require("Plugins.appearance.twilight"),
	-- require("Plugins.appearance.undo-glow"),
	-- require("Plugins.appearance.smoothcursor"),
	-- require("Plugins.blink"),
	require("Plugins.comment"),
	require("Plugins.debug"),
	require("Plugins.utils.flash"),
	-- require("Plugins.others.undotree"),
	require("Plugins.others.vim-statuptime"),
	require("Plugins.git.diffview"),
	require("Plugins.git.lazygit"),
	require("Plugins.git.neogit"),
	require("Plugins.git.gitsigns"),
	require("Plugins.git.git-worktree"),
	require("Plugins.git.vim-flog"),
	require("Plugins.others.goto-preview"),
	require("Plugins.utils.vim-visual-multi"),
	-- require("Plugins.utils.harpoon"),
	-- require("Plugins.others.image"),
	require("Plugins.latex.vimtex"),
	-- require("Plugins.latex.illustrate"),
	require("Plugins.utils.tabout"),
	require("Plugins.utils.mini"),
	require("Plugins.neoclip"),
	require("Plugins.utils.nvim-cmp"),
	require("Plugins.utils.nvim-ufo"),
	require("Plugins.utils.nvim-tree"),
	-- require("Plugins.utils.neotree"), -- using nvim-tree
	require("Plugins.lazydev"),
	require("Plugins.lint"),
	require("Plugins.lsp.nvim-lspconfig"),
	require("Plugins.luvit-meta"),
	require("Plugins.telescope"),
	require("Plugins.utils.tiny-inline-diagnostic"),
	require("Plugins.utils.tiny-code-action"),
	require("Plugins.treesitter"),
	require("Plugins.treesitter-textobjects"),
	require("Plugins.utils.todo-comments"),
	require("Plugins.treesj"),
	require("Plugins.others.csvview"),
	require("Plugins.others.registers"),
	require("Plugins.others.registereditor"),
	require("Plugins.vim-sleuth"),
	require("Plugins.markdown.render-markdown"),
	require("Plugins.markdown.carrot"),
	require("Plugins.markdown.nvim-toc"),
	require("Plugins.markdown.vim-markdownfootnotes"),
	require("Plugins.markdown.markdown-table-mode"),
	-- require("Plugins.markdown.markdown-preview"),
	-- require("Plugins.markdown.peek"),
	-- require("Plugins.others.vim-tpipline"),
	-- require("Plugins.others.urlview"),
	-- require("Plugins.vim-tmux-navigator"),
	-- require("Plugins.rust.crates"),
	-- require("Plugins.rust.rustaceanvim"),
	-- require("Plugins.rust.rust-vim"),
	-- require("Plugins.rust.rust-tools"),
	-- require("Plugins.asm.who5673-nasm"),
	-- require("Plugins.asm.hexer"),
	-- require("Plugins.others.wilder"),
	-- require("Plugins.others.screenkey"),
	-- require("Plugins.others.showkeys"),
	require("Plugins.which-key"),
	-- require("Plugins.webdev.emmet"),
	require("Plugins.webdev.colorizer"),
	require("Plugins.webdev.vim-prettier"),
	-- require("Plugins.webdev.colortils"),
	-- require("Plugins.webdev.minty"),
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
	-- -- Snippet engine
	-- python3.11 -m pip install --user pynvim
	{ "quangnguyen30192/cmp-nvim-ultisnips", lazy = true },
	{
		"sirver/ultisnips",
		event = "InsertEnter",
		config = function()
			vim.g.UltiSnipsExpandTrigger = "<c-j>"
			vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
			vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"
			vim.g.UltiSnipsSnippetDirectories = {
				"UltiSnips", -- This is the default directory inside runtimepath
				vim.fn.expand("~/.config/nvim/lua/UltiSnips/"),
			}
		end,
		dependencies = {
			"honza/vim-snippets",
		},
	},
	-- "hrsh7th/cmp-vsnip",
	-- "hrsh7th/vim-vsnip",
	-- 'dcampos/nvim-snippy',
	-- 'dcampos/cmp-snippy',
	-- 'echasnovski/mini.snippets',
	-- 'abeldekat/cmp-mini-snippets',
	{ -- Swap -- g< and g>
		"machakann/vim-swap",
		event = "VeryLazy",
	},
	-- AI
	require("Plugins.ai.copilot"),
	require("Plugins.ai.copilot-cmp"),
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
