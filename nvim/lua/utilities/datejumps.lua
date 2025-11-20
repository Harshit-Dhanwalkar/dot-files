-- ~/.config/nvim/lua/utilities/datejumps.lua
--[[
Description: Provides functions to jump between dates in the 'dd/mm/yyyy' format.
--]]

local M = {}

-- The pattern to find: dd/mm/yyyy
-- Using \v (very magic) for cleaner regex: \d{2}/\d{2}/\d{4}
local DATE_PATTERN = "\\v\\d{2}/\\d{2}/\\d{4}"

--- @param direction string 'forward' or 'backward'
local function jump_to_date(direction)
	-- 'w': wrap around the file when searching
	local flags = "w"

	if direction == "backward" then
		-- 'b': search backward
		flags = "b" .. flags
	end

	-- vim.fn.search executes the search command, moves the cursor on success,
	-- and returns 0. It returns -1 if the pattern is not found.
	local result = vim.fn.search(DATE_PATTERN, flags)

	if result == -1 then
		-- Notify the user if no more dates are found
		local dir_word = direction == "forward" and "forward" or "backward"
		vim.notify(
			"No more dates found when searching " .. dir_word .. ".",
			vim.log.levels.INFO,
			{ title = "Date Jump" }
		)
	end
end

--- @public
--- Jumps the cursor to the next (forward) occurrence of a date.
function M.next_date()
	jump_to_date("forward")
end

--- @public
--- Jumps the cursor to the previous (backward) occurrence of a date.
function M.prev_date()
	jump_to_date("backward")
end

return M
