" settings for 'SirVer/ultisnips' and 'tomtom/tlib_vim'

" add neadwerx plugins to the runtime path
let &runtimepath.=',/etc/profile.d/vimrc/plugins'

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsSnippetsDir='/etc/profile.d/vimrc/plugins/neadwerx_snippets'
let g:UltiSnipsSnippetDirectories=["UltiSnips","neadwerx_snippets"]

" Need a command to list the snippets
command! UltiList :call UltiSnips#ListSnippets()

func! SnippetList()
    let response = matchstr(tlib#input#CommandSelect('UltiList'), '([A-Za-z0-9_]\+')
    if !empty(response)
        " Escape to normal mode
        exec "normal! \e"
        " delete the word under the cursor
        norm diw
        " find the part of the line that already has been typed
        let response = strpart(response,1)
        exec expand(':norm a'.response)
        norm a
    endif
endfunc

inoremap <c-t> <C-\><C-O>:call SnippetList()<CR>
