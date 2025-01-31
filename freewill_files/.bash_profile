# .bash_profile

# Get the aliases and functions in ~/.bashrc
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# Get the aliases and functions in ~/.profile
if [ -f ~/.profile ]; then
	. ~/.profile
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH

##
# Your previous /Users/riley/.bash_profile file was backed up as /Users/riley/.bash_profile.macports-saved_2022-03-01_at_15:25:49
##

# MacPorts Installer addition on 2022-03-01_at_15:25:49: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.


# MacPorts Installer addition on 2022-03-01_at_15:25:49: adding an appropriate MANPATH variable for use with MacPorts.
export MANPATH="/opt/local/share/man:$MANPATH"
# Finished adapting your MANPATH environment variable for use with MacPorts.


# Setting PATH for Python 2.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
