-- ~/.config/nvim/lua/Plugins/others/screenkey.lua
return {
	"NStefan002/screenkey.nvim",
	event = "VimEnter",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("screenkey").setup({
			show_leader = true, -- Show the leader key in mappings
			clear_after = 2, -- Clear the display after 2 seconds of inactivity
			compress_after = 3, -- Compress repeated keystrokes after 3 repetitions
			-- hl_groups = {
			-- 	["screenkey.hl.key"] = { link = "DiffAdd" },
			-- 	["screenkey.hl.map"] = { link = "DiffDelete" },
			-- },
		})
	end,
}
