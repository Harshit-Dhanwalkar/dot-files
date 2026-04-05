-- ~/.config/nvim/lua/settings.lua

vim.g.vimtex_syntax_enabled = 0

vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"

-- See `:help vim.opt` and `:help option-list`
local options = {
	fileencoding = "utf-8",
	guifont = "JetBrainsMono_Nerd_Font:h11",
	backup = false,
	writebackup = false,
	termguicolors = true,
	number = true,
	relativenumber = true,
	shiftwidth = 4,
	cmdheight = 1,
	tabstop = 4,
	softtabstop = 2,
	expandtab = true,
	linebreak = true,
	whichwrap = "bs<>",
	hls = true,
	smartindent = true,
	breakindent = true,
	undofile = true,
	signcolumn = "yes",
	updatetime = 250,
	readonly = false,
	swapfile = false,
	wrap = true,
	winblend = 20,
	pumblend = 20,
	pumheight = 10,
	mouse = "a",
	showmode = false,
	laststatus = 2,
	hlsearch = true,
	incsearch = true,
	smartcase = true,
	ignorecase = true,
	inccommand = "split",
	sidescroll = 4,
	scrolloff = 8,
	cursorline = true,
	completeopt = { "menuone", "noselect" },
	timeoutlen = 300,
	splitright = true,
	splitbelow = true,
	list = true,
	listchars = { tab = "» ", trail = "·", nbsp = "␣" },
	-- Sync clipboard between OS and Neovim.
	--  See `:help 'clipboard'`
	clipboard = "unnamedplus",
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

-- vim.lsp.handlers["$/progress"] = function() end -- to disable lsp widget
-- vim.g.lsp_status_diagnostic_signs_enabled = false -- disable just statusline messages

-- Create an autocommand group for file-specific settings
vim.api.nvim_create_augroup("FileTypeSpecific", { clear = true })

-- Set shiftwidth and tabstop to 2 for HTML, CSS, JavaScript, and Lua files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "html", "css", "javascript", "lua" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
	end,
	group = "FileTypeSpecific",
})

vim.cmd("autocmd BufEnter * set formatoptions-=cro")
vim.cmd("autocmd BufEnter * setlocal formatoptions-=cro")

vim.opt.shortmess:append("c")

-- Utils
vim.opt.runtimepath:append(vim.fn.stdpath("config") .. "/lua/utilities/")
