-- ~/.config/yazi/init.lua

-- local greetings = require("greetings")
-- greetings.entry()

require("duck-radar"):setup({
	-- Extra dirs to search in addition to ~/Downloads, ~/Documents, ~/Desktop, ~/Pictures
	dirs = {
		-- "/path/to/extra/dir",
	},
	-- 'find' or 'fd'
	app = "find",
	-- Time range; when using fd, use its format (e.g. "7d") instead of find's (e.g. "7")
	changedWithin = "7",
	-- Max depth to search. 2 for faster, 4 for deeper search
	maxDepth = "3",
	-- Amount of results to show
	resultLimit = 200,
})

require("current-size"):setup({
	equal_ignore = { "~", "/", "/home" }, -- full path match
	-- sub_ignore = {"~/harshitpd/master","~/harshit/venv"} -- sub path match
})

require("telegram-send"):setup({
	-- command = "telegram-send --file",
	command = "~/.config/yazi/plugins/telegram-send.yazi/telegram-send-env/bin/telegram-send --file",
	notification = true,
})

require("copy-file-contents"):setup({
	append_char = "\n",
	notification = true,
})
