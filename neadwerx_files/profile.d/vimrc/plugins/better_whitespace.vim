" neadwerx settings for 'ntpeters/vim-better-whitespace'

" wrapper function for deleting whitespace while saving cursor position
function! Delete_whitespace()
    " get the current cursor position
    let save_pos = getpos(".")

    " call vim-better-whitespace#:StripWhitespace
    :StripWhitespace

    " return the cursore to the saved position
    call setpos(".", save_pos)
endfunction

" auto-delete whitespace on write
autocmd BufWritePre * call Delete_whitespace()
