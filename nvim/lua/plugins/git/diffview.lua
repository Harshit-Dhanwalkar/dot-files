-- ~/.config/nvim/lua/plugins/git/diffview.lua

return {
	"sindrets/diffview.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
		"DiffviewToggleFiles",
		"DiffviewFocusFiles",
		"DiffviewFileHistory",
	},

	config = function()
		local actions = require("diffview.actions")

		-- Setup Autocmd for panel highlights
		vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
			group = vim.api.nvim_create_augroup("rafi_diffview", { clear = true }),
			pattern = "diffview:///panels/*",
			callback = function()
				vim.opt_local.cursorline = true
				vim.opt_local.winhighlight = "CursorLine:WildMenu"
			end,
		})

		require("diffview").setup({
			enhanced_diff_hl = true,
			view = {
				default = {
					layout = "diff2_horizontal",
				},
				merge_tool = {
					layout = "diff3_mixed",
				},
			},
			keymaps = {
				-- { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git diff" },
				-- { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
				-- { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch history" },
				-- { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Close diff" },
				file_panel = {
					win_config = { position = "left", width = 35 },
					{ "n", "q", "<cmd>DiffviewClose<CR>" },
					{ "n", "h", actions.prev_entry },
					{ "n", "o", actions.focus_entry },
					{ "n", "gf", actions.goto_file },
					{ "n", "sg", actions.goto_file_split },
					{ "n", "st", actions.goto_file_tab },
					{ "n", "<C-r>", actions.refresh_files },
					{ "n", ";e", actions.toggle_files },
					{ "n", "1", actions.next_entry },
					{ "n", "2", actions.prev_entry },
					{ "n", "<cr>", actions.select_entry },
				},
				file_history_panel = {
					{ "n", "q", "<cmd>DiffviewClose<CR>" },
					{ "n", "o", actions.focus_entry },
					{ "n", "O", actions.options },
					{ "n", "g!", actions.options },
					{ "n", "<leader>q", "<cmd>DiffviewClose<CR>" },
				},
			},
		})
	end,
}
