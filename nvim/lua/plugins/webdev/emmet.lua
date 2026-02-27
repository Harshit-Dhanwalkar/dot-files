-- ~/.config/nvim/lua/plugins/webdev/emmet.lua
return {
	"mattn/emmet-vim",
	config = function()
		vim.g.user_emmet_leader_key = ","
	end,
}
