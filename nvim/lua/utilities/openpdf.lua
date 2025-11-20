-- ~/.config/nvim/lua/utilities/openpdf.lua
--[[
Description: Extracts the pdf file path from a Markdown or Wikilink on the current line and opens the corresponding PDF document in the external Zathura pdf viewer.
--]]

function OpenPdfInZathura()
	local current_file_path = vim.fn.expand("%:p")
	local current_dir = vim.fn.fnamemodify(current_file_path, ":h")
	local current_line = vim.fn.getline(".")
	local linked_path = current_line:match("%[.-%]%(%s*(.-)%s*%)") or current_line:match("%[%[(.-)%]%]")

	local file_path_to_open

	if linked_path then
		file_path_to_open = current_dir .. "/" .. linked_path
		file_path_to_open = vim.fn.resolve(file_path_to_open)
		file_path_to_open = vim.fn.fnamemodify(file_path_to_open, ":p")

		if vim.fn.filereadable(file_path_to_open) == 0 then
			print("ERROR: Resolved PDF file not found at: " .. file_path_to_open)
			return
		end
	else
		print("No markdown link found on line. Assuming current file extension needs substitution.")
		if not current_file_path:match(".pdf$") and not current_file_path:match(".PDF$") then
			file_path_to_open = current_file_path:gsub("%.[^/\\%.]+$", ".pdf")
		else
			file_path_to_open = current_file_path
		end
	end

	local command = "zathura " .. vim.fn.shellescape(file_path_to_open) .. " &"
	vim.cmd("silent !" .. command)

	print("Opening PDF: " .. file_path_to_open .. " in Zathura...")
end

vim.api.nvim_create_user_command("ZathuraOpen", OpenPdfInZathura, {
	desc = "Open current file (or linked PDF) in Zathura",
	nargs = 0,
})
