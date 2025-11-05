-- ~/.config/nvim/lua/settings.lua

-- See `:help vim.opt` amd `:help option-list`
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

vim.wo.wrap = true -- For window-specific options
vim.o.winblend = 20 -- Adjust the level of transparency
vim.o.pumblend = 20 -- For popup menu level of transparency

vim.opt.mouse = "a" -- Enable mouse mode
vim.opt.showmode = false -- Don't show mode in the status line
vim.opt.laststatus = 2 -- Always display the status line

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.hlsearch = true -- Highlight search results
vim.opt.incsearch = true -- Show search matches as you type
vim.opt.smartcase = true -- Case-sensitive if search contains uppercase
vim.opt.ignorecase = true

-- Sync clipboard between OS and Neovim.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

vim.opt.breakindent = true -- Enable break indent
vim.opt.undofile = true -- Save undo history
vim.opt.fileencoding = "utf-8" -- File encoding
vim.opt.signcolumn = "yes" -- Keep signcolumn on by default
vim.opt.updatetime = 250 -- Decrease update time

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"
vim.opt.scrolloff = 10
-- vim.opt.cursorline = true -- Highlight the current line

-- -- Command to preview in Okular
-- vim.api.nvim_create_user_command("PreviewOkular", function()
-- 	local filepath = vim.fn.expand("%:p")
-- 	vim.fn.jobstart({ "okular", filepath }, { detach = true })
-- end, {})
--
-- -- Command to preview in Zathura
-- vim.api.nvim_create_user_command("PreviewZathura", function()
-- 	local filepath = vim.fn.expand("%:p")
-- 	vim.fn.jobstart({ "zathura", filepath }, { detach = true })
-- end, {})
