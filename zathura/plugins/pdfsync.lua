-- PDFSync Zathura Plugin
-- Saves current page to a file for PDFSync to read

local current_filename = nil
local sync_file = nil

function on_load(file)
	current_filename = file
	-- Create sync file path based on PDF filename
	local sync_filename = string.gsub(file, ".*/", "") .. ".sync"
	sync_file = os.getenv("HOME") .. "/.local/share/zathura/" .. sync_filename
	-- Ensure directory exists
	os.execute("mkdir -p " .. os.getenv("HOME") .. "/.local/share/zathura")
	print("[PDFSync] Tracking: " .. file .. " → " .. sync_file)
end

function on_page_change(page)
	if current_filename and sync_file then
		-- Write current page to sync file
		local file = io.open(sync_file, "w")
		if file then
			file:write(tostring(page))
			file:close()
			print("[PDFSync] Saved page " .. page .. " to " .. sync_file)
		end
	end
end

function on_quit()
	if sync_file and os.rename(sync_file, sync_file) then
		os.remove(sync_file)
		print("[PDFSync] Cleaned up sync file")
	end
end

print("[PDFSync] Plugin loaded - will save page changes to ~/.local/share/zathura/")
