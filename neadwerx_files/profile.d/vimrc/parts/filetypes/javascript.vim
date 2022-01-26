" javascript specific settings

augroup ft_javascript
    au!

    " Space to toggle folds.
    au Filetype javascript nnoremap <Space> zA
    au Filetype javascript vnoremap <Space> zA

    " Make {<cr> insert a pair of brackets
    au Filetype javascript inoremap <buffer> {<cr> {}<left><cr><cr><up><space><space><space><space>
    " }fixes syntax highlighting
augroup END
