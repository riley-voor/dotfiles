" bash specific settings

augroup ft_bash
    au!

    " Make {<cr> insert a pair of brackets
    au Filetype bash inoremap <buffer> {<cr> {}<left><cr><cr><up><space><space><space><space>
    " }fixes syntax highlighting
augroup END
