-- ~/.config/nvim/lua/Plugins/others/vim-statuptime.lua
return {
	"dstein64/vim-startuptime",
	event = "VimEnter",
	cmd = "StartupTime",
	dependencies = { "romainl/vim-qf" },
}
