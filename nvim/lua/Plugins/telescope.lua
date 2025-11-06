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
			},
		})
		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
	end,
}
