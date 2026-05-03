-- ~/.config/yazi/plugins/preview-git.yazi/main.lua

--- @diagnostic disable: undefined-global, undefined-field

local M = {}

-- TODO: colorized outpt
-- TODO: show all remotes
-- TODO: show all stash
-- TODO: show all branches
function M:peek(job)
	local ori = Command("git"):arg({ "remote", "get-url", "origin" }):output()
	local ups = Command("git"):arg({ "remote", "get-url", "upstream" }):output()
	local remotes = Command("git"):arg({ "remote", "-v" }):output()
	local status = Command("git"):arg({ "--no-optional-locks", "status", "-bs" }):output()
	-- local stashes = Command("git"):arg({ "stash", "list" }):output()

	-- local log = Command("git"):arg({ "log", "--format=%s" }):output()
	-- local log =
	-- 	Command("git"):arg("log"):arg("--graph"):arg("--format=%C(auto)%h %s %C(magenta)(%cr)%C(auto)%d"):output()
	local log = Command("git")
		:arg("-c")
		:arg("color.ui=always")
		:arg("log")
		:arg("--graph")
		:arg("--format=%C(auto)%h %s %C(magenta)(%cr)%C(auto)%d")
		-- :arg("-n15")
		:output()

	local text = ""
		.. (ori and ori.stdout ~= "" and ("origin: " .. ori.stdout) or "")
		.. (ups and ups.stdout ~= "" and ("upstream: " .. ups.stdout) or "")
		.. "\n"
		.. "Remotes:\n"
		.. (remotes and remotes.stdout)
		.. "\n"
		.. (status and status.stdout ~= "" and ("status: " .. status.stdout) or "")
		-- .. (stashes and stashes.stdout ~= "" and ("stashes: " .. stashes.stdout) or "")
		.. "\n"
		.. "Log:\n"
		.. (log and log.stdout)

	ya.preview_widget(job, ui.Text.parse(text):area(job.area))
end

function M:seek() end

return M

-- local M = {}
--
-- function M:peek(job)
-- 	-- Helper to run git commands with color forced
-- 	local function git_cmd(args)
-- 		-- We add -c color.ui=always to force git to output ANSI color codes
-- 		return Command("git"):arg("-c"):arg("color.ui=always"):args(args):output()
-- 	end
--
-- 	local lines = {}
--
-- 	-- 1. Remotes
-- 	local remotes = git_cmd({ "remote", "-v" })
-- 	if remotes and remotes.stdout ~= "" then
-- 		table.insert(lines, "\b--- REMOTES ---") -- \b makes it bold in some themes
-- 		table.insert(lines, remotes.stdout:gsub("\n$", ""))
-- 		table.insert(lines, "")
-- 	end
--
-- 	-- 2. Branches (highlighting the current one)
-- 	local branches = git_cmd({
-- 		"branch",
-- 		"--format=%(if:equals=*)%(head)%(then)%(color:green)* %(else)  %(end)%(color:reset)%(refname:short)",
-- 	})
-- 	if branches and branches.stdout ~= "" then
-- 		table.insert(lines, "\b--- BRANCHES ---")
-- 		table.insert(lines, branches.stdout:gsub("\n$", ""))
-- 		table.insert(lines, "")
-- 	end
--
-- 	-- 3. Status (Short)
-- 	local sts = git_cmd({ "--no-optional-locks", "status", "-bs" })
-- 	if sts and sts.stdout ~= "" then
-- 		table.insert(lines, "\b--- STATUS ---")
-- 		table.insert(lines, sts.stdout:gsub("\n$", ""))
-- 		table.insert(lines, "")
-- 	end
--
-- 	-- 4. Stash
-- 	local stashes = git_cmd({ "stash", "list" })
-- 	if stashes and stashes.stdout ~= "" then
-- 		table.insert(lines, "\b--- STASH ---")
-- 		table.insert(lines, stashes.stdout:gsub("\n$", ""))
-- 		table.insert(lines, "")
-- 	end
--
-- 	-- 5. Recent Log
-- 	local log = git_cmd({ "log", "--graph", "--format=%C(auto)%h %s %C(magenta)(%cr)%C(auto)%d", "-n15" })
-- 	if log and log.stdout ~= "" then
-- 		table.insert(lines, "\b--- RECENT LOG ---")
-- 		table.insert(lines, log.stdout:gsub("\n$", ""))
-- 	end
--
-- 	local text = table.concat(lines, "\n")
--
-- 	-- IMPORTANT: Use ui.Text.from_ansi to render the colors correctly
-- 	ya.preview_widget(job, ui.Text.from_ansi(text):area(job.area))
-- end
--
-- function M:seek() end
--
-- return M
