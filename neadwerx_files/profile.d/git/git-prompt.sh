#!/bin/bash

# Nead Werx git prompt
# Heavily inspired by git/contrib/git-prompt.sh

# To set this prompt up in your prompt, simple source this file
# in your bashrc
#   source /etc/profile.d/git/git-prompt.sh
#
# Then, add the \`neadwerx_git_prompt\` to your PS1 in your prompt command.
#   function my_prompt () {
#       PS1="$(neadwerx_git_prompt) prompt: "
#   }
#
#   PROMPT_COMMAND="my_prompt"
#
# Zsh is a little bit different, but still uses a prompt_command variable.
# See oh-my-zsh or other zsh resources for how to do this
#
# If you would like to use your own custom prompt, here are some suggestions:
#   - Copy this one, and put your own styling in it
#   - Use the official git-prompt found here: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
#   - Modify the official git-prompt.sh to suit your needs
#   - Use this one https://github.com/magicmonty/bash-git-prompt
#   - Or, this one https://github.com/olivierverdier/zsh-git-prompt
#   - Or, tihs one http://volnitsky.com/project/git-prompt/
#   - Or, use any number of git prompts that can be found by googling!

function _git_branch_status () {
    count=`git rev-list --count --left-right @{u}...HEAD 2>/dev/null`
    case "$count" in
        "") # no upstream
            echo ' !!' # no upstream branch
            ;;
        "0"[[:space:]]"0") # equal to upstream
            echo '' # up-to-date
            ;;
        "0"[[:space:]]*) # ahead of upstream
            echo ' ↑' # need to push
            ;;
        *[[:space:]]"0") # behind upstream
            echo ' ↓' # need to pull
            ;;
        *)      # diverged from upstream
            echo ' ◊' # diverged
            ;;
    esac
}

function _git_branch_highlight () {
    count=`git rev-list --count --left-right @{u}...HEAD 2>/dev/null`
    case "$count" in
        "") # no upstream
            echo '43' # yellow
            ;;
        "0"[[:space:]]"0") # equal to upstream
            echo '42' # green
            ;;
        "0"[[:space:]]*) # ahead of upstream
            echo '42' # green
            ;;
        *[[:space:]]"0") # behind upstream
            echo '41' # red
            ;;
        *)      # diverged from upstream
            echo '43' # yellow
            ;;
    esac
}

# ummm...sets a variable?
function __git_eread () {
    local f="$1"
    shift
    test -r "$f" && read "$@" <"$f"
}

function _git_dirty_status () {
    untracked=false
    if git ls-files --outhers --exclude-standard --directory --no-empty-directory --error-unmatch -- ':/*' >/dev/null 2>&1 ; then
        untracked=true
    fi

    status=`git status --porcelain 2>/dev/null | tail -n1`
    dirty=false
    if [[ -n "$status" ]] ; then
        dirty=true
    fi

    if [[ $untracked == true ]] || [[ $dirty == true ]] ; then
        echo "…"
    fi
}

# shamelessly stolen from git-prompt.sh, and modified to be similar to Kirk's original prompt
function neadwerx_git_prompt () {
    local exit=$?
    local repo_info rev_parse_exit_code
    repo_info="$(git rev-parse --git-dir --is-inside-git-dir \
        --is-bare-repository --is-inside-work-tree \
        --short HEAD 2>/dev/null)"
    rev_parse_exit_code="$?"

    if [ -z "$repo_info" ]; then
        return $exit
    fi

    local short_sha
    if [ "$rev_parse_exit_code" = "0" ]; then
        short_sha="${repo_info##*$'\n'}"
        repo_info="${repo_info%$'\n'*}"
    fi
    local inside_worktree="${repo_info##*$'\n'}"
    repo_info="${repo_info%$'\n'*}"
    local bare_repo="${repo_info##*$'\n'}"
    repo_info="${repo_info%$'\n'*}"
    local inside_gitdir="${repo_info##*$'\n'}"
    local g="${repo_info%$'\n'*}"

    if [ "true" = "$inside_worktree" ] &&
       git check-ignore -q .
    then
        return $exit
    fi

    local r=""
    local b=""
    local step=""
    local total=""
    if [ -d "$g/rebase-merge" ]; then
        __git_eread "$g/rebase-merge/head-name" b
        __git_eread "$g/rebase-merge/msgnum" step
        __git_eread "$g/rebase-merge/end" total
        if [ -f "$g/rebase-merge/interactive" ]; then
            r="|REBASE-i"
        else
            r="|REBASE-m"
        fi
    else
        if [ -d "$g/rebase-apply" ]; then
            __git_eread "$g/rebase-apply/next" step
            __git_eread "$g/rebase-apply/last" total
            if [ -f "$g/rebase-apply/rebasing" ]; then
                __git_eread "$g/rebase-apply/head-name" b
                r="|REBASE"
            elif [ -f "$g/rebase-apply/applying" ]; then
                r="|AM"
            else
                r="|AM/REBASE"
            fi
        elif [ -f "$g/MERGE_HEAD" ]; then
            r="|MERGING"
        elif [ -f "$g/CHERRY_PICK_HEAD" ]; then
            r="|CHERRY-PICKING"
        elif [ -f "$g/REVERT_HEAD" ]; then
            r="|REVERTING"
        elif [ -f "$g/BISECT_LOG" ]; then
            r="|BISECTING"
        fi

        if [ -n "$b" ]; then
            :
        elif [ -h "$g/HEAD" ]; then
            # symlink symbolic ref
            b="$(git symbolic-ref HEAD 2>/dev/null)"
        else
            local head=""
            if ! __git_eread "$g/HEAD" head; then
                return $exit
            fi
            # is it a symbolic ref?
            b="${head#ref: }"
            if [ "$head" = "$b" ]; then
                detached=yes
                b=`git describe --contains --all HEAD 2>/dev/null` || {
                    b="$short_sha..."
                    b="($b)"
                }
            fi
        fi
    fi

    if [ -n "$step" ] && [ -n "$total" ]; then
        r="$r $step/$total"
    fi

    if [ "true" = "$inside_gitdir" ]; then
        if [ "true" = "$bare_repo" ]; then
            c="BARE:"
        else
            b="GIT_DIR!"
        fi
    fi

    b=${b##refs/heads/}

    branch_status=`_git_branch_status`
    branch_highlight=`_git_branch_highlight`
    dirty=`_git_dirty_status`
    echo -n '\[\e[0;37;'"$branch_highlight"';1m\]'"(${b}${r}${dirty}${branch_status})"'\[\e[0m\]'
}
