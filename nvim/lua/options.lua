-- ~/.config/nvim/lua/options.lua

vim.g.vimtex_syntax_enabled = 0

vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"

-- See `:help vim.opt` and `:help option-list`
local options = {
	-- security
	modelines = 0,

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
	autoindent = true,
	smartindent = true,
	breakindent = true,
	signcolumn = "yes",
	updatetime = 250,
	readonly = false,

	-- maintain undo history between sessions
	swapfile = false,
	undofile = true,
	undodir = vim.fn.stdpath("data") .. "/undo",

	-- lazy file name tab completion,
	wildmode = "list:longest,list:full",
	wildmenu = true,
	wildignorecase = true,

	wrap = true,
	winblend = 20,
	pumblend = 20,
	pumheight = 10,

	showmode = false,
	laststatus = 2,

	-- case insensitive search
	ignorecase = true,
	smartcase = true,
	infercase = true,

	-- make backspace behave in a sane manner
	backspace = "indent,eol,start",

	-- searching
	inccommand = "split",
	hlsearch = true,
	incsearch = true,

	-- scroll bounds
	sidescroll = 4,
	scrolloff = 8,

	-- ipad scrolling
	mouse = "a",

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

-- fuzzy find
vim.opt.path:append("**")

local wildignore_patterns = {
	".git",
	".hg",
	".svn",
	"*.aux",
	"*.out",
	"*.toc",
	"*.o",
	"*.obj",
	"*.exe",
	"*.dll",
	"*.manifest",
	"*.rbc",
	"*.class",
	"*.ai",
	"*.bmp",
	"*.gif",
	"*.ico",
	"*.jpg",
	"*.jpeg",
	"*.png",
	"*.psd",
	"*.webp",
	"*.avi",
	"*.divx",
	"*.mp4",
	"*.webm",
	"*.mov",
	"*.m2ts",
	"*.mkv",
	"*.vob",
	"*.mpg",
	"*.mpeg",
	"*.mp3",
	"*.oga",
	"*.ogg",
	"*.wav",
	"*.flac",
	"*.eot",
	"*.otf",
	"*.ttf",
	"*.woff",
	"*.doc",
	"*.pdf",
	"*.cbr",
	"*.cbz",
	"*.zip",
	"*.tar.gz",
	"*.tar.bz2",
	"*.rar",
	"*.tar.xz",
	"*.kgb",
	"*.swp",
	"*.lock",
	".DS_Store",
	"._*",
	".,..",
}
vim.opt.wildignore = table.concat(wildignore_patterns, ",")

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
