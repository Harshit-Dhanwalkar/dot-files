-- ~/.config/nvim/lua/Plugins/ai/copilot.lua
-- go to : https://github.com/login/device/ and then Insert the code shown in the terminal to authenticate copilot
return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	dependencies = {
		"copilotlsp-nvim/copilot-lsp", -- for NES functionality
	},
	init = function()
		vim.g.copilot_nes_debounce = 500
	end,
	opts = {
		suggestion = {
			enabled = true,
			auto_trigger = true,
			debounce = 75,
			keymap = {
				accept = "<M-l>", -- alt + l
				accept_word = false,
				accept_line = false,
				next = "<M-]>", -- alt + ]
				prev = "<M-[>", -- alt + [
				dismiss = "<C-]>", -- ctrl + ]
			},
		},
		panel = {
			enabled = false,
		},
		filetypes = {
			["*"] = true,
		},
	},
	config = function(_, opts)
		require("copilot").setup(opts)
	end,
}
