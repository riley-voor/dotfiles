" Neadwerx Standards

" Settings {{{

" which direction the standards file window splits
let g:neadwerx_standards_split_vertical = 1

" }}}

" standards file regex hash {{{

let g:neadwerx_standards_file_regex_hash =
\ {
\     '.*\.p[lm]': {
\         '_default' : [ '/engineering/general/coding_standard.md', '#perl#' ],
\     },
\     '.*\.php': {
\         '_default' : [ '/engineering/general/coding_standard.md', '#php#' ],
\     },
\     '.*\.js': {
\         '_default' : [ '/engineering/general/coding_standard.md', '#JavaScript' ],
\     },
\ }

" }}}

" Standards function {{{

function! Standards( ... )
    let current_file = expand( '%:p' )
    let search_file  = substitute( current_file, '\/var\/www\/vhosts\/[^/]\+\/', '', 'g' )
    let wiki_dir     = '/etc/neadwerx/wiki'

    if g:neadwerx_standards_split_vertical == 0
        let split_command = 'sview'
    else
        let split_command = 'vert sview'
    endif

    " loop over the keys in the standards regex hash
    for file_regex in keys( g:neadwerx_standards_file_regex_hash )
        " if the regex matches the current file
        if match( current_file, file_regex ) >= 0
            let help_tag_hash = g:neadwerx_standards_file_regex_hash[file_regex]

            " then loop through the given help tags and help_tags in the hash
            " and pick the correct key if one matches
            " This gives precedence to given tag ordering
            for given_tag in a:000
                for help_tag in keys( help_tag_hash )
                    if match( given_tag, help_tag ) >= 0
                        let standards_file = help_tag_hash[help_tag][0]
                        let search_term    = help_tag_hash[help_tag][1]

                        " open the file in a new read only buffer
                        " on the first line
                        exe expand( split_command ) expand( '+1' ) expand( wiki_dir . standards_file )

                        " search for the search term and goto the first result
                        exe expand( "normal! gg/" . search_term . "\<CR>" )

                        " clear the highlighting
                        exe ':noh'

                        " done
                        return
                    endif
                endfor
            endfor

            " we did not find a matching tag, look for the _default
            if has_key( help_tag_hash, '_default' )
                let standards_file = help_tag_hash['_default'][0]
                let search_term    = help_tag_hash['_default'][1]

                " open the file in a new read only buffer
                " on the first line
                exe expand( split_command ) expand( '+1' ) expand( wiki_dir . standards_file )

                " search for the search term and goto the first result
                exe expand( "normal! gg/" . search_term . "\<CR>" )

                " clear the highlighting
                exe ':noh'

                " done
                return
            else
                " we didn't find any standards files :(
                echom 'Did not find any standards files for file: ' . current_file
                return
            endif
        endif
    endfor

    " we didn't find any matches :(
    echom 'Did not find any matches for file: ' . current_file
    return

endfunction

" }}}

" add the command
command! -nargs=* Standards call Standards( <f-args> )
