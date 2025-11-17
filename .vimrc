set wildmenu wildmode=list:full

set nohlsearch
filetype plugin indent on

highlight Normal ctermbg=black ctermfg=grey
highlight StatusLine term=none cterm=none ctermfg=black ctermbg=grey
highlight CursorLine term=none cterm=none ctermfg=none ctermbg=darkgray

set number

set encoding=utf-8
set fileencoding=utf-8

set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set display=lastline

set mouse=a
set ttymouse=xterm2
set scrolloff=3

set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,],~

set incsearch
set ignorecase

set clipboard+=unnamed

noremap <C-a> <HOME>
noremap! <C-a> <HOME>

noremap <C-e> <END>
noremap! <C-e> <END>

noremap <C-k> <Esc>D
noremap! <C-k> <Esc>D

noremap <C-x> <Esc>:wq<CR>
noremap! <C-x> <Esc>:wq<CR>

noremap <C-z> <Esc>:undo<CR>
noremap! <C-z> <Esc>:undo<CR>

inoremap <C-i> <Esc>gg=G<CR>
nnoremap <C-i> <Esc>gg=G<CR>
