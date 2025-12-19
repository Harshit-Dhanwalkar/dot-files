return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-telescope/telescope.nvim",
		"mfussenegger/nvim-dap-python",
	},
	cmd = "VenvSelect",
	opts = function(_, opts)
		local has_dap, _ = pcall(require, "dap-python")
		return vim.tbl_deep_extend("force", opts or {}, {
			dap_enabled = has_dap,
			name = {
				"venv",
				".venv",
				"env",
				".env",
			},
		})
	end,
	keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
}
