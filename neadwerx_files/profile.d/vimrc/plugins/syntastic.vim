" settings for 'scrooloose/syntastic'

" add syntastic_checkers to the path
let $PATH.=';/etc/profile.d/vimrc/plugins/syntastic_checkers/'

" javascript checkers
let g:syntastic_javascript_checkers = ['jshint', 'eslint']
let g:syntastic_javascript_jshint_args = '--config /etc/profile.d/vimrc/plugins/syntastic_checkers/jshintrc --verbose'
let g:syntastic_javascript_eslint_args = '--config /etc/profile.d/vimrc/plugins/syntastic_checkers/eslintrc.js --no-ignore'

" php checkers
let g:syntastic_php_phpcs_args = '--standard=NeadWerx'

" perl checkers
let g:syntastic_enable_perl_checker = 1
let g:syntastic_perl_checkers = ['perl', 'perlcritic']
let g:syntastic_perl_perlcritic_args = '--profile /etc/profile.d/vimrc/plugins/syntastic_checkers/perlcriticrc'
let g:syntastic_perl_perlcritic_thres = 3

" python checkers
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_python_pylint_post_args = '--msg-template="{path}:{line}:{column}:E: [{symbol} {msg_id}] {msg}" --rcfile=/etc/profile.d/vimrc/plugins/syntastic_checkers/pylintrc'

" turn on the popup error list
let g:syntastic_auto_loc_list = 1

" turn off checking on quit command
let g:syntastic_check_on_wq = 0

" passive mode by default
let g:syntastic_mode_map = { "mode": "passive",
                           \ "active_filetypes": [],
                           \ "passive_filetypes": [] }

" function WrapCommand {{{

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

" }}}

" function ToggleErrors {{{

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

" }}}

" function PerlTidy {{{

" run perltidy on the current file and turn on syntastic
function! PerlTidy()
    write!
    setlocal autoread
    silent !perltidy --profile='/etc/profile.d/vimrc/plugins/syntastic_checkers/perltidyrc' %:p
    redraw!
    call SyntasticCheck()
    let b:syntastic_mode="active"
    redraw!
endfunction

" }}}

" map <F7> to turn on syntastic
nnoremap <F7> :SyntasticCheck<CR>:let b:syntastic_mode="active"<CR>

" perl map <F7> to PerlTidy
au Filetype perl nnoremap <silent> <F7> :call PerlTidy()<CR>

" map <F8> to toggle the error list
nnoremap <silent> <F8> :<c-u>call ToggleErrors()<CR>

" <Home> and <End> go up and down the location list and wrap around
nnoremap <silent> <Home> :call WrapCommand('up', 'l')<CR>
nnoremap <silent> <End>  :call WrapCommand('down', 'l')<CR>

" aggregate errors and warnings into the same view
au Filetype javascript let g:syntastic_aggregate_errors=1
au Filetype php let g:syntastic_aggregate_errors=0
au Filetype perl let g:syntastic_aggregate_errors=0
