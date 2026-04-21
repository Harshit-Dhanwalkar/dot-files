-- ~/.config/nvim/lua/utilities/notes.lua

local open_daily_note = function(create, now, dir)
	local base_path = vim.fn.expand("~/Desktop/Notes/DailyNotes/")
	local selected_dir = dir and (base_path .. dir)
	local cwd = vim.fn.getcwd()
	local cur_notes_dir = (cwd:find("notes") ~= nil) and cwd
	local default_dir = base_path .. "Jounral"

	local notes_dir = selected_dir or cur_notes_dir or default_dir
	local time = now or vim.fn.localtime()
	local filename = vim.fn.strftime("%d-%m-%Y_%a-%d-%b.md", time)
	local path = notes_dir .. "/" .. filename

	if vim.fn.filereadable(path) == 0 then
		if create then
			-- Ensure the directory exists before writing
			vim.fn.mkdir(notes_dir, "p")

			local file_io = io.open(path, "w")
			if file_io then
				print(("Creating new file: %s"):format(filename))
				file_io:write(vim.fn.strftime("# Notes on %A, %d %B\n\n", time))
				file_io:close()
			else
				print("Error: Could not open file for writing at " .. path)
				return
			end
		else
			print(("File `%s` does not exist."):format(filename))
			return
		end
	end

	vim.cmd("edit " .. vim.fn.fnameescape(path))
end

vim.api.nvim_create_user_command("Note", function(opts)
	local n = tonumber(opts.fargs[1]) or 0
	-- set 'create' to true for the current day (n == 0)
	open_daily_note(true, vim.fn.localtime() + n * 24 * 60 * 60)
end, { nargs = "?", desc = "Open daily note. Pass -1 for yesterday's note" })
