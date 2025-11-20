-- ~/.config/nvim/lua/settings.lua

vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"

-- See `:help vim.opt` and `:help option-list`
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.cmdheight = 1
vim.opt.tabstop = 4
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.whichwrap = "bs<>"
vim.opt.hls = true
vim.opt.breakindent = true -- Enable break indent
vim.opt.undofile = true -- Save undo history
vim.opt.fileencoding = "utf-8" -- File encodind
vim.opt.signcolumn = "yes" -- Keep signcolumn on by default
vim.opt.updatetime = 250 -- Decrease update time

-- vim.lsp.handlers["$/progress"] = function() end -- to disable lsp widget
-- vim.g.lsp_status_diagnostic_signs_enabled = false -- disable just statusline messages

vim.wo.wrap = true
vim.opt.winblend = 20 -- Adjust the level of transparency
vim.opt.pumblend = 20 -- For popup menu level of transparency

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

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300 -- Displays which-key popup sooner

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type
vim.opt.inccommand = "split"
vim.opt.scrolloff = 10
vim.opt.cursorline = true -- Highlight the current line

-- Utils
vim.opt.runtimepath:append(vim.fn.stdpath("config") .. "/lua/utilities/")
