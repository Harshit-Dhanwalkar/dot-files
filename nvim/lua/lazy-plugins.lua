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

	require("plugins.utils.autopairs"),
	require("plugins.utils.backout"),
	require("plugins.appearance.bufferline"),
	-- require("plugins.appearance.barbecue"),
	require("plugins.appearance.colorscheme"),
	require("plugins.appearance.fidget"),
	require("plugins.appearance.indent-blackline"),
	require("plugins.appearance.lualine"),
	require("plugins.appearance.noice"),
	require("plugins.appearance.indent-blackline"),
	-- require("plugins.appearance.neominimap"),
	-- require("plugins.appearance.pretty-fold"),
	-- require("plugins.appearance.nvim-ufo"),
	require("plugins.appearance.modicator"),
	require("plugins.appearance.lightswtich"),
	-- require("plugins.appearance.twilight"),
	require("plugins.appearance.undo-glow"),
	-- require("plugins.appearance.smoothcursor"),
	-- require("plugins.utils.blink"),
	require("plugins.utils.comment"),
	require("plugins.utils.debug"),
	require("plugins.utils.flash"),
	require("plugins.utils.flouride"),
	-- require("plugins.others.undotree"),
	require("plugins.others.vim-statuptime"),
	require("plugins.git.diffview"),
	require("plugins.git.lazygit"),
	require("plugins.git.neogit"),
	require("plugins.git.gitsigns"),
	require("plugins.git.git-worktree"),
	require("plugins.git.git-blame"),
	require("plugins.git.git-conflict"),
	require("plugins.git.gitgraph"),
	-- require("plugins.git.vim-flog"),
	require("plugins.others.goto-preview"),
	require("plugins.utils.vim-visual-multi"),
	require("plugins.utils.vim-matchup"),
	-- require("plugins.utils.harpoon"),
	-- require("plugins.others.image"),
	require("plugins.latex.vimtex"),
	-- require("plugins.latex.illustrate"),
	require("plugins.utils.tabout"),
	require("plugins.utils.mini"),
	require("plugins.neoclip"),
	require("plugins.utils.nvim-cmp"),
	require("plugins.utils.nvim-tree"),
	-- require("plugins.utils.neotree"),
	require("plugins.lazydev"),
	require("plugins.lint"),
	require("plugins.lsp.conform"),
	require("plugins.lsp.nvim-lspconfig"),
	require("plugins.luvit-meta"),
	require("plugins.telescope"),
	require("plugins.utils.tiny-inline-diagnostic"),
	require("plugins.utils.tiny-code-action"),
	require("plugins.treesitter"),
	require("plugins.treesitter-textobjects"),
	-- require("plugins.utils.treesj"),
	require("plugins.utils.todo-comments"),
	require("plugins.others.csvview"),
	require("plugins.utils.registers"),
	require("plugins.utils.registereditor"),
	require("plugins.vim-sleuth"),
	require("plugins.markdown.render-markdown"),
	require("plugins.markdown.follow-md-links"),
	require("plugins.markdown.carrot"),
	require("plugins.markdown.nvim-toc"),
	require("plugins.markdown.markdown-table-mode"),
	-- require("plugins.markdown.vim-markdownfootnotes"),
	-- require("plugins.markdown.markdown-preview"),
	-- require("plugins.markdown.peek"),
	-- require("plugins.others.vim-tpipline"),
	-- require("plugins.others.urlview"),
	-- require("plugins.vim-tmux-navigator"),
	-- require("plugins.python.venv-selector"),
	-- require("plugins.python.nvim-dap"),
	-- require("plugins.rust.crates"),
	-- require("plugins.rust.rustaceanvim"),
	-- require("plugins.rust.rust-vim"),
	-- require("plugins.rust.rust-tools"),
	-- require("plugins.asm.who5673-nasm"),
	-- require("plugins.asm.hexer"),
	-- require("plugins.others.wilder"),
	-- require("plugins.others.screenkey"),
	-- require("plugins.others.showkeys"),
	require("plugins.which-key"),
	require("plugins.webdev.colorizer"),
	require("plugins.webdev.cssvarviewer"),
	require("plugins.webdev.vim-prettier"),
	-- require("plugins.webdev.emmet"),
	-- require("plugins.webdev.colortils"),
	-- require("plugins.webdev.minty"),
	-- {"stevearc/dressing.nvim"},
	-- {"mfusseneggger/nvim-dap"},
	-- project wise search
	--{"mileszs/ack.vim"},
	--
	{ "nvim-neotest/nvim-nio" },
	-- Snippet engines
	-- python3.11 -m pip install --user pynvim
	{ "quangnguyen30192/cmp-nvim-ultisnips", lazy = true },
	{
		"sirver/ultisnips",
		config = function()
			vim.g.UltiSnipsExpandTrigger = "<C-j>"
			vim.g.UltiSnipsJumpForwardTrigger = "<Tab>"
			vim.g.UltiSnipsJumpBackwardTrigger = "<S-Tab>"
			vim.g.UltiSnipsSnippetDirectories = {
				"UltiSnips", -- default directory inside runtimepath
				vim.fn.expand("~/.config/nvim/lua/UltiSnips/"),
				vim.fn.expand("../UltiSnips/"),
				vim.fn.stdpath("config") .. "/lua/UltiSnips",
			}
		end,
		dependencies = {
			"honza/vim-snippets",
		},
	},
	-- luasnip
	-- "hrsh7th/cmp-vsnip",
	-- "hrsh7th/vim-vsnip",
	-- 'dcampos/nvim-snippy',
	-- 'dcampos/cmp-snippy',
	-- 'echasnovski/mini.snippets',
	-- 'abeldekat/cmp-mini-snippets',

	-- AI
	-- require("plugins.ai.copilot"),
	-- require("plugins.ai.copilot-cmp"),

	{ -- Swap -- g< and g>
		"machakann/vim-swap",
		event = "VeryLazy",
	},
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
