-- ~/.config/nvim/lua/Plugins/markdown/peek.lua
-- # Install Deno
-- ```
-- brew install deno
-- ```
-- or
-- ```
-- curl -fsSL https://deno.land/install.sh | sh
-- ```
-- # Install JS dependencies:
-- ```
-- cd ~/.local/share/nvim/lazy/peek.nvim
-- deno task --quiet build:fast
-- ```
-- I didn't need to install `webkit` module but if it don't work install it via:
-- ```
-- sudo apt install libwebkit2gtk-4.0-37
-- sudo pacman -S webkit2gtk
-- sudo dnf install webkit2gtk4
-- ```
-- Open markdown in nvim
-- :PeekOpen
-- return {
-- 	"toppair/peek.nvim",
-- 	event = { "VeryLazy" },
-- 	build = "deno task --quiet build:fast",
-- 	config = function()
-- 		require("peek").setup({})
-- 	end,
-- }
return {
	"toppair/peek.nvim",
	event = { "VeryLazy" },
	ft = { "markdown" },
	cmd = { "PeekOpen", "PeekClose" },
	build = "deno task --quiet build:fast",
	config = function()
		require("peek").setup({})
		local peek = require("peek")
		peek.setup({
			auto_load = true, -- whether to automatically load preview when entering another markdown buffer
			close_on_bdelete = true, -- close preview window on buffer delete
			syntax = true, -- enable syntax highlighting, affects performance
			theme = "dark", -- 'dark' or 'light'
			update_on_change = true,
			-- app = "webview", -- 'webview', 'browser' ( -- xgd-open http://localhost:33113/?theme=dark)
			app = { "brave-browser", "-new-window" },
			throttle_at = 200000, -- start throttling when file exceeds this  amount of bytes in size
			throttle_time = "auto", -- minimum amount of time in milliseconds that has to pass before starting new render
			filetype = {
				"markdown",
				"vimwiki",
				"vimwiki.markdown",
				"vimwiki.markdown.pandoc",
			},
		})

		-- -- Custom Peek with i3 logic
		-- vim.api.nvim_create_user_command("PeekOpen", function()
		-- 	if not peek.is_open() and vim.bo.filetype == "markdown" then
		-- 		vim.fn.system("i3-msg split horizontal")
		-- 		peek.open()
		-- 	end
		-- end, {})
		-- vim.api.nvim_create_user_command("PeekClose", function()
		-- 	if peek.is_open() then
		-- 		peek.close()
		-- 		vim.fn.system("i3-msg move left")
		-- 	end
		-- end, {})
	end,
	opts = {},
}
