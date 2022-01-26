" NOTE: This file solely exists as a test for vimrc's to source 
"       the neadwerx_plugins directory
"
" Key:
"   * is a required plugin
"   + is a recommended plugin
"   - is an optional plugin
"
" Optional Plugins:
"   All plugins will be installed and loaded automatically.
"   To opt out of a plugin runnings you simply have to set a flag in your
"   vimrc before sourcing the vundle.vim or neadwerx_vimrc files.
"   As an example of opting out of Supertab:
"
"       let g:use_neadwerx_plugin_supertab = 0
"
"   All optional plugins should follow this standard:
"   g:use_neadwerx_plugin_<PLUGIN_NAME> = { 0 for FALSE, 1 for TRUE }
"
" Nead Werx Plugins:
"   * Syntastic: syntax checking for php, perl, javascript, etc...
"   * Tlib: helper plugin for ultisnips and supertab
"   + EasyAlign: super easy alignment on delimiters
"   + Ultisnips: insert often typed blocks of code
"   + Fugitive: use git from inside of vim
"   - Supertab: smart autocompletion for tab
"   - Endwise: automatically insert ending conditional statements for scripts
