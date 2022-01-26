" NOTE: This file must be sourced inside of a vundle block
" call vundle#begin()
"   runtime! endwise.vim
" call vundle#end()

if exists("g:use_neadwerx_plugins_fugitive")
    if !g:use_neadwerx_plugins_fugitive
        finish
    endif
endif

Plugin 'tpope/vim-fugitive'

" Plugin Settings --------------------- {{{
" }}}
