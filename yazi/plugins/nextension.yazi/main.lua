-- ~/.config/yazi/plugins/nextension.yazi/main.lua

--- @diagnostic disable: undefined-global, undefined-field
--- @sync entry
--- @alias Job Job Comes from Yazi.
--- @alias tab__Folder tab__Folder Comes from Yazi.
--- @alias fs__File fs__File Comes from Yazi.
--- @alias fs__Files fs__Files Comes from Yazi.

-- TODO: jump to file with matching stem with `*`
-- TODO: select all files with same extension

-- return {
-- 	---@param job Job
-- 	entry = function(_, job)
-- 		local get_ext = function(file) ---@param file fs__File
-- 			-- if file.cha.is_dir then
-- 			-- 	return "%dir%"
-- 			-- else
-- 			-- 	return string.rep(string.gsub(file.name, [[^.*(%..+)$]], "%1"))
-- 			-- end
-- 			return file.name:match("^.+(%..+)$") or ""
-- 		end
--
-- 		local cur = cx.active.current ---@type tab__Folder
-- 		local files = cur.files ---@type fs__Files
-- 		-- local current_index = cur.cursor ---@type number
-- 		local current_index = cur.cursor + 1 ---@type number
-- 		local ext = get_ext(cur.hovered) ---@type string
-- 		local fwd = (job.args[1] == "fwd")
--
-- 		local target_index = nil
-- 		if fwd then
-- 			for i = current_index + 1, #files do
-- 				if get_ext(files[i]) ~= ext then
-- 					target_index = i - 1
-- 					break
-- 				end
-- 			end
-- 		else
-- 			for i = current_index - 1, 1, -1 do
-- 				if get_ext(files[i]) ~= ext then
-- 					target_index = i - 1
-- 					break
-- 				end
-- 			end
-- 		end
--
-- 		if target_index then
-- 			ya.emit("arrow", { target_index - (current_index - 1) })
-- 		else
-- 			ya.emit("arrow", { fwd and "bot" or "top" })
-- 		end
-- 	end,
-- }

return {
	entry = function(_, job)
		local get_ext = function(file)
			if not file or not file.url then
				return ""
			end
			if file.cha.is_dir then
				return "%dir%"
			end
			return file.url.name:match("^.+(%.[^.]+)$") or ""
		end

		local cur = cx.active.current
		local files = cur.files
		local current_index = cur.cursor + 1
		local ext = get_ext(cur.hovered)
		local fwd = (job.args[1] == "fwd")

		local target_index = nil
		if fwd then
			for i = current_index + 1, #files do
				if get_ext(files[i]) ~= ext then
					target_index = i
					break
				end
			end
		else
			local prev_ext = nil
			for i = current_index - 1, 1, -1 do
				local current_ext = get_ext(files[i])
				if not prev_ext and current_ext ~= ext then
					prev_ext = current_ext
					target_index = i
				elseif prev_ext and current_ext ~= prev_ext then
					target_index = i + 1
					break
				elseif prev_ext then
					target_index = i
				end
			end
		end

		if target_index then
			ya.emit("arrow", { target_index - current_index })
		else
			ya.emit("arrow", { fwd and "bot" or "top" })
		end
	end,
}
