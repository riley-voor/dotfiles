" NOTE: This file must be sourced inside of a vundle block
" call vundle#begin()
"   runtime! endwise.vim
" call vundle#end()

if exists("g:use_neadwerx_plugins_endwise")
    if !g:use_neadwerx_plugins_endwise
        finish
    endif
endif

Plugin 'tpope/vim-endwise'

" Plugin Settings --------------------- {{{
" }}}
