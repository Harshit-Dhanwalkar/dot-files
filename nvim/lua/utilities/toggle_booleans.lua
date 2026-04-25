-- ~/.config/nvim/lua/utilities/toggle_booleans.lua

local function toggle_bool()
	local replacements = {
		["true"] = "false",
		["false"] = "true",
		["True"] = "False",
		["False"] = "True",
		["0"] = "1",
		["1"] = "0",
		["yes"] = "no",
		["no"] = "yes",
		["on"] = "off",
		["off"] = "on",
	}

	local word = vim.fn.expand("<cword>")
	if replacements[word] then
		vim.cmd("normal! ciw" .. replacements[word])
	else
		print("No toggle found for: " .. word)
	end
end

vim.api.nvim_create_user_command("ToggleBoolean", toggle_bool, {
	desc = "Toggle booleans",
})
