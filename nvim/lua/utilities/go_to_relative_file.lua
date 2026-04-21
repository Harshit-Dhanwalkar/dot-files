-- ~/.config/nvim/lua/utilities/commands.lua
--[[
Description: jump between next/previous files in present directory
--]]

local go_to_relative_file = function(n, relative_to)
	return function()
		local this_dir = vim.fs.dirname(vim.fs.normalize(vim.fn.expand("%:p")))

		local files = {}
		for file, type in vim.fs.dir(this_dir) do
			if type == "file" then
				table.insert(files, file)
			end
		end

		local this_file = relative_to or vim.fs.basename(vim.fn.bufname())
		local this_file_pos = -1

		for i, file in ipairs(files) do
			if file == this_file then
				this_file_pos = i
			end
		end

		if this_file_pos == -1 then
			error(("File `%s` not found in current directory"):format(this_file))
		end

		local new_file = files[((this_file_pos + n - 1) % #files) + 1]

		if not new_file then
			error(("Could not find file relative to `%s`"):format(this_file))
		end

		vim.cmd("edit " .. this_dir .. "/" .. new_file)
	end
end

vim.api.nvim_create_user_command("FileNext", go_to_relative_file(1), {})
vim.api.nvim_create_user_command("FilePrev", go_to_relative_file(-1), {})
