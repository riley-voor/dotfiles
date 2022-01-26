export EDITOR=/usr/bin/vim

# source various files
# these contain lots of configurations
for source_file (/etc/profile.d/zsh/zsh_sources/*); do
  source $source_file
done

# Miscellaneous
## smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

## file rename magick
bindkey "^[m" copy-prev-shell-word

## jobs
setopt long_list_jobs

## pager
export PAGER="less"
export LESS="-R"
export LC_CTYPE=$LANG

# Options
setopt AUTO_CD
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt RM_STAR_WAIT
setopt EXTENDED_GLOB
setopt PROMPTSUBST

# add standards/scripts to path
PATH=$PATH:/etc/profile.d/scripts/

# Apply Alters
function apply_alters()
{
    # Grab the webroot: webroot must end in '.com'
    local path=$( echo $PWD | sed 's/\(com\/\).*/\1/g')
    local test_file=""

    # Check if file path was passed in for running test mode
    if [ $1 ]; then
        test_file="--test $1"
    fi

    ~/linux_utils/apply_alters/./apply_alters.pl \
        --dbhost $( echo $( sed '1q;d' $path/.db ) ) \
        --dbname $( echo $( sed '3q;d' $path/.db ) ) \
        --new_branch $( echo $( git rev-parse --abbrev-ref HEAD ) ) \
        --path_to_sql $( echo $path/sql ) \
        --customer $( sed '1q;d' $path/.customer ) \
        --dbport $( echo $( sed '2q;d' $path/.db ) ) \
        --apply_all_unversioned \
        $test_file
}

alias aa=apply_alters
