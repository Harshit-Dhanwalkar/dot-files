-- ~/.config/yazi/plugins/wl-clipboard.yazi/main.lua
-- Meant to run at async context. (yazi system-clipboard)

--- @diagnostic disable: undefined-global, undefined-field

local selected_or_hovered = ya.sync(function()
	local tab, paths = cx.active, {}
	for _, u in pairs(tab.selected) do
		paths[#paths + 1] = tostring(u)
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths
end)

return {
	entry = function()
		ya.emit("escape", { visual = true })

		local urls = selected_or_hovered()
		if #urls == 0 then
			return ya.notify({
				title = "System Clipboard",
				content = "No file selected",
				level = "warn",
				timeout = 5,
			})
		end

		local function encode_uri(uri)
			return uri:gsub("([^%w%-%._~:/])", function(c)
				return string.format("%%%02X", string.byte(c))
			end)
		end

		-- GNOME/Nautilus expects: "copy\nfile:///path1\nfile:///path2\n"
		-- with MIME type: x-special/gnome-copied-files
		local file_list = "copy\n"
		for _, path in ipairs(urls) do
			file_list = file_list .. "file://" .. encode_uri(path) .. "\n"
		end

		local tmp = "/tmp/yazi_wl_clip.txt"
		local f = io.open(tmp, "w")
		if not f then
			return ya.notify({
				title = "System Clipboard",
				content = "Failed to write temp file",
				level = "error",
				timeout = 5,
			})
		end
		f:write(file_list)
		f:close()

		local child, err = Command("sh")
			:args({
				"-c",
				string.format('/usr/bin/wl-copy --type x-special/gnome-copied-files < "%s"', tmp),
			})
			:stdout(Command.NULL)
			:stderr(Command.NULL)
			:spawn()

		if not child then
			return ya.notify({
				title = "System Clipboard",
				content = "Failed to spawn: " .. tostring(err),
				level = "error",
				timeout = 5,
			})
		end

		local status = child:wait()

		if status and status.success then
			ya.notify({
				title = "System Clipboard",
				content = "Copied " .. #urls .. " file(s) — paste in Nautilus with Ctrl+V",
				level = "info",
				timeout = 5,
			})
		else
			ya.notify({
				title = "System Clipboard",
				content = "wl-copy failed (code: " .. (status and tostring(status.code) or "nil") .. ")",
				level = "error",
				timeout = 8,
			})
		end
	end,
}
