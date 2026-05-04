-- ~/.config/nvim/lua/plugins/git/git-blame.lua

return {
	-- Git Lens
	"f-person/git-blame.nvim",

	config = function()
		--vim.g.gitblame_ignored_filetypes = { "toggleterm" }
		vim.g.gitblame_date_format = "%x %r"
		vim.g.gitblame_message_template = "<author> • <date> • <summary> • <sha>"
	end,
}
