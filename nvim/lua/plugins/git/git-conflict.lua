-- ~/.config/nvim/lua/Plugins/git/git-conflict.lua
return {
	"akinsho/git-conflict.nvim",
	version = "*",

	config = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "GitConflictDetected",
			callback = function()
				vim.notify("Conflict detected in " .. vim.fn.expand("<afile>"))
				-- vim.keymap.set("n", "cww", function()
				-- 	engage.conflict_buster()
				-- 	create_buffer_local_mappings()
				-- end, "Git Conflict")
			end,
		})

		require("git-conflict").setup({
			default_mappings = {
				ours = "<leader>Co",
				theirs = "<leader>Ct",
				none = "<leader>C0",
				both = "<leader>Cb",
				next = "<leader>Cn",
				prev = "<leader>Cp",
			},
			disable_diagnostics = false,
			hl = {
				incoming = "DiffAdd",
				current = "DiffText",
			},
		})
	end,
	-- keys = {
	--   { "<leader>gC", desc = "Git Conflict" },
	-- }
	-- Keybinds
	-- co — choose ours
	-- ct — choose theirs
	-- cb — choose both
	-- c0 — choose none
	-- ]x — move to previous conflict
	-- [x — move to next conflict
}
