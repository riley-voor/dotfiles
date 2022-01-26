" style sheet specific settings

augroup ft_css
    au!

    " *.less files filetyping to less
    au BufNewFile,BufRead *.less setlocal filetype=less

    " add syntax highlighting to '-'
    au Filetype less,css setlocal iskeyword+=-

    " Space to toggle folds.
    au Filetype less,css nnoremap <Space> zA
    au Filetype less,css vnoremap <Space> zA

    " Use <localleader>S to sort properties.  Turns this:
    "
    "     p {
    "         width: 200px;
    "         height: 100px;
    "         background: red;
    "
    "         ...
    "     }
    "
    " into this:

    "     p {
    "         background: red;
    "         height: 100px;
    "         width: 200px;
    "
    "         ...
    "     }
    au BufNewFile,BufRead *.less,*.css nnoremap <buffer> <localleader>S ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>

    " Make {<cr> insert a pair of brackets
    au Filetype css inoremap <buffer> {<cr> {}<left><cr><cr><up><space><space><space><space>
    " }fixes syntax highlighting

augroup END
