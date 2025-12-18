-- ~/.config/nvim/lua/Plugins/git/gitgraph.lua
return {
	"isakbm/gitgraph.nvim",
	dependencies = { "sindrets/diffview.nvim" },
	---@type I.GGConfig
	opts = {
		symbols = {
			merge_commit = "M",
			commit = "*",
		},
		format = {
			timestamp = "%H:%M:%S %d-%m-%Y",
			fields = { "hash", "timestamp", "author", "branch_name", "tag" },
		},
	},
	init = function()
		vim.keymap.set("n", "<leader>go", function()
			require("gitgraph").draw({}, { all = true, max_count = 5000 })
		end, { desc = "New Git Graph" })
	end,
}
