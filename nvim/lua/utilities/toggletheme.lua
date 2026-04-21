-- ~/.config/nvim/lua/utilities/toggletheme.lua

vim.api.nvim_create_user_command("ToggleColours", function()
	local cur_colorschema = vim.trim(vim.fn.execute("colorscheme"))

	if cur_colorschema == "tokyonight-night" then
		vim.cmd.colorscheme("tokyonight-day")
	elseif cur_colorschema == "tokyonight-day" then
		vim.cmd.colorscheme("tokyonight-night")
	end
end, { desc = "Toggle light/dark colorscheme" })
