-- ~/.config/yazi/plugins/telegram-send.yazi/main.lua

--- @diagnostic disable: undefined-global, undefined-field

local selected_files = ya.sync(function()
	local tab, paths = cx.active, {}
	for _, u in pairs(tab.selected) do
		paths[#paths + 1] = tostring(u)
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths
end)

local function notify(str, level)
	ya.notify({
		title = "Telegram Send",
		content = str,
		timeout = 3,
		level = level or "info",
	})
end

local state_option = ya.sync(function(state, attr)
	return state[attr]
end)

local function entry()
	local files = selected_files()
	if #files == 0 then
		return
	end

	local notification, command = state_option("notification"), state_option("command") or "telegram-send --file"

	local success, fail = 0, {}
	for _, file in ipairs(files) do
		local cmd = command .. ' "' .. file .. '"'
		local result = os.execute(cmd)

		if result then
			success = success + 1
		else
			fail[#fail + 1] = file
		end
	end

	if notification then
		local msg = string.format("Sent %d/%d files", success, #files)
		if #fail > 0 then
			msg = msg .. "\nFailed: " .. table.concat(fail, ", ")
			notify(msg, "error")
		else
			notify(msg)
		end
	end
end

return {
	setup = function(state, options)
		state.command = options.command or "telegram-send --file"
		state.notification = options.notification ~= false
	end,
	entry = entry,
}
