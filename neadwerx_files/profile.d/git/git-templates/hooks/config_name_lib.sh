#!/bin/bash

function array_pop () {
    local arrayname=${1:?Array name required} array val varname=${2:-var}
    eval "array=( \"\${$arrayname[@]}\" )"
    if [[ ${#array[@]} -lt 1 ]] ; then
        eval "$varname="
        return 1
    fi
    eval "$varname=\${array[0]}"
    unset array[0]
    eval "$arrayname=( \"\${array[@]}\" )"
}

# prints out help and disclaimer information about incorrectly named configs
# Note: this only runs once right before the first print_config call
print_disclaimer_has_run=false
function print_disclaimer () {
    if [[ $print_disclaimer_has_run == false ]] ; then
        print_disclaimer_has_run=true

        color_echo yellow "Configs should be named according to the standards on Confluence [see: https://neadwerx.atlassian.net/wiki/x/m4AEAQ]"
        color_echo yellow "Here's how configs are parsed:"
        color_echo green  "\t<page>#<object>.<props>-><action>:<behaviour>"
        color_echo yellow "Here's the list of approved actions:"

        temp_actions=(${approved_actions[@]})
        while [[ ${#temp_actions[@]} -gt 0 ]] ; do
            array_pop temp_actions a1
            array_pop temp_actions a2
            array_pop temp_actions a3
            array_pop temp_actions a4
            array_pop temp_actions a5

            printf "\t:$a1:$a2:$a3:$a4:$a5\n"
        done | column -t -s ':'

        color_echo yellow "Here's the list of approved api actions: (for use when the object is 'api')"

        temp_api_actions=(${approved_api_actions[@]})
        while [[ ${#temp_api_actions[@]} -gt 0 ]] ; do
            array_pop temp_api_actions a1
            array_pop temp_api_actions a2
            array_pop temp_api_actions a3
            array_pop temp_api_actions a4
            array_pop temp_api_actions a5

            printf "\t:$a1:$a2:$a3:$a4:$a5\n"
        done | column -t -s ':'

        color_echo yellow "Here's the list of approved behaviours:"

        temp_behaviours=(${approved_behaviours[@]})
        while [[ ${#temp_behaviours[@]} -gt 0 ]] ; do
            array_pop temp_behaviours a1
            array_pop temp_behaviours a2
            array_pop temp_behaviours a3
            array_pop temp_behaviours a4
            array_pop temp_behaviours a5

            printf "\t:$a1:$a2:$a3:$a4:$a5\n"
        done | column -t -s ':'

        echo "" # newline
        color_echo red "If you have any questions on config names, please talk with Moshe."
        color_echo red "If you have any questions about the checking, please talk with Kirk"
    fi
}

# prints out the parsed config with coloring
function print_config () {
    file_name="$1"
    shift
    config_name="$1"
    page_name="$2"
    object="$3"
    properties="$4"
    action="$5"
    behaviour="$6"
    system_action="$7"
    valid="$8"
    reason="$9"

    # first attempt to print the disclaimer
    print_disclaimer

    [ -n "$file_name" ] && echo "File          : $file_name"
    color_echo yellow "Config        : $config_name"
    echo "Page          : $page_name"
    echo "Object        : $object"
    echo "Properties    : $properties"
    echo "Action        : $action"
    echo "Behaviour     : $behaviour"
    echo "System Action : $system_action"

    if [[ $valid == true ]] ; then
        color_echo green "Valid         : $valid"
    else
        color_echo red "Valid         : $valid"
    fi

    echo "Reason        : $reason"

    type hook_error >/dev/null 2>&1 && hook_error
}

# set of approved user actions that one can do in xerp
approved_actions=(
    view
    create
    update
    delete
    toggle
    reject
    approve
    review
    publish
    submit
    clone
    cancel
    override
    import
    generate
    lock
    release
    schedule
    attach
)

# set of approved user actions that one can do in the api
approved_api_actions=(
    access
    get
    post
    put
    delete
)

# set of approved system behaviours that xerp obeys relating to an action
approved_behaviours=(
    show
    use
    allow
    require
    notify
)

# set of potentially bad prop names
prohibited_props=(
    filter
)

function check_config_file () {
    local file="$1"
    # check for valid json
    jsonlint -q $file >/dev/null || {
        echo "Invalid JSON found in config.json: $file"
        exit 1
    }

    # get the single config name without trailing newline
    config_name=`jq -r 'keys[]' $file | tr -d '\n'`

    check_config_name "$config_name" "$file"
    return $?
}

# File parameter is optional
function check_config_name () {
    local config_name="$1"
    local file="$2"

    # validate the config name against our naming standards (see: https://neadwerx.atlassian.net/wiki/x/m4AEAQ)
    # <page>#<object>.<props>-><action>:<behaviour>
    # All of which are optional, except for the <object>
    # First, break up our config_name into parts
    processing="$config_name"

    # reset
    page_name=""
    system_action=""
    behaviour=""
    action=""
    properties=""
    object=""
    valid=""

    # turn <page>#<object>.<props>-><action>:<behaviour/system_action>
    # into <object>.<props>-><action>:<behaviour>
    if echo "$processing" | grep -q -P "#" ; then
        page_name=`echo "$processing" | cut -d'#' -f1`
        processing=`echo "$processing" | cut -d'#' -f2-`
    fi

    # turn <object>.<props>-><action>:<behaviour/system_action>
    # into <object>.<props>-><action>
    if echo "$processing" | grep -q -P ":" ; then
        behaviour=`echo "$processing" | cut -d':' -f2-`
        processing=`echo "$processing" | cut -d':' -f1`

        # check to see if it's actually a behaviour or if it is a system_action
        if echo "$behaviour" | grep -q -P -- '->' ; then
            # it's a system_action
            system_action="$behaviour"
            behaviour=""
        fi
    fi

    # turn <object>.<props>-><action>
    # into <object>.<props>
    if echo "$processing" | grep -q -P -- '->' ; then
        action=`echo "$processing" | awk -F"->" '{print $2}'`
        processing=`echo "$processing" | awk -F"->" '{print $1}'`
    fi

    # turn <object>.<props>
    # into <object>
    if echo "$processing" | grep -q -P "\." ; then
        properties=`echo "$processing" | cut -d'.' -f2-`
        processing=`echo "$processing" | cut -d'.' -f1`
    fi

    # it's what's leftover
    object="$processing"

    # check the validity of the config
    valid=true

    # object is required
    if [[ -z "$object" ]] ; then
        print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "Object is required"
        return 1
    else
        # object must only contain \w+
        if echo "$object" | grep -q -P -v "^\w+$" ; then
            print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "Object contains incorrect characters: must only contain \\w+"
            return 1
        fi

        # object must match the sub-directory name of the file,
        # only if there is not a page_name
        if [[ -z "$page_name" ]] ; then
            if [ -n "$file" ] ; then
                dir=$(basename $(dirname $file))

                if [[ "$dir" != "$object" ]] ; then
                    print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "Config in incorrect sub-directory: expected $object (object), found $dir"
                    return 1
                fi
            fi
        fi

        # if the object starts with an approved behaviour, then
        # maybe it should be a behaviour instead?
        object_first_word=`echo $object | cut -d'_' -f1`
        matches_glob_element "$object_first_word" "${approved_behaviours[@]}"
        if [[ $? == 0 ]] ; then
            # matched
            print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "Object is named like a behaviour: try moving the behaviour to the end"
            return 1
        fi
    fi

    # If there is a page
    if [[ -n "$page_name" ]] ; then
        # the page must exist from the webroot
        if [[ ! -f "$page_name" ]] ; then
            print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "Page does not exist"
            return 1
        fi

        # the config must only be used on one page
        pages=(`ag -l -Q "config:$config_name"`)
        if [[ ${#pages[@]} -gt 1 ]] ; then
            print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "Config used on multiple pages:"
            for page in ${pages[@]} ; do
                echo "              :     $page"
            done

            return 1
        fi

        # the config must only be used on the same page as page_name
        actual_page=`ag -l -Q "config:$config_name"`
        if [[ "$actual_page" != "$page_name" ]] ; then
            print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "Config specifies wrong page: found on '$actual_page'"
            return 1
        fi

        # first part of the page must match the sub-directory name
        dir=$(basename $(dirname $file))
        first_part_of_page=`echo $page_name | grep -P -o '^\w+'`

        if [[ "$dir" != "$first_part_of_page" ]] ; then
            print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "Config in incorrect sub-directory: expected $first_part_of_page (page), found $dir"
            return 1
        fi
    fi

    # if there are properties
    if [[ -n "$properties" ]] ; then
        # they must only contain [\w.]+
        # except for the last property which may contain sectioning [sec1][sec2]... zero or more times
        if echo "$properties" | grep -q -P -v "^[\w.]*?[\w]+([[]\w+[]])*$" ; then
            print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "Properties contain incorrect characters: must only contain [\\w.]+"
            return 1
        fi

        # each property should be no more than 3 words long
        # split properties on .
        props_without_sections=`echo $properties | cut -d'[' -f1`
        IFS=. eval 'props=(`echo $props_without_sections`)'
        for prop in ${props[@]} ; do
            IFS=_ eval 'words=(`echo $prop`)'
            if [[ ${#words[@]} -gt 3 ]] ; then
                print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "Properties are too long: expected 3 or fewer words, found ${#words[@]}"
                return 1
            fi
        done

        # if any property contains a prohibited word, warn the user
        for word in ${prohibited_props[@]} ; do
            if echo $properties | grep -q -P "$word" ; then
                print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "Properties contain prohibited word '$word', consider changing this word to something less confusing"
                return 1
            fi
        done
    fi

    # ensure that actions only exist with a behaviour or a system_action
    if [[ -n "$action" ]] ; then
        if [[ -z "$system_action" ]] && [[ -z "$behaviour" ]] ; then
            print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "Actions must have an associated behaviour or system_action"
            return 1
        fi
    fi

    # if there is an action
    if [[ -n "$action" ]] ; then
        # if the object is "api", then it has a special set of actions
        if [[ "$object" == "api" ]] ; then
            # it must be in the approved list of api actions
            matches_glob_element "$action" "${approved_api_actions[@]}"
            if [[ $? != 0 ]] ; then
                # did not match
                print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "Action is not in the approved set of api actions"
                return 1
            fi
        else
            # set of object specific actions
            case "$object" in
                survey)
                    object_specific_actions=(test)
                    ;;
            esac

            # it must be in the approved list of user actions or in the object specific actions list
            matches_glob_element "$action" "${approved_actions[@]}" "${object_specific_actions[@]}"
            if [[ $? != 0 ]] ; then
                # did not match
                print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "Action is not in the approved set of user actions"
                return 1
            fi
        fi
    fi

    # if there is a behaviour
    if [[ -n "$behaviour" ]] ; then
        # it must be in the approved list of behaviours, and
        # it can have additional <behaviour>_<words...> after it for specificity
        core_behaviour=`echo $behaviour | cut -d'_' -f1`

        matches_glob_element "$core_behaviour" "${approved_behaviours[@]}"
        if [[ $? != 0 ]] ; then
            # did not match
            print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "Behaviour is not in the approved set"
            return 1
        fi

        # behaviour must match \w+
        if echo "$behaviour" | grep -q -P -v "^\w+$" ; then
            print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "Behaviour contains incorrect characters: must only contain \\w+"
            return 1
        fi

        if [ -n "$file" ] ; then
            # behaviour config default must contain a boolean
            config_value=`cat $file | jq 'to_entries[].value.default' | tr -d '\n'`
            if [[ "$config_value" != "true" ]] && [[ "$config_value" != "false" ]] ; then
                print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "Incorrect type for config: expected bool, found '$config_value'"
                return 1
            fi
        fi
    fi

    # if there is a system_action
    if [[ -n "$system_action" ]] ; then
        # re-process the system_action into <object>.<props>-><action>
        system_action_object=""
        system_action_props=""
        system_action_action=""
        processing="$system_action"

        # turn <object>.<props>-><action>
        # into <object>.<props>
        if echo "$processing" | grep -q -P -- '->' ; then
            system_action_action=`echo "$processing" | awk -F"->" '{print $2}'`
            processing=`echo "$processing" | awk -F"->" '{print $1}'`
        fi

        # turn <object>.<props>
        # into <object>
        if echo "$processing" | grep -q -P "\." ; then
            system_action_props=`echo "$processing" | cut -d'.' -f2-`
            processing=`echo "$processing" | cut -d'.' -f1`
        fi

        # it's what's leftover
        system_action_object="$processing"

        # basically re-check everything like the user action, but for the system
        # system_action_object is required
        if [[ -z "$system_action_object" ]] ; then
            print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "System Action Object is required"
            return 1
        else
            # system_action_object must only contain \w+
            if echo "$system_action_object" | grep -q -P -v "^\w+$" ; then
                print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "System Action Object contains incorrect characters: must only contain \\w+"
                return 1
            fi
        fi

        # if there are system_action_properties
        if [[ -n "$system_action_properties" ]] ; then
            # they must only contain [\w.]+
            if echo "$system_action_properties" | grep -q -P -v "^[\w.]*$" ; then
                print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "System Action Properties contain incorrect characters: must only contain [\\w.]+"
                return 1
            fi

            # each property should be no more than 3 words long
            # split system_action_properties on .
            props_without_sections=`echo $system_action_properties | cut -d'[' -f1`
            IFS=. eval 'props=(`echo $props_without_sections`)'
            for prop in ${props[@]} ; do
                IFS=_ eval 'words=(`echo $prop`)'
                if [[ ${#words[@]} -gt 3 ]] ; then
                    print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "System Action Properties are too long: expected 3 or fewer properties, found ${#words[@]}"
                    return 1
                fi
            done

            # if any property contains a prohibited word, warn the user
            for word in ${prohibited_props[@]} ; do
                if echo $system_action_properties | grep -q -P "$word" ; then
                    print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "System Action Properties contain prohibited word '$word', consider changing this word to something less confusing"
                    return 1
                fi
            done
        fi

        # if there is a system_action
        if [[ -n "$system_action_action" ]] ; then
            # if the system_action_object is "api", then it has a special set of actions
            if [[ "$system_action_object" == "api" ]] ; then
                # it must be in the approved list of api actions
                matches_glob_element "$system_action_action" "${approved_api_actions[@]}"
                if [[ $? != 0 ]] ; then
                    # did not match
                    print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "System Action Action is not in the approved set of api actions"
                    return 1
                fi
            else
                # set of object specific actions
                case "$object" in
                    survey)
                        object_specific_actions=(test)
                        ;;
                esac

                # it must be in the approved list of user actions or in the object specific actions list
                matches_glob_element "$system_action_action" "${approved_actions[@]}" "${object_specific_actions[@]}"
                if [[ $? != 0 ]] ; then
                    # did not match
                    print_config "$file" "$config_name" "$page_name" "$object" "$properties" "$action" "$behaviour" "$system_action" false "System Action Action is not in the approved set of user actions"
                    return 1
                fi
            fi
        fi
    fi

    return 0
}
