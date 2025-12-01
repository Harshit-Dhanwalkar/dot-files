-- ~/.config/nvim/lua/Plugins/telescope.lua
return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function() -- `cond` is a condition used to determine whether this plugin should be installed and loaded.
				return vim.fn.executable("make") == 1
			end,
		},
		{
			"nvim-telescope/telescope-ui-select.nvim",
		},
		{
			"nvim-tree/nvim-web-devicons",
			enabled = vim.g.have_nerd_font,
		},
		{
			"nvim-telescope/telescope-frecency.nvim",
			version = "*",
		},
		-- {
		-- 	"nvim-telescope/telescope-media-files.nvim",
		-- 	event = "VeryLazy",
		-- 	enabled = function()
		-- 		-- return vim.fn.executable("ueberzug")
		-- 		return vim.fn.executable("kitty")
		-- 	end,
		-- 	config = function()
		-- 		require("telescope").load_extension("media_files")
		-- 	end,
		-- },
		{
			"crispgm/telescope-heading.nvim",
			event = "VeryLazy",
			config = function()
				require("telescope").load_extension("heading")
			end,
		},
		-- {
		-- 	"nvim-telescope/telescope-fzf-writer.nvim",
		-- 	after = { "telescope.nvim" },
		-- 	config = function()
		-- 		require("telescope").load_extension("fzf_writer")
		-- 	end,
		-- },
		-- {
		-- 	"nvim-telescope/telescope-file-browser.nvim",
		-- 	after = { "telescope.nvim" },
		-- 	config = function()
		-- 		require("telescope").load_extension("file_browser")
		-- 	end,
		-- },
		-- use {"sunjon/telescope-arecibo.nvim",
		--   after = {'telescope.nvim'},
		--   rocks = {"openssl", "lua-http-parser"},
		--   config = function() require('telescope').load_extension('arecibo') end
		-- }
	},
	config = function()
		-- Two important keymaps to use while in Telescope are:
		--  - Insert mode: <c-/> -- to show keymaps for the current Telescope picker
		--  - Normal mode: ?
		-- [[ Configure Telescope ]]
		-- See `:help telescope` and `:help telescope.setup()`
		require("telescope").setup({
			-- defaults = {
			--   mappings = {
			--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
			--   },
			-- },
			-- pickers = {}
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
				frecency = {
					default_weights = { recency = 1.0, frequency = 0.5 },
				},
			},
		})
		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
		pcall(require("telescope").load_extension, "frecency")
	end,
}
