" This file installs the NeadWerx vundle installation

" What you see below is known as a 'fold', to open and close it press <SPACE>
" You can learn more about folding from :help folding

" Vundle ------------------------------- {{{

" Note: If you want to install custom plugins but still use the ones at 
" NeadWerx, then you should add a new plugin.vim file to the
" /etc/profile.d/vim/custom_plugins/ directory. Then call
" :PluginInstall inside of vim.

" NOTE: the below MUST be pointed to the correct installation directory for
" vim extras. If you do not know where this is please contact the author.
let g:vim_dir_neadwerx='/etc/profile.d/vim/'

" This is our plugin manager. There are a few competing managers that
" you can research online at vimisawesome.com. This will automatically install plugins using
" git. Things that are required for Vundle to work are marked.

"""BEGIN VUNDLE INSTALLATION"""
set nocompatible              " required, sets vim to be incompatible with vi
filetype off                  " required, turns off automatic filetype detection for installation

" Auto-install Vundle
let is_vundle_installed=0
let vundle_readme=expand(g:vim_dir_neadwerx.'bundle/Vundle.vim/README.md')
if !filereadable(vundle_readme)
    echo "Installing Vundle..."
    echo ""
    exec 'silent !mkdir -p '.g:vim_dir_neadwerx.'bundle'
    exec 'silent !git clone https://github.com/gmarik/vundle '.g:vim_dir_neadwerx.'bundle/Vundle.vim'
    let is_vundle_installed=1
endif

" set the runtime path to include Vundle and initialize
let vundle=g:vim_dir_neadwerx
let &runtimepath.=expand(','.g:vim_dir_neadwerx)
let &runtimepath.=expand(','.g:vim_dir_neadwerx.'neadwerx_plugins')
let &runtimepath.=expand(','.g:vim_dir_neadwerx.'custom_plugins')
let &runtimepath.=expand(','.g:vim_dir_neadwerx.'bundle/Vundle.vim')

" Here is where you would add new plugins.
" These are the git repos on github.
" If you add new plugins be sure to run :PluginInstall to install them,
" or :PluginUpdate to update the ones you currently have installed
" Set vundle to install in g:vim_dir_neadwerx
call vundle#begin(expand(g:vim_dir_neadwerx.'bundle'))
    Plugin 'gmarik/Vundle.vim'

    let neadwerx_plugin_vim=expand(g:vim_dir_neadwerx.'neadwerx_plugins.vim')
    if( filereadable(neadwerx_plugin_vim) )
        " See :help runtime for an explanation
        runtime! neadwerx_plugins/*.vim
        runtime! custom_plugins/*.vim
    endif

    " Insert your own plugins here
call vundle#end()

" Installing vundle plugins
if is_vundle_installed == 1
    echo "Installing Plugins..."
    echo ""
    :PluginInstall
endif

filetype plugin indent on    " required
"""END VUNDLE INSTALLATION"""

" }}}
