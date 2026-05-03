-- ~/.config/yazi/init.lua

-- local greetings = require("greetings")
-- greetings.entry()

-- Topline and bottomline
local tokyo_night_theme = require("yatline-tokyo-night"):setup("night") -- or moon/storm/day
require("yatline"):setup({
	theme = tokyo_night_theme,
	header_line = {
		left = {
			section_a = { { type = "line", name = "tabs" } },
			section_b = { { type = "coloreds", custom = false, name = "hostname_username" } },
			section_c = { { type = "coloreds", custom = false, name = "symlink" } },
		},
		right = {
			section_a = { { type = "string", name = "date", params = { "%X" } } },
			section_b = { { type = "coloreds", custom = false, name = "githead" } },
			section_c = { { type = "coloreds", custom = false, name = "page_count" } },
		},
	},
})
require("yatline-hostname-username"):setup({
	color = "silver",
	mode = "both", -- "host", "user", "both"
})
require("yatline-githead"):setup({
	order = {
		"branch",
		"remote",
		"tag",
		"commit",
		"behind_ahead_remote",
		"stashes",
		"state",
		"staged",
		"unstaged",
		"untracked",
	},
	show_numbers = true, -- shows staged, unstaged, untracked, stashes count

	-- Branch
	show_branch = true,
	branch_prefix = "",
	branch_color = tokyo_night_theme.blue,
	branch_symbol = "",
	branch_borders = "",

	show_remote_branch = true, -- only shown if different from local branch
	always_show_remote_branch = false, -- always show remote branch even if it the same as local branch
	always_show_remote_repo = false, -- Adds `origin/` if `always_show_remote_branch` is enabled
	remote_branch_prefix = ":",

	show_tag = true, -- only shown if branch is not available
	always_show_tag = false,
	tag_color = tokyo_night_theme.magenta,
	tag_symbol = "#",
	--
	show_commit = true, -- only shown if branch AND tag are not available
	always_show_commit = false,
	commit_color = tokyo_night_theme.orange,
	commit_symbol = "@",

	-- Status indicators
	show_behind_ahead_remote = true,
	behind_remote_color = tokyo_night_theme.comment,
	behind_remote_symbol = "⇣",
	ahead_remote_color = tokyo_night_theme.purple,
	ahead_remote_symbol = "⇡",
	--
	show_stashes = true,
	stashes_color = tokyo_night_theme.teal,
	stashes_symbol = "$",

	-- State
	show_state = true,
	show_state_prefix = true,
	state_color = tokyo_night_theme.red,
	state_symbol = "~",
	--
	show_staged = true,
	staged_color = tokyo_night_theme.green,
	staged_symbol = "+",
	--
	show_unstaged = true,
	unstaged_color = tokyo_night_theme.yellow,
	unstaged_symbol = "!",
	--
	show_untracked = true,
	untracked_color = tokyo_night_theme.cyan,
	untracked_symbol = "?",
})
require("yatline-symlink"):setup()
require("yatline-page-counter"):setup()

-- Bottomline
-- require("yaziline"):setup({
-- 	cut_files_color = "#892E3D",
--
-- 	separator_style = "angly", -- "angly" | "curvy" | "liney" | "empty"
--
-- 	select_symbol = "", -- S
-- 	yank_symbol = "󰆐", -- Y
--
-- 	filename_max_length = 24, -- truncate when filename > 24
-- 	filename_truncate_length = 10, -- leave 6 chars on both sides
-- 	filename_truncate_separator = "...",
-- })

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

require("font-sample"):setup({
	text = 'ABCDEF abcdef\n0123456789 \noO08 iIlL1 g9qCGQ\n8%& <([{}])>\n.,;: @#$-_="\n== <= >= != ffi\nâéùïøçÃĒÆœ\n및개요これ直楽糸',
	canvas_size = "750x800",
	font_size = 80,
	-- https://imagemagick.org/script/color.php
	bg = "white",
	fg = "black",
})
