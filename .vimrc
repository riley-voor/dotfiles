source /etc/profile.d/vimrc/neadwerx_vimrc

" vi compatibility settings: part of debugging process for loading plugins
set nocompatible

filetype off " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" my plugins
Plugin 'junegunn/vim-easy-align' " Easy-Align
Plugin 'ervandew/supertab'       " SuperTab
Plugin 'scrooloose/syntastic'    " Syntastic
Plugin 'tpope/vim-fugitive'      " Fugitive

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
" Brief help
" :PluginList       " - lists configured plugins
" :PluginInstall    " - installs plugins; append `!` to update or just
" :PluginUpdate     " NOTE: uncomment this and open vim whenever you make
" changes to your plugins
" :PluginSearch foo " - searches for foo; append `!` to refresh local cache
" :PluginClean      " - confirms removal of unused plugins; append `!` to
" auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

source /etc/profile.d/vimrc/plugins/syntastic.vim
source /etc/profile.d/vimrc/plugins/easy_align.vim


" Custom Key Mappings
map <F3> :tabe
map <F4> :tabp<CR>
map <F5> :tabn<CR>

" map semicolon to colon
nmap ; :

" select colorscheme
colorscheme ron

" copy and paste setup " not currently working
"set clipboard+=unnamed  " use the clipboards of vim and win
"set paste               " Paste from a windows or from vim
"set go+=a               " Visual selection automatically copied to the clipboard

" Convert tabs to 2 spaces
set tabstop=4 softtabstop=0 expandtab shiftwidth=4

" old tab settings
"set expandtab
"set tabstop=2

" Deletes all trailing white space on save
autocmd BufWritePre * :%s/\s\+$//e

" Set auto and smart indent, as well as handle curly brace cursor placement
set autoindent
set smartindent
imap <C-Return> <CR><CR><C-o>k<Tab>

" keep 4 lines at bottom of screen below the cursor
set scrolloff=4

" imporve searching to highlight and move cursor as you type your search
set incsearch
set hlsearch

" change line numbers to be relative to the cursor except current line
set relativenumber
set number

" shows row and column numbers in bottom right corner
" don't set ruler since I have a custom statusline
"set ruler

" let a couple vim commands run a little slower to avoid random lag and
" artifacts
set nolazyredraw

" set up my statusline
set noruler
set laststatus=2
set statusline+=\ file:\ %t,
set statusline+=\ line:\ %l,
set statusline+=\ col:\ %c,
set statusline+=\ file_length:\ %L

