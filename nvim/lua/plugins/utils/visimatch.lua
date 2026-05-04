-- ~/.config/nvim/lua/plugins/utils/visimatch.lua

return {
	"wurli/visimatch.nvim",

	-- config = function()
	-- 	require("visimatch").setup({
	-- 		hl_group = "Search",
	-- 		chars_lower_limit = 3,
	-- 		lines_upper_limit = 30,
	-- 		strict_spacing = false, -- Set `true` for exact spacing match
	-- 		-- Visible buffers which should be highlighted. Valid options:
	-- 		-- * `"filetype"` (the default): highlight buffers with the same filetype
	-- 		-- * `"current"`: highlight matches in the current buffer only
	-- 		-- * `"all"`: highlight matches in all visible buffers
	-- 		-- * A function. This will be passed a buffer number and should return
	-- 		--   `true`/`false` to indicate whether the buffer should be highlighted.
	-- 		buffers = "filetype",
	-- 		-- Case-(in)nsitivity for matches. Valid options:
	-- 		-- * `true`: matches will never be case-sensitive
	-- 		-- * `false`/`{}`: matches will always be case-sensitive
	-- 		-- * a table of filetypes to use use case-insensitive matching for.
	-- 		case_insensitive = { "markdown", "text", "help" },
	-- 	})
	-- end,
}
