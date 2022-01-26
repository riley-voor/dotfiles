" vim file specific settings

augroup ft_vim
    au!

    " turn on folding
    au FileType vim setlocal foldmethod=marker
    au FileType help setlocal textwidth=80

    " Folding ------------------------------ {{{
    
    " enable folding and start folds with level-0 unfolded
    au FileType vim setlocal foldenable
    au FileType vim setlocal foldlevelstart=0
    
    " Space to toggle folds.
    au FileType vim nnoremap <Space> za
    au FileType vim vnoremap <Space> za
    
    " Make zO recursively open whatever fold we're in, even if it's partially open.
    au FileType vim nnoremap zO zczO
    
    function! MyFoldText() " {{{
        let line = getline(v:foldstart)
    
        let nucolwidth = &fdc + &number * &numberwidth
        let windowwidth = winwidth(0) - nucolwidth - 3
        let foldedlinecount = v:foldend - v:foldstart
    
        " expand tabs into spaces
        let onetab = strpart('          ', 0, &tabstop)
        let line = substitute(line, '\t', onetab, 'g')
    
        let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
        let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
        return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
    endfunction " }}}
    
    au FileType vim setlocal foldtext=MyFoldText()
    
    " }}}

augroup END
