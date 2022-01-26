" Neadwerx Example

" Settings {{{

" which direction the example file splits windows
let g:neadwerx_example_split_vertical = 1

" }}}

" example file regex hash {{{

let g:neadwerx_example_file_regex_hash =
\ {
\     'perl\/generate_.*\.pl' : {
\         '_default'  : [ '/perl/generate_project_history_csv.pl', 1 ],
\         'generate'  : [ '/perl/generate_project_history_csv.pl', 1 ],
\         'reports\?' : [ '/perl/generate_project_history_csv.pl', 1 ],
\     },
\     '.*\.js': {
\         '_default' : [ '/project/js/stores_tab.js', 1 ],
\     },
\     'common\/ajax\/.*' : {
\         '_default' : [ '/common/ajax/update_node_participart.php', 1 ],
\     },
\     'common\/db_lib\/.*' : {
\         '_default' : [ '/common/db_lib/get_spaces_by_location_map.php', 1 ],
\     },
\     'reports\/.*\.php' : {
\         '_default' : [ '/reports/execution_status_report.php', 90 ],
\     },
\     '.*\/templates\/.*\.php' : {
\         '_default'     : [ '/dashboard/templates/project_central_columns_partial.php', 1 ],
\         'handlebars\?' : [ '/dashboard/templates/project_central_columns_partial.php', 1 ],
\         'partial'      : [ '/dashboard/templates/project_central_columns_partial.php', 1 ],
\     },
\     'api\/.*' : {
\         '_default'                                      : [ '/api/controllers/orders.php', 1 ],
\         'controllers\?'                                 : [ '/api/controllers/orders.php', 1 ],
\         'doc\(block\)\?'                                : [ '/api/controllers/orders.php', 10 ],
\         'get'                                           : [ '/api/controllers/orders.php', 57 ],
\         '\(put\|update\)'                               : [ '/api/controllers/orders.php', 415 ],
\         'delete'                                        : [ '/api/controllers/orders.php', 564 ],
\         'search'                                        : [ '/api/controllers/orders.php', 178 ],
\         '\(search_\)\?filters\?'                        : [ '/api/controllers/orders.php', 244 ],
\         '\(post\|new\|create\)'                         : [ '/api/controllers/orders.php', 322 ],
\         'views\?'                                       : [ '/api/views/orders.php', 1 ],
\         '\(https?\|status\(_codes\?\|es\)\?\|codes\?\)' : [ '/api/api_lib.php', 1 ],
\     },
\     'config\/.*\.json' : {
\         '_default'           : [ '/config/role/role_update_allow.json', 1 ],
\         'allows\?'           : [ '/config/role/role_update_allow.json', 1 ],
\         'tabs\?\(_order\)\?' : [ '/config/project/project_view_project_php_tab_order.json', 1 ],
\         'uses\?'             : [ '/config/project/project_space_count_use.json', 1 ],
\         'regexp\?'           : [ '/config/buget_code/budget_code_validation_regex.json', 1 ],
\         'pks\?'              : [ '/config/location_group_type/location_group_type_buying_office_pk.json', 1 ],
\         'columns\?'          : [ '/config/location/store_projects_tab_php_columns.json', 1 ],
\     },
\     '.*\.php': {
\         '_default'     : [ '/dashboard/project_central.php', 1 ],
\     },
\ }

" }}}

" Example Function {{{

function! Example( ... )
    let current_file = expand( '%:p' )
    let search_file  = substitute( current_file, '\/var\/www\/vhosts\/[^/]\+\/', '', 'g' )
    let webroot_dir  = substitute( current_file, '\(\/var\/www\/vhosts\/[^/]\+\)\/.*', '\1', 'g' )

    if g:neadwerx_example_split_vertical == 0
        let split_command = 'sview'
    else
        let split_command = 'vert sview'
    endif

    " loop over the keys in the example regex hash
    for file_regex in keys( g:neadwerx_example_file_regex_hash )
        " if the regex matches the current file
        if match( current_file, file_regex ) >= 0
            let help_tag_hash = g:neadwerx_example_file_regex_hash[file_regex]

            " then loop through the given help tags and help_tags in the hash
            " and pick the correct key if one matches
            " This gives precedence to given tag ordering
            for given_tag in a:000
                for help_tag in keys( help_tag_hash )
                    if match( given_tag, help_tag ) >= 0
                        let example_file = help_tag_hash[help_tag][0]
                        let line_number  = help_tag_hash[help_tag][1]

                        " open the file on the correct line number
                        " in a new read only buffer
                        exe expand( split_command ) expand( '+' . line_number ) expand( webroot_dir . example_file )

                        " done
                        return
                    endif
                endfor
            endfor

            " we did not find a matching tag, look for the _default
            if has_key( help_tag_hash, '_default' )
                let example_file = help_tag_hash['_default'][0]
                let line_number  = help_tag_hash['_default'][1]

                " open the file on the correct line number
                " in a new read only buffer
                exe expand( split_command ) expand( '+' . line_number ) expand( webroot_dir . example_file )

                " done
                return
            else
                " we didn't find any example files :(
                echom 'Did not find any example files for file: ' . current_file
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
command! -nargs=* Example call Example( <f-args> )
