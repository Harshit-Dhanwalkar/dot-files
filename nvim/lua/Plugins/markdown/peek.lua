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
return {
	"toppair/peek.nvim",
	event = { "VeryLazy" },
	build = "deno task --quiet build:fast",
	config = function()
		require("peek").setup({})
		vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
		vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
	end,
}
