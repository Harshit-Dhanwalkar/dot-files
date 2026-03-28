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
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		{ "nvim-telescope/telescope-frecency.nvim", version = "*" },
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
		-- 	"nvim-telescope/telescope-bibtex.nvim",
		-- 	config = function()
		-- 		require("telescope").setup({
		-- 			extensions = {
		-- 				bibtex = {
		-- 					depth = 1, -- Depth for the *.bib file
		-- 					custom_formats = {},
		-- 					format = "",
		-- 					global_files = {},
		-- 					search_keys = { "author", "year", "title", "publisher", "label" },
		-- 					citation_format = "{{author}} ({{year}}), {{title}}.",
		-- 					-- citation_format = "[[^@{{label}}]]: {{author}} ({{year}}), {{title}}.",
		-- 					citation_trim_firstname = true,
		-- 					citation_max_auth = 2,
		-- 					context = true,
		-- 					context_fallback = true,
		-- 					wrap = false,
		-- 					-- mappings = {
		-- 					-- 	i = {
		-- 					-- 		["<CR>"] = bibtex_actions.key_append("%s"), -- format is determined by filetype if the user has not set it explictly
		-- 					-- 		["<C-e>"] = bibtex_actions.entry_append,
		-- 					-- 		["<C-c>"] = bibtex_actions.citation_append("{{author}} ({{year}}), {{title}}."),
		-- 					-- 	},
		-- 					-- },
		-- 				},
		-- 			},
		-- 		})
		-- 	end,
		-- },
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
		pcall(require("telescope").load_extension, "telescope-env")
		-- pcall(require("telescope").load_extension, "bibtex")
	end,
}
