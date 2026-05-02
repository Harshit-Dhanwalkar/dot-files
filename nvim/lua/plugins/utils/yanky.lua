-- ~/.config/nvim/lua/plugins/utils/yanky.lua

return {
	"gbprod/yanky.nvim",
	config = function()
		require("yanky").setup({
			highlight = {
				on_put = true,
				on_yank = true,
				timer = 150,
			},
			preserve_cursor_position = { enabled = true },
			ring = { storage = "shada" },
			system_clipboard = { sync_with_ring = true },
		})

		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
		end

		local function is_multiline_register(reg)
			reg = (reg and reg ~= "") and reg or '"'
			local ok_text, text = pcall(vim.fn.getreg, reg)
			local ok_type, regtype = pcall(vim.fn.getregtype, reg)
			if not ok_text or not text or text == "" then
				return false
			end
			if ok_type and regtype then
				local first = regtype:sub(1, 1)
				-- 'V' = linewise, "\022" = blockwise
				if first == "V" or first == "\022" then
					return true
				end
			end
			return text:find("\n") ~= nil
		end

		local function paste_with_optional_indent(opts)
			opts = opts or {}
			local before = opts.before ~= false
			local cmd = is_multiline_register(vim.v.register) and (before and "[p" or "]p") or (before and "P" or "p")

			if opts.visual then
				-- Delete selection to blackhole so we don't clobber the register.
				local visual_cmd = '"_d' .. (before and "P" or "p")
				vim.cmd.normal({ args = { visual_cmd }, bang = true })
				return
			end

			if not opts.insert then
				vim.cmd.normal({ args = { cmd }, bang = true })
				return
			end

			local regname = (vim.v.register and vim.v.register ~= "") and vim.v.register or '"'
			local reg_text = vim.fn.getreg(regname) or ""
			local regtype = vim.fn.getregtype(regname) or "v"
			local pos = vim.api.nvim_win_get_cursor(0)

			vim.cmd.stopinsert()
			vim.cmd.normal({ args = { cmd }, bang = true })

			local lines = vim.split(reg_text, "\n", { plain = true, trimempty = false })
			local is_linewise = regtype:sub(1, 1) == "V" or (#lines > 1)

			local target_line, target_col
			if is_linewise then
				local last = lines[#lines]
				if last == "" then
					last = lines[#lines - 1] or ""
				end
				local line_delta = before and 0 or 1
				target_line = pos[1] + line_delta + (#lines - 1)
				target_col = #last
			else
				local base_col = before and pos[2] or (pos[2] + 1)
				target_line = pos[1]
				target_col = base_col + #reg_text
			end

			vim.api.nvim_win_set_cursor(0, { target_line, target_col })
			vim.schedule(function()
				vim.cmd.startinsert({ bang = true })
			end)
		end

		-- -- Copy: keep Ctrl-C focused on system clipboard (linewise in normal, selection in visual).
		-- map("n", "<C-c>", '"+yy', "Yanky: copy line to clipboard")
		-- map("x", "<C-c>", '"+y', "Yanky: copy selection to clipboard")
		--
		-- -- Paste: route Ctrl-V through yanky and re-indent like the move line mappings.
		-- map("n", "<C-v>", function()
		-- 	paste_with_optional_indent({ before = true, insert = true })
		-- end, "Yanky: paste clipboard with indent (insert)")
		--
		-- map("x", "<C-v>", function()
		-- 	paste_with_optional_indent({ before = true, visual = true })
		-- end, "Yanky: paste clipboard with indent (visual only)")
		-- map("i", "<C-v>", function()
		-- 	paste_with_optional_indent({ insert = true, before = true })
		-- end, "Yanky: paste clipboard with indent")
	end,
}
