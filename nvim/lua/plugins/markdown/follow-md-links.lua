-- ~/.config/nvim/lua/plugins/markdown/follow-md-lonks.lua
return {
	"jghauser/follow-md-links.nvim",
	ft = "markdown",
	keys = {
		{
			"<leader>ml",
			function()
				require("follow-md-links").follow_link()
			end,
			mode = "n",
			desc = "Follow markdown link",
			ft = "markdown",
		},
	},

	config = function()
		-- Immediately remove the <CR> it added
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function(ev)
				-- Delete normal-mode <CR> in this buffer only
				pcall(vim.keymap.del, "n", "<CR>", { buffer = ev.buf })
			end,
			once = false, -- for all markdown buffers
		})
	end,
}
