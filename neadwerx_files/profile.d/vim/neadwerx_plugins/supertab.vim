" NOTE: This file must be sourced inside of a vundle block
" call vundle#begin()
"   runtime! supertab.vim
" call vundle#end()

if exists("g:use_neadwerx_plugins_supertab")
    if !g:use_neadwerx_plugins_supertab
        finish
    endif
endif

Plugin 'ervandew/supertab'

" Plugin Settings --------------------- {{{
" }}}
