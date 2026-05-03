-- ~/.config/yazi/plugins/hostname-username.yazi/main.lua

--- @diagnostic disable: undefined-global, undefined-field

local function setup(_, options)
	options = options or {}

	local config = {
		color = options.color or "#0a0a0a", -- "silver",
		mode = options.mode or "both", -- "both", "user", or "host"
	}

	if Yatline ~= nil then
		function Yatline.coloreds.get:hostname_username()
			if ya.target_family() ~= "unix" then
				return {}
			end

			local user = ya.user_name() or ""
			local host = ya.host_name() or ""
			local out = ""
			if config.mode == "both" then
				out = string.format("%s@%s", user, host)
			elseif config.mode == "user" then
				out = user
			elseif config.mode == "host" then
				out = host
			else
				return {} -- invalid config value, skip display
			end

			if out == "" then
				return {}
			end

			return {
				{ out, config.color },
			}
		end
	end
end

return { setup = setup }
