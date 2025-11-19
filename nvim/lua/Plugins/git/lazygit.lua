-- ~/.config/nvim/lua/Plugins/git/lazygit.lua
return {
	"kdheepak/lazygit.nvim",
	enabled = false,
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	-- window border thing
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	-- setting up with keys={} allows plugin to load when command runs at the start
	keys = {
		{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open lazy git" },
	},
}
