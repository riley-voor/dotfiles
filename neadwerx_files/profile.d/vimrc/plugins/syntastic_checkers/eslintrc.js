module.exports = {
    "env": {
        "browser": true,
        "jquery": true,
        "es6": true
    },
    "parserOptions": {
        "ecmaVersion": 5,
        "sourceType": "script",
    },
    "plugins": [
        "varspacing",
        "literate",
        "no-useless-assign",
    ],
    "globals": {
        // from common/functions/globals.php#output_js_globals
        // vars
        "session_pk_effective_entity": false,
        "session_pk_actual_entity": false,
        "session_effective_entity_name": false,
        "session_effective_entity_email": false,
        "session_actual_entity_name": false,
        "session_actual_entity_email": false,
        "global_pk_entity": false,
        "global_virtual_url": false,
        "global_saml_enabled": false,
        "global_saml_login_used": false,
        "global_saml_sso_modal_login_width": false,
        "global_saml_sso_modal_login_height": false,
        "global_check_notification": false,
        "global_locale": false,
        "global_date_format_label": false,
        "global_date_format_description": false,
        "global_date_format_regex": false,

        // from common/functions/includes.php

        // common/js/loginlogout.js
        // functions
        "submit_on_enter": false,
        "logout": false,
        "receive_logout_response": false,
        "validate_login": false,
        "saml_login": false,
        "receive_validate_response": false,
        "forgot_password": false,

        // common/js/common.js
        // vars
        "space_comma_regex": false,
        "session": false,
        "nav1_stack": false,
        "nav2_queue": false,
        "nav_items_total_width": false,
        // functions
        "add_header_to_tree": false,
        "add_to_map_if_array": false,
        "add_to_map_if_positive": false,
        "add_to_map_if_true": false,
        "_ajax_request": false,
        "array_intersection": false,
        "basename": false,
        "bind": false,
        "block_filters": false,
        "block_ui_body": false,
        "browser_alert": false,
        "BrowserDetect": false,
        "calibrate_gridlist": false,
        "catch_search_input_change": false,
        "checkbox_display_toggle": false,
        "check_location_list": false,
        "clean_array": false,
        "close_modal": false,
        "collapse_expand_all_tree_nodes": false,
        "collapsible_close": false,
        "collapsible_trigger": false,
        "colorbox_resize": false,
        "common_initialize": false,
        "convert_time_diff_to_interval": false,
        "create_date_no_timezone": false,
        "create_element": false,
        "create_option": false,
        "create_table_header": false,
        "create_text_node": false,
        "create_tree_div_at_level": false,
        "create_tree": false,
        "db_explode_array_agg": false,
        "dirname": false,
        "disable_hyperlink": false,
        "emulate_user": false,
        "enable_archive_mode": false,
        "enable_dynamic_scrolling_tabs": false,
        "enable_scrolling_flex_tabs": false,
        "enable_scrolling_tabs": false,
        "flex_column_width": false,
        "flex_table_setup": false,
        "flex_table_update": false,
        "flex_table_width": false,
        "format_ui_date": false,
        "format_ui_id": false,
        "format_ui_number": false,
        "format_ui_phone_number": false,
        "format_ui_sku": false,
        "generate_password": false,
        "get_config_value": false,
        "get_cookie": false,
        "get_datepicker_format": false,
        "get_editable_defaults": false,
        "get_filter_value": false,
        "get_first_monday_of_month_date_str": false,
        "get_numeric_keypress_handler": false,
        "get_random_number": false,
        "get_scrolling_element": false,
        "image_modal_resize": false,
        "instantiate": false,
        "is_chrome": false,
        "is_firefox": false,
        "is_IE": false,
        "is_invalid_character": false,
        "is_ms_edge": false,
        "is_ms_ie": false,
        "lanczosCreate": false,
        "launch_login_modal": false,
        "loading_table": false,
        "load_url": false,
        "map_launch_check": false,
        "modal_resize_2": false,
        "modal_resize_default": false,
        "modal_resize": false,
        "multilingual_extract": false,
        "MyDate": false,
        "navbar_overflow_adjust": false,
        "nav_parent_link": false,
        "nav_second_level_toggle": false,
        "notify": false,
        "numeric_integer_only": false,
        "numeric_integer_spaces_comma": false,
        "numeric_positive_integer_only": false,
        "numeric_positive_integer_spaces_comma": false,
        "numeric_positive_real_hundredths_only": false,
        "numeric_positive_real_only": false,
        "numeric_real_hundredths_only": false,
        "numeric_real_only": false,
        "open_context_record_modal": false,
        "organize_table_headers": false,
        "pad": false,
        "pathinfo": false,
        "populate_filter_dropdown_list": false,
        "receive_emulate_user": false,
        "receive_get_global_notification_list": false,
        "receive_toggle_archive_mode_response": false,
        "receive_toggle_rollout_lock_response": false,
        "send_get_global_notification_list": false,
        "send_toggle_archive_mode_request": false,
        "send_toggle_rollout_lock_request": false,
        "setup_ajax": false,
        "setup_autocomplete_highlight": false,
        "setup_basic_tabs": false,
        "setup_emulating_email_autocomplete": false,
        "setup_helptip": false,
        "setup_loginout_handler": false,
        "setup_tabs": false,
        "setup_tan_tabs": false,
        "setup_tooltip": false,
        "sort_into_tree": false,
        "strtotime": false,
        "tab_extras_toggle": false,
        "thumbnailer": false,
        "toFixedFix": false,
        "toggle_loading_row": false,
        "toggle_tree_node_children": false,
        "to_server_date_format": false,
        "to_server_number_format": false,
        "unblock_ui_body": false,
        "undbind": false,
        "uniqid": false,
        "user_settings": false,
        "view_notifications": false,
        "xml_get_child_node": false,
        "xml_get_child_nodes": false,
        "xml_get_child_value": false,

        // common/js/translate.jsphp
        // vars
        "language_mapping": false,

        // common/js/validate.js
        // vars
        "mail_pattern": false,
        "mail_pattern_grouped": false,
        "username_pattern": false,
        "invalid_phone_pattern": false,
        "invalid_extension_pattern": false,
        // functions
        "is_blank": false,
        "is_false": false,
        "is_integer": false,
        "is_integer_positive_or_negative": false,
        "is_key_in_object": false,
        "is_key_pressed_numeric": false,
        "is_missing_empty_or_blank": false,
        "is_missing_or_empty": false,
        "is_null_or_undefined": false,
        "is_number_in_range": false,
        "is_number_negative": false,
        "is_number_positive": false,
        "is_numeric": false,
        "is_true": false,
        "is_valid_alphanumeric": false,
        "is_valid_comma_separated_integer_list": false,
        "is_valid_date": false,
        "is_valid_email": false,
        "is_valid_extension": false,
        "is_valid_json": false,
        "is_valid_json_response": false,
        "is_valid_phone_number": false,
        "is_valid_server_date": false,
        "is_valid_single_email": false,
        "is_valid_time": false,
        "is_valid_username": false,
        "validate_json_response": false,
        "validate_xml_response": false,
        "XOR": false,

        // common/js/modernizr.custom.min.js
        // functions
        "Modernizr": false,

        // common/js/html2canvas.js
        // functions
        "html2canvas": false,

        // common/js/handlebars.js
        // functions
        "Handlebars": false,

        // from common/includes/html5footer.php
        // vars
        "ajaxURL": false,
        "feedbackButton": false,
        "tpl": false,
        // functions
        "delete_feedback_attachment": false,
    },
    "extends": [
        "eslint:recommended",
        "plugin:varspacing/recommended",
    ],
    "rules": {
        "accessor-pairs": "error",
        "array-bracket-spacing": [
            "error",
            "never"
        ],
        "array-callback-return": "error",
        "arrow-body-style": "error",
        "arrow-parens": "error",
        "arrow-spacing": "error",
        "block-scoped-var": "error",
        "block-spacing": [
            "error",
            "always"
        ],
        "brace-style": [
            "error",
            "allman",
        ],
        "callback-return": "error",
        "camelcase": "off",
        "comma-dangle": [
            "error",
            "always-multiline",
        ],
        "comma-spacing": [
            "error",
            {
                "before": false,
                "after": true,
            }
        ],
        "comma-style": [
            "error",
            "last"
        ],
        "complexity": [
            "error",
            20,
        ],
        "computed-property-spacing": "error",
        "consistent-return": [
            "warn",
            {
                "treatUndefinedAsUnspecified": false,
            }
        ],
        "consistent-this": "error",
        "curly": [
            "error",
            "all",
        ],
        "default-case": [
            "error",
            {
                "commentPattern": "^(skip|no)\\sdefault",
            }
        ],
        "dot-location": [
            "error",
            "property"
        ],
        "dot-notation": "off",
        "eol-last": "error",
        "eqeqeq": "error",
        "func-names": "off",
        "func-style": [
            "error",
            "declaration"
        ],
        "generator-star-spacing": "error",
        "global-require": "error",
        "guard-for-in": "error",
        "handle-callback-err": "error",
        "id-blacklist": [
            "warn",
            "datum",
            "error",
            "err",
            "e",
            "record",
            "records",
            "temp",
            "t",
            "callback",
            "cb",
        ],
        "id-length": [
            "warn",
            {
                "min": 3,
                "exceptions": [
                    "pk", "id", "ui",
                    "a", "r", "g", "b",
                    "x", "y", "z",
                    "i", "j", "k",
                ],
                "properties": "never",
            }
        ],
        "id-match": [
            "error",
            // Matches lower_snake_case or CamelCase or CAPS_CASE, with jQuery "$" prefixes.
            "^(([$]?[a-z_]+)+|([$]?[A-Z][a-z]+)+|([$]?[A-Z_]+)+)$",
        ],
        "indent-neadwerx": [
            "error",
            4,
            {
                "SwitchCase": 1,
                "VariableDeclarator": 0,
            }
        ],
        "init-declarations": "off",
        "jsx-quotes": "error",
        "key-spacing": [
            "error",
            {
                "singleLine": {
                    "beforeColon": false,
                    "afterColon": true,
                    "mode": "strict",
                },
                "multiLine": {
                    "beforeColon": true,
                    "afterColon": true,
                    "mode": "minimum",
                    "align": "colon",
                },
            }
        ],
        "keyword-spacing": [
            "error",
            {
                "before": true,
                "after": false,
                "overrides": {
                    "case": { "after": true },
                    "return": { "after": true },
                }
            }
        ],
        "linebreak-style": [
            "error",
            "unix"
        ],
        "lines-around-comment": [
            "error",
            {
                "beforeBlockComment": true,
                "beforeLineComment": true,
                "allowBlockStart": true,
                "allowObjectStart": true,
            }
        ],
        "literate/comment-coverage": [
            "warn",
            10,
        ],
        "max-depth": "error",
        "max-len": [
            "error",
            {
                "code": 180,
                "comments": 180,
                "tabWidth": 4,
                "ignoreUrls": true,
            }
        ],
        "max-lines": "off",
        "max-nested-callbacks": "error",
        "max-params": [
            "error",
            {
                "max": 3
            }
        ],
        "max-statements": [
            "warn",
            50
        ],
        "max-statements-per-line": "error",
        "new-cap": "error",
        "new-parens": "error",
        "newline-after-var": "off",
        "newline-before-return": "error",
        "newline-per-chained-call": [
            "error",
            {
                "ignoreChainWithDepth": 3,
            }
        ],
        "no-alert": "off",
        "no-array-constructor": "error",
        "no-bitwise": "error",
        "no-caller": "error",
        "no-case-declarations": "error",
        "no-catch-shadow": "error",
        "no-cond-assign": [
            "error",
            "except-parens",
        ],
        "no-confusing-arrow": "error",
        "no-continue": "off",
        "no-console": [
            "warn",
            {
                "allow": [
                    "warn",
                    "error",
                ],
            },
        ],
        "no-div-regex": "error",
        "no-duplicate-imports": "error",
        "no-else-return": "error",
        "no-empty": [
            "error",
            {
                "allowEmptyCatch": true
            }
        ],
        "no-empty-function": "error",
        "no-eq-null": "error",
        "no-eval": "error",
        "no-extend-native": "error",
        "no-extra-bind": "error",
        "no-extra-label": "error",
        "no-extra-parens": [
            "error",
            "functions",
        ],
        "no-fallthrough": [
            "error",
            {
                "commentPattern": "^falls?\\sthrough",
            }
        ],
        "no-floating-decimal": "error",
        "no-implicit-globals": "off",
        "no-implicit-coercion": "error",
        "no-implied-eval": "error",
        "no-inline-comments": "off",
        "no-inner-declarations": [
            "error",
            "functions"
        ],
        "no-invalid-this": "error",
        "no-iterator": "error",
        "no-label-var": "error",
        "no-labels": [
            "warn",
            {
                "allowLoop": true,
            }
        ],
        "no-lone-blocks": "error",
        "no-lonely-if": "error",
        "no-loop-func": "error",
        "no-magic-numbers": [
            "warn",
            {
                "ignore": [
                    -10, -9, -8, -7, -6, -5, -4, -3, -2, -1,
                    0,
                    1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                    100,
                ],
            }
        ],
        "no-mixed-operators": "error",
        "no-mixed-requires": "error",
        "no-multi-spaces": [
            "warn",
            {
                "exceptions": {
                    "Property": true,
                    "VariableDeclarator": true,
                    "AssignmentExpression": true,
                    "CallExpression": true,
                }
            }
        ],
        "no-multi-str": "error",
        "no-multiple-empty-lines": "error",
        "no-native-reassign": "error",
        "no-negated-condition": "off",
        "no-nested-ternary": "error",
        "no-new": "error",
        "no-new-func": "error",
        "no-new-object": "error",
        "no-new-require": "error",
        "no-new-wrappers": "error",
        "no-octal-escape": "error",
        "no-param-reassign": "error",
        "no-path-concat": "error",
        "no-plusplus": "off",
        "no-process-env": "error",
        "no-process-exit": "error",
        "no-proto": "error",
        "no-restricted-globals": "error",
        "no-restricted-imports": "error",
        "no-restricted-modules": "error",
        "no-restricted-syntax": "error",
        "no-return-assign": "error",
        "no-script-url": "warn",
        "no-self-compare": "error",
        "no-sequences": "error",
        "no-shadow": [
            "error",
            {
                "allow": [],
            }
        ],
        "no-shadow-restricted-names": "error",
        "no-spaced-func": "error",
        "no-sync": "error",
        "no-ternary": "off",
        "no-throw-literal": "error",
        "no-undef": "error",
        "no-undef-init": "error",
        "no-undefined": "error",
        "no-underscore-dangle": "off",
        "no-unmodified-loop-condition": "error",
        "no-unneeded-ternary": "error",
        "no-unsafe-finally": "error",
        "no-unused-vars": [
            "error",
            {
                "vars": "all",
                "args": "after-used",
                "caughtErrors": "all",
                "varsIgnorePattern": "(^ignore_|^_|_unused$)",
                "argsIgnorePattern": "(^ignore_|^_|_unused$)",
                "caughtErrorsIgnorePattern": "(^ignore_|^_|_unused$)",
            }
        ],
        "no-unused-vars-used": [
            "error",
            {
                "varsIgnorePattern": "(^ignore_|^_|_unused$)",
                "argsIgnorePattern": "(^ignore_|^_|_unused$)",
                "caughtErrorsIgnorePattern": "(^ignore_|^_|_unused$)",
            }
        ],
        "no-unused-expressions": "error",
        "no-use-before-define": [
            "error",
            {
                "functions": false,
                "classes": true,
            }
        ],
        "no-useless-assign/no-useless-assign": "error",
        "no-useless-call": "error",
        "no-useless-computed-key": "error",
        "no-useless-concat": "error",
        "no-useless-constructor": "error",
        "no-useless-escape": "error",
        "no-useless-rename": "error",
        "no-var": "off",
        "no-void": "error",
        "no-warning-comments": "error",
        "no-whitespace-before-property": "error",
        "no-with": "error",
        "object-curly-newline": [
            "error",
            {
                "multiline": true,
                "minProperties": 1,
            }
        ],
        "object-curly-spacing": [
            "error",
            "always",
        ],
        "object-property-newline": "error",
        "object-shorthand": "off",
        "one-var": [
            "error",
            "never",
        ],
        "one-var-declaration-per-line": "error",
        "operator-assignment": "warn",
        "operator-linebreak": [
            "error",
            "after",
        ],
        "padded-blocks": [
            "error",
            "never",
        ],
        "prefer-arrow-callback": "off",
        "prefer-const": "error",
        "prefer-reflect": "off",
        "prefer-rest-params": "off",
        "prefer-spread": "off",
        "prefer-template": "off",
        "quote-props": [
            "error",
            "consistent",
        ],
        "quotes": [
            "error",
            "single",
            {
                "avoidEscape": true,
            }
        ],
        "radix": [
            "error",
            "always"
        ],
        "require-jsdoc": "off",
        "require-yield": "error",
        "rest-spread-spacing": "error",
        "semi": [
            "error",
            "always",
        ],
        "semi-spacing": "error",
        "sort-imports": "error",
        "sort-vars": "off",
        "space-before-blocks": [
            "error",
            "always",
        ],
        "space-before-function-paren": [
            "error",
            {
                "anonymous": "ignore",
                "named": "never",
            }
        ],
        "space-in-parens": [
            "error",
            "always",
            {
                "exceptions": [
                    "{}",
                ],
            }
        ],
        "space-infix-ops": "error",
        "space-unary-ops": "error",
        "spaced-comment": "error",
        "strict": [
            "error",
            "never"
        ],
        "template-curly-spacing": "error",
        "unicode-bom": "off",
        "valid-jsdoc": "off",
        "vars-on-top": "off",
        "wrap-iife": "error",
        "wrap-regex": "error",
        "yield-star-spacing": "error",
        "yoda": "error",
    }
};
