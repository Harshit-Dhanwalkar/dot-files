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
	wildmode = "list:longest,list:full", -- complete longest common match, full completion list, cycle through Tab
	wildmenu = true,
	wildignorecase = true,
	redrawtime = 10000,
	maxmempattern = 20000,

	wrap = true,
	showbreak = "↪ ",
	winblend = 20,

	-- Popup menu
	pumblend = 20,
	pumheight = 10,

	conceallevel = 0,
	concealcursor = "",

	showmode = false,
	laststatus = 2,

	-- case insensitive search
	ignorecase = true,
	smartcase = true,
	infercase = true,
	selection = "inclusive",

	-- behavior settings
	hidden = true,
	errorbells = false,
	backspace = "indent,eol,start",

	-- searching
	inccommand = "split",
	hlsearch = true,
	incsearch = true,

	-- scroll bounds
	sidescroll = 4,
	scrolloff = 8,

	-- mouse scrolling support
	mouse = "a",

	cursorline = true,
	completeopt = { "menuone", "noselect" },
	timeoutlen = 500, -- Key timeout duration
	ttimeoutlen = 0, -- Key code timeout duration
	autoread = true, -- Auto read file changes outside vim
	autowrite = false, -- Auto write file changes outside vim
	synmaxcol = 300, -- Syntax highlight limit
	splitright = true,
	splitbelow = true,
	list = true,
	listchars = { tab = "» ", trail = "·", nbsp = "␣" },
	-- Sync clipboard between OS and Neovim.
	--  See `:help 'clipboard'`
	clipboard = "unnamedplus",
	modifiable = true,

	-- Folding
	foldenable = false,
	-- foldmethod = "expr",
	-- foldexpr = "u:lua.vim.treesitter.foldexpr()" --use treesitter for folding
	-- foldlevel = 99, --start with all folds open

	-- Cursor blink settings
	-- guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175",
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

-- vim.opt.iskeyword:append("-") -- treat '-' as part of word
vim.opt.fillchars:append("diff:╱")
vim.opt.jumpoptions:append("stack")
vim.opt.diffopt:append("algorithm:patience")

-- fuzzy find
vim.opt.path:append("**") -- include subdir in search

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
