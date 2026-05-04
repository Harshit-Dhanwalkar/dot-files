-- ~/.config/nvim/lua/Plugins/appearance/neominimap.lua

return {
	"Isrothy/neominimap.nvim",
	lazy = false,

	keys = {
		-- Global Minimap Controls
		{ "<leader>nm", "<cmd>Neominimap Toggle<cr>", desc = "Toggle global minimap" },
		{ "<leader>no", "<cmd>Neominimap Enable<cr>", desc = "Enable global minimap" },
		{ "<leader>nc", "<cmd>Neominimap Disable<cr>", desc = "Disable global minimap" },
		{ "<leader>nr", "<cmd>Neominimap Refresh<cr>", desc = "Refresh global minimap" },

		-- Window-Specific Minimap Controls
		{ "<leader>nwt", "<cmd>Neominimap WinToggle<cr>", desc = "Toggle minimap for current window" },
		{ "<leader>nwr", "<cmd>Neominimap WinRefresh<cr>", desc = "Refresh minimap for current window" },
		{ "<leader>nwo", "<cmd>Neominimap WinEnable<cr>", desc = "Enable minimap for current window" },
		{ "<leader>nwc", "<cmd>Neominimap WinDisable<cr>", desc = "Disable minimap for current window" },

		-- Tab-Specific Minimap Controls
		{ "<leader>ntt", "<cmd>Neominimap TabToggle<cr>", desc = "Toggle minimap for current tab" },
		{ "<leader>ntr", "<cmd>Neominimap TabRefresh<cr>", desc = "Refresh minimap for current tab" },
		{ "<leader>nto", "<cmd>Neominimap TabEnable<cr>", desc = "Enable minimap for current tab" },
		{ "<leader>ntc", "<cmd>Neominimap TabDisable<cr>", desc = "Disable minimap for current tab" },

		-- Buffer-Specific Minimap Controls
		{ "<leader>nbt", "<cmd>Neominimap BufToggle<cr>", desc = "Toggle minimap for current buffer" },
		{ "<leader>nbr", "<cmd>Neominimap BufRefresh<cr>", desc = "Refresh minimap for current buffer" },
		{ "<leader>nbo", "<cmd>Neominimap BufEnable<cr>", desc = "Enable minimap for current buffer" },
		{ "<leader>nbc", "<cmd>Neominimap BufDisable<cr>", desc = "Disable minimap for current buffer" },

		---Focus Controls
		{ "<leader>nf", "<cmd>Neominimap Focus<cr>", desc = "Focus on minimap" },
		{ "<leader>nu", "<cmd>Neominimap Unfocus<cr>", desc = "Unfocus minimap" },
		{ "<leader>ns", "<cmd>Neominimap ToggleFocus<cr>", desc = "Switch focus on minimap" },
	},

	init = function()
		vim.g.neominimap = {
			auto_enable = false, --if true, Enable the plugin by default
			-- log_level = vim.log.levels.OFF,
			-- notification_level = vim.log.levels.INFO,
			-- log_path = vim.fn.stdpath("data") .. "/neominimap.log"
			exclude_filetypes = { "help", "bigfile" },
			exclude_buftypes = { "nofile", "nowrite", "quickfix", "terminal", "prompt" },
			x_multiplier = 5,
			y_multiplier = 1,
			buffer = { persist = true },
		}
	end,
}
