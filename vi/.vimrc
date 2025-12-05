" vim:foldmethod=marker:set ft=vim:
" ~/.vimrc -- I use this .vimrc config file for VI configuration mostly, but can be
" used for vim as well.

set wildmenu wildmode=list:full

highlight Normal ctermbg=black ctermfg=grey
highlight StatusLine term=none cterm=none ctermfg=black ctermbg=grey
highlight CursorLine term=none cterm=none ctermfg=none ctermbg=darkgray

set number
set relativenumber
set numberwidth=2

set colorcolumn=+1

set autoread

set nocompatible

set path +=**

set nobackup
set nowritebackup
set noswapfile

set nofsync

set textwidth=80
set laststatus=2
set noruler
" set statusline=%{repeat('─',winwidth('.')-1)}
" set fillchars=stl:─,stlnc:─

set title
set fileformats=unix,dos,mac

set showtabline=0

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

" set clipboard+=unnamed
set clipboard=unnamedplus

set nohlsearch
filetype plugin indent on

set incsearch               " match search while typing
set hlsearch                " hightligt search results
set smartcase               " search casesensitive if pattern contains uppercase chars
set ignorecase              " overwritten by smartcase if it contains uppercase chars
set showmatch

set complete-=i
set completeopt=menuone,longest

" ignore
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.db,*.o,*.a

" Always use vertical diffs
set diffopt=internal,filler,closeoff,algorithm:histogram,indent-heuristic,inline:char,context:100000
" set diffopt+=linematch:60
" set diffopt+=context:10

" directories
set undodir=~/.vim/undo//
set backupdir=~/.vim/backup//
set directory=~/.vim/swp//

set backspace=indent,eol,start
filetype plugin indent on
set autoindent
set smartindent
set smarttab
set foldlevelstart=99

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

set splitbelow
set splitright

" fzf-integration
set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
