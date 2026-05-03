-- ~/.config/yazi/plugins/greetings.yazi/main.lua

--- @diagnostic disable: undefined-global, undefined-field

return {
	entry = function()
		local user = os.getenv("USER") or "unknown"
		local now = os.date("*t")
		local hour = now.hour
		local minute = now.min

		-- Determine greeting based on hour
		local greeting
		if hour < 12 then
			greeting = "Good morning"
		elseif hour < 18 then
			greeting = "Good afternoon"
		else
			greeting = "Good evening"
		end

		-- Format time as HH:MM
		local time_str = string.format("%02d:%02d", hour, minute)

		ya.notify({
			title = "Greetings ",
			content = greeting .. " " .. user .. "!\nIt's " .. time_str,
			level = "info",
			timeout = 3,
		})
	end,
}
