# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

export PGHOST="10.0.0.59"

# puts files listed as trailing arguments into tabs rather than windows
alias vim="vim -p"

# quality of life shortenings
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."
alias ..6="cd ../../../../../.."
alias ..7="cd ../../../../../../.."
alias ..8="cd ../../../../../../../.."
alias ..9="cd ../../../../../../../../.."

alias la="ls -a"
alias ll="ls -l"

alias fixapache="sudo systemctl restart httpd"

# make multitail behave like the taile script did
mtaile() {
    multitail --mergeall /var/log/httpd/$1*-error_log
}
