" NOTE: This file must be sourced inside of a vundle block
" call vundle#begin()
"   runtime! syntastic.vim
" call vundle#end()

Plugin 'scrooloose/syntastic'

" Plugin Settings --------------------- {{{

let $PATH.=';/etc/profile.d/vim/neadwerx_plugins/syntastic_checkers/'

let g:syntastic_javascript_checkers = ['jshint', 'jscs']

let g:syntastic_javascript_jshint_args = '--config /etc/profile.d/vim/neadwerx_plugins/syntastic_checkers/jshintrc --verbose'
let g:syntastic_javascript_jscs_args = '--config /etc/profile.d/vim/neadwerx_plugins/syntastic_checkers/jscsrc --verbose'
let g:syntastic_php_phpcs_args = '--standard=NeadWerx'

let g:syntastic_enable_perl_checker = 1
let g:syntastic_perl_checkers = ['perl', 'perlcritic']
let g:syntastic_perl_perlcritic_args = '--profile /etc/profile.d/vim/neadwerx_plugins/syntastic_checkers/perlcriticrc'
let g:syntastic_perl_perlcritic_thres = 3

let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_mode_map = { "mode": "passive",
                           \ "active_filetypes": [],
                           \ "passive_filetypes": [] }

nnoremap <F7> :SyntasticCheck<CR>:let b:syntastic_mode="active"<CR>

" wrap :cnext/:cprevious and :lnext/:lprevious
function! WrapCommand(direction, prefix)
    if a:direction == "up"
        try
            execute a:prefix . "previous"
        catch /^Vim\%((\a\+)\)\=:E553/
            execute a:prefix . "last"
        catch /^Vim\%((\a\+)\)\=:E\%(776\|42\):/
        endtry
    elseif a:direction == "down"
        try
            execute a:prefix . "next"
        catch /^Vim\%((\a\+)\)\=:E553/
            execute a:prefix . "first"
        catch /^Vim\%((\a\+)\)\=:E\%(776\|42\):/
        endtry
    endif
endfunction

" toggle syntastic error list
function! ToggleErrors()
    if empty(filter(tabpagebuflist(), 'getbufvar(v:val, "&buftype") is# "quickfix"'))
        " No location/quickfix list shown, open syntastic error location panel
        " Turn on syntastic
        let b:syntastic_mode="active"
        call SyntasticCheck()
    else
        " Turn off syntastic
        let b:syntastic_mode="passive"
        call SyntasticReset()
        lclose
    endif
endfunction

" run perltidy on the current file and turn on syntastic
function! PerlTidy()
    write!
    setlocal autoread
    silent !perltidy --profile='/etc/profile.d/vim/neadwerx_plugins/syntastic_checkers/perltidyrc' %:p
    redraw!
    call SyntasticCheck()
    let b:syntastic_mode="active"
    redraw!
endfunction

nnoremap <silent> <F8> :<c-u>call ToggleErrors()<CR>

" <Home> and <End> go up and down the location list and wrap around
nnoremap <silent> <Home> :call WrapCommand('up', 'l')<CR>
nnoremap <silent> <End>  :call WrapCommand('down', 'l')<CR>

au Filetype javascript let g:syntastic_aggregate_errors=1
au Filetype php let g:syntastic_aggregate_errors=0
au Filetype perl let g:syntastic_aggregate_errors=0
au Filetype perl nnoremap <silent> <F7> :call PerlTidy()<CR>

" }}}
