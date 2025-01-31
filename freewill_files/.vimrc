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
Plugin 'arcticicestudio/nord-vim' " Nord color scheme
Plugin 'airblade/vim-gitgutter'   " GitGutter - Displays git diff in vim
Plugin 'ycm-core/YouCompleteMe'   " YouCompleteMe - Tab auto complete
Plugin 'tpope/vim-fugitive'       " Fugitive - Git Blame
Plugin 'junegunn/vim-easy-align'  " Easy-Align - easy highlighting alignment
Plugin 'craigemery/vim-autotag'   " Vim-Autotag - keeps ctags up to date
Plugin 'puremourning/vimspector'  " Vimspector - Vim graphical debugger
Plugin 'dense-analysis/ale'       " Ale - syntax/style checker/linter
Plugin 'tpope/vim-commentary'     " Vim-Commentary - shortcuts for commenting out stuff

" Plugins that I used to use but I'm not sure if I am getting them set up correctly or if they even do anything
"Plugin 'ervandew/supertab'        " SuperTab

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
" VIMSPECTOR NOTE: when using vimspector to debug the freewill app project you
" must put a 'debugger;' command at the start of the function you want to
" debug. This is because that project uses webpack which is a node modules
" that really messes with debugging for some reason. This might causes some
" errors but there do seems to be some harmless errors related to this that
" you can ignore.
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
" Useful Vimspector commands for installing/updating gadgets
" :VimspectorInstall
" :VimspectorUpdate

" TODO still not sure if I actually need these here or not
"source ~/.vim/bundle/vim-easy-align/plugin/easy_align.vim

" Set our leader to "." instead of the default "\" because it's easier to
" reach on my keyboard.
let mapleader = "."

" List of our specific language gadgets for Vimspector
let g:vimspector_install_gadgets = ['vscode-node-debug2']

" Shortcuts for Vimspector
nnoremap <Leader>dd :call vimspector#Launch()<CR>
nnoremap <Leader>de :call vimspector#Reset()<CR>
nnoremap <Leader>dc :call vimspector#Continue()<CR>

nnoremap <Leader>dt :call vimspector#ToggleBreakpoint()<CR>
nnoremap <Leader>dT :call vimspector#ClearBreakpoints()<CR>

nmap <Leader>dk <Plug>VimspectorRestart
nmap <Leader>dh <Plug>VimspectorStepOut
nmap <Leader>dl <Plug>VimspectorStepInto
nmap <Leader>dj <Plug>VimspectorStepOver

" Enable/Disable GitGutter with keyboard shortcuts (mostly because of how it
" interferes with Vimspector).
nnoremap <Leader>gg :GitGutterToggle<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap <tab> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap <tab> <Plug>(EasyAlign)

" Custom easy align delimiters
let g:easy_align_delimiters = { ']': {     'pattern':       ']',     'left_margin':   0,     'right_margin':  0,     'stick_to_left': 0   }, '(': {     'pattern':       '(',     'left_margin':   0,     'right_margin':  1,     'stick_to_left': 0   }, ')': {     'pattern':       ')',     'left_margin':   1,     'right_margin':  0,     'stick_to_left': 0   }, ':': {     'pattern':       ':',     'left_margin':   1,     'right_margin':  1,     'stick_to_left': 0   }, ',': {     'pattern':       ',',     'left_margin':   0,     'right_margin':  1,     'stick_to_left': 1   } }

" Define our linters for ale.
let g:ale_linters = {   'javascript':      ['eslint'],   'javascriptreact': ['eslint'],   'typescript':      ['eslint'],   'typescriptreact': ['eslint'] }

" Define our fixers for ale.
let g:ale_fixers = {   'javascript':      ['prettier'],   'javascriptreact': ['prettier'],   'typescript':      ['prettier'],   'typescriptreact': ['prettier'] }

" Only run the linters that we specify, not all linters for every file.
let g:ale_linters_explicit = 1

" Don't run fixers on file save.
let g:ale_fix_on_save = 0

" Make F7 a shortcut for running our ale fixers.
nnoremap <F7> :ALEFix<CR>

" Custom Key Mappings for opening files
map <F3> :tabe
map <F4> :tabp<CR>
map <F5> :tabn<CR>

" Show autocomplete options in a list.
set wildmenu
set wildmode=list:full
set wildignorecase
" TODO pum doesn't seem to be working to make the autocomplete use a pop up
" menu like I wanted. Hmm. Gotta figure that out. Try looking
" here: https://vi.stackexchange.com/questions/31563/vertical-wildmenu-in-vim
" and here: https://groups.google.com/g/vim_dev/c/rSRbXUMDZio?pli=1
set wildoptions="pum,tagfile,fuzzy"

" Have j and k move us by visual line rather than file line but still use
" actual file lines for things like jumping by a certain number of lines (e.g.
" '15j' will jump by 15 file lines rather than 15 visual lines) which will
" keep the line jump values aligned with the relative numbers on the left hand
" side of the screen. Also we set up '0' and '$' to move us by visual line
" rather than actual line movement which is really nice as well.
nnoremap <expr> j (v:count? 'j' : 'gj')
nnoremap <expr> k (v:count? 'k' : 'gk')
noremap <silent> 0 g0
noremap <silent> $ g$

" map semicolon to colon
nmap ; :

" map in-file search to always use regex prefix
" also do case insensitive search unless your search contains upper case
" letters, then do case sensitive search (have to set both ignorecase and
" smartcase)
map / /\v
set ignorecase
set smartcase

" For our tag acessing we have the following commands available to us (among
" others that we don't expect to use quite as frequently):
" - <C-]>  : go to highest priority tag of the thing the cursor is currently on.
" - g<C-]> : if there's multiple tags, show a list, if there's only one then
"   just do the <C-]> thing.
" - C-t    : go back down the tag stack (so basically go back to the file you
"   were just at if you just went to a tag).
" - C-\    : do the <C-]> thing except open it in a new tab.
map <C-\> <C-w><C-]><C-w>T
"set switchbuf=useopen,usetab

" Make Vim-Autotag work on Mac
let g:autotagStartMethod='fork'

" Also update ctags in the background every time vim starts.
autocmd BufWritePost *.c,*.h silent! !ctags . &

" select colorscheme
colorscheme nord
syntax on

" Set update time to 100ms so that GitGutter will update quickly
set updatetime=100

" Get delete/backspace key working on mac
set backspace=indent,eol,start

" make comments italic " doesn't work on centos (ie my devbox at Neadwerx)
"set t_ZH=^[[3m
"set t_ZR=^[[23m
"highlight Comment cterm=italic

" copy and paste setup " not currently working
"set clipboard+=unnamed  " use the clipboards of vim and win
"set paste               " Paste from a windows or from vim
"set go+=a               " Visual selection automatically copied to the clipboard

" Convert tabs to 2 spaces
set tabstop=2 softtabstop=0 expandtab shiftwidth=2

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

" General Fold Settings
" TODO disabling folidng settings until I can figure out something that I
" actually like
" nnoremap <Space> za
" vnoremap <Space> za
" highlight folded cterm=none ctermfg=8 ctermbg=none
"
" " Fold settings specifically for typescript
" function! TypeScriptFold()
"     setl foldmethod=syntax
"     setl foldlevelstart=1
"     syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend
" endfunction
" au FileType typescript call TypeScriptFold()
" au FileType typescript setl fen

" shows row and column numbers in bottom right corner
" don't set ruler since I have a custom statusline
"set ruler

" let a couple vim commands run a little slower to avoid random lag and
" artifacts
set nolazyredraw

" set up my statusline
set noruler
set laststatus=2
" not sure why but my statusline was getting doubled when I had this here but
" when I commented them out it worked as expected so I guess I'll just leave
" them commented out?
" set statusline+=\ file:\ %t,
" set statusline+=\ line:\ %l,
" set statusline+=\ col:\ %c,
" set statusline+=\ file_length:\ %L

" Let's save undo info!
" If the /.vim/undo-dir directory doesn't exist then create it
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
" Point vim to our undo directory and save our undo stuff there
set undodir=~/.vim/undo-dir
set undofile

" Save location in file when you close it and open back up to that location
" when you open that file again later.
autocmd BufWinLeave ?* mkview
autocmd BufWinEnter ?* silent loadview

" Custom command for quickly inserting '// TODO testing' followed by a new line
command TodoTestingInsert execute "normal i// TODO testing\<Esc>b"
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
Plugin 'arcticicestudio/nord-vim' " Nord color scheme
Plugin 'airblade/vim-gitgutter'   " GitGutter - Displays git diff in vim
Plugin 'ycm-core/YouCompleteMe'   " YouCompleteMe - Tab auto complete
Plugin 'tpope/vim-fugitive'       " Fugitive - Git Blame
Plugin 'junegunn/vim-easy-align'  " Easy-Align - easy highlighting alignment
Plugin 'craigemery/vim-autotag'   " Vim-Autotag - keeps ctags up to date
Plugin 'puremourning/vimspector'  " Vimspector - Vim graphical debugger
Plugin 'dense-analysis/ale'       " Ale - syntax/style checker/linter
Plugin 'tpope/vim-commentary'     " Vim-Commentary - shortcuts for commenting out stuff

" Plugins that I used to use but I'm not sure if I am getting them set up correctly or if they even do anything
"Plugin 'ervandew/supertab'        " SuperTab

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
" VIMSPECTOR NOTE: when using vimspector to debug the freewill app project you
" must put a 'debugger;' command at the start of the function you want to
" debug. This is because that project uses webpack which is a node modules
" that really messes with debugging for some reason. This might causes some
" errors but there do seems to be some harmless errors related to this that
" you can ignore.
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
" Useful Vimspector commands for installing/updating gadgets
" :VimspectorInstall
" :VimspectorUpdate

" TODO still not sure if I actually need these here or not
"source ~/.vim/bundle/vim-easy-align/plugin/easy_align.vim

" Set our leader to "." instead of the default "\" because it's easier to
" reach on my keyboard.
let mapleader = "."

" List of our specific language gadgets for Vimspector
let g:vimspector_install_gadgets = ['vscode-node-debug2']

" Shortcuts for Vimspector
nnoremap <Leader>dd :call vimspector#Launch()<CR>
nnoremap <Leader>de :call vimspector#Reset()<CR>
nnoremap <Leader>dc :call vimspector#Continue()<CR>

nnoremap <Leader>dt :call vimspector#ToggleBreakpoint()<CR>
nnoremap <Leader>dT :call vimspector#ClearBreakpoints()<CR>

nmap <Leader>dk <Plug>VimspectorRestart
nmap <Leader>dh <Plug>VimspectorStepOut
nmap <Leader>dl <Plug>VimspectorStepInto
nmap <Leader>dj <Plug>VimspectorStepOver

" Enable/Disable GitGutter with keyboard shortcuts (mostly because of how it
" interferes with Vimspector).
nnoremap <Leader>gg :GitGutterToggle<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap <tab> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap <tab> <Plug>(EasyAlign)

" Custom easy align delimiters
let g:easy_align_delimiters = {
\ ']': {
\     'pattern':       ']',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ '(': {
\     'pattern':       '(',
\     'left_margin':   0,
\     'right_margin':  1,
\     'stick_to_left': 0
\   },
\ ')': {
\     'pattern':       ')',
\     'left_margin':   1,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ ':': {
\     'pattern':       ':',
\     'left_margin':   1,
\     'right_margin':  1,
\     'stick_to_left': 0
\   },
\ ',': {
\     'pattern':       ',',
\     'left_margin':   0,
\     'right_margin':  1,
\     'stick_to_left': 1
\   }
\ }

" Define our linters for ale.
let g:ale_linters = {
\   'javascript':      ['eslint'],
\   'javascriptreact': ['eslint'],
\   'typescript':      ['eslint'],
\   'typescriptreact': ['eslint']
\ }

" Define our fixers for ale.
let g:ale_fixers = {
\   'javascript':      ['prettier'],
\   'javascriptreact': ['prettier'],
\   'typescript':      ['prettier'],
\   'typescriptreact': ['prettier']
\ }

" Only run the linters that we specify, not all linters for every file.
let g:ale_linters_explicit = 1

" Don't run fixers on file save.
let g:ale_fix_on_save = 0

" Make F7 a shortcut for running our ale fixers.
nnoremap <F7> :ALEFix<CR>

" Custom Key Mappings for opening files
map <F3> :tabe
map <F4> :tabp<CR>
map <F5> :tabn<CR>

" Show autocomplete options in a list.
set wildmenu
set wildmode=list:full
set wildignorecase
" TODO pum doesn't seem to be working to make the autocomplete use a pop up
" menu like I wanted. Hmm. Gotta figure that out. Try looking
" here: https://vi.stackexchange.com/questions/31563/vertical-wildmenu-in-vim
" and here: https://groups.google.com/g/vim_dev/c/rSRbXUMDZio?pli=1
set wildoptions="pum,tagfile,fuzzy"

" Have j and k move us by visual line rather than file line but still use
" actual file lines for things like jumping by a certain number of lines (e.g.
" '15j' will jump by 15 file lines rather than 15 visual lines) which will
" keep the line jump values aligned with the relative numbers on the left hand
" side of the screen. Also we set up '0' and '$' to move us by visual line
" rather than actual line movement which is really nice as well.
nnoremap <expr> j (v:count? 'j' : 'gj')
nnoremap <expr> k (v:count? 'k' : 'gk')
noremap <silent> 0 g0
noremap <silent> $ g$

" map semicolon to colon
nmap ; :

" map in-file search to always use regex prefix
" also do case insensitive search unless your search contains upper case
" letters, then do case sensitive search (have to set both ignorecase and
" smartcase)
map / /\v
set ignorecase
set smartcase

" For our tag acessing we have the following commands available to us (among
" others that we don't expect to use quite as frequently):
" - <C-]>  : go to highest priority tag of the thing the cursor is currently on.
" - g<C-]> : if there's multiple tags, show a list, if there's only one then
"   just do the <C-]> thing.
" - C-t    : go back down the tag stack (so basically go back to the file you
"   were just at if you just went to a tag).
" - C-\    : do the <C-]> thing except open it in a new tab.
map <C-\> <C-w><C-]><C-w>T
"set switchbuf=useopen,usetab

" Make Vim-Autotag work on Mac
let g:autotagStartMethod='fork'

" Also update ctags in the background every time vim starts.
autocmd BufWritePost *.c,*.h silent! !ctags . &

" select colorscheme
colorscheme nord
syntax on

" Set update time to 100ms so that GitGutter will update quickly
set updatetime=100

" Get delete/backspace key working on mac
set backspace=indent,eol,start

" make comments italic " doesn't work on centos (ie my devbox at Neadwerx)
"set t_ZH=^[[3m
"set t_ZR=^[[23m
"highlight Comment cterm=italic

" copy and paste setup " not currently working
"set clipboard+=unnamed  " use the clipboards of vim and win
"set paste               " Paste from a windows or from vim
"set go+=a               " Visual selection automatically copied to the clipboard

" Convert tabs to 2 spaces
set tabstop=2 softtabstop=0 expandtab shiftwidth=2

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

" General Fold Settings
" TODO disabling folidng settings until I can figure out something that I
" actually like
" nnoremap <Space> za
" vnoremap <Space> za
" highlight folded cterm=none ctermfg=8 ctermbg=none
"
" " Fold settings specifically for typescript
" function! TypeScriptFold()
"     setl foldmethod=syntax
"     setl foldlevelstart=1
"     syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend
" endfunction
" au FileType typescript call TypeScriptFold()
" au FileType typescript setl fen

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

" Let's save undo info!
" If the /.vim/undo-dir directory doesn't exist then create it
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
" Point vim to our undo directory and save our undo stuff there
set undodir=~/.vim/undo-dir
set undofile

" Save location in file when you close it and open back up to that location
" when you open that file again later.
autocmd BufWinLeave ?* mkview
autocmd BufWinEnter ?* silent loadview

" Custom command for quickly inserting '// TODO testing' followed by a new line
command! TodoTestingInsert execute "normal o// TODO testing\n\<Esc>^"
nnoremap <Leader>t :TodoTestingInsert<CR>
