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
			return ya.notify({ title = "System Clipboard", content = "No file selected", level = "warn", timeout = 5 })
		end

		-- ya.notify({ title = #urls, content = table.concat(urls, " "), level = "info", timeout = 5 })

		-- Format the URLs for `text/uri-list` specification
		local function encode_uri(uri)
			return (uri:gsub("([^%w%-%._~])", function(c)
				return string.format("%%%02X", string.byte(c))
			end))
		end

		local uris = {}
		for _, path in ipairs(urls) do
			-- format as file://
			table.insert(uris, "file://" .. encode_uri(path))
		end
		local file_list_formatted = table.concat(uris, "\r\n") .. "\r\n"

		-- Using pipemode to send data to stdin
		local child, err = Command("wl-copy"):arg("--type"):arg("text/uri-list"):stdin(Command.PIPED):spawn()

		if not child then
			return ya.notify({
				title = "System Clipboard",
				content = "Failed to start wl-copy: " .. tostring(err),
				level = "error",
				timeout = 5,
			})
		end

		child:write(file_list_formatted)
		local status = child:wait()

		if status and status.success then
			ya.notify({
				title = "System Clipboard",
				content = string.format("Copied %d file(s) to system clipboard", #urls),
				level = "info",
				timeout = 5,
			})
		else
			ya.notify({
				title = "System Clipboard",
				content = string.format("Could not copy file(s): %s", status and status.code or "Unknown error"),
				level = "error",
				timeout = 5,
			})
		end
	end,
}
