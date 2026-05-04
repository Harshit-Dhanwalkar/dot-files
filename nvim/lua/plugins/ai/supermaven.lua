-- ~/.config/nvim/lua/plugins/ai/supermaven.lua

-- M.expand = function(fallback)
-- 	local luasnip = require("luasnip")
-- 	local suggestion = require("supermaven-nvim.completion_preview")
--
-- 	if luasnip.expandable() then
-- 		luasnip.expand()
-- 	elseif suggestion.has_suggestion() then
-- 		suggestion.on_accept_suggestion()
-- 	else
-- 		fallback()
-- 	end
-- end

return {
	"supermaven-inc/supermaven-nvim",

	config = function()
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<Tab>",
				clear_suggestion = "<C-]>",
				accept_word = "<C-j>",
			},
			-- ignore_filetypes = { "cpp" },
			color = {
				suggestion_color = "#ffffff",
				cterm = 244,
			},
			log_level = "off", -- "info", "error"
			disable_inline_completion = false, -- disables inline completion for use with cmp
			disable_keymaps = false, -- disables built in keymaps for more manual control
			condition = function()
				return false
			end, -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
		})
	end,
}
