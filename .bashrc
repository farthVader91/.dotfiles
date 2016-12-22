# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# mitsuhiko's stuff
export EDITOR=vim
export GIT_EDITOR=vim

MITSUHIKOS_DEFAULT_COLOR="[00m"
MITSUHIKOS_GRAY_COLOR="[37m"
MITSUHIKOS_PINK_COLOR="[35m"
MITSUHIKOS_GREEN_COLOR="[32m"
MITSUHIKOS_ORANGE_COLOR="[33m"
MITSUHIKOS_RED_COLOR="[31m"
if [ `id -u` == '0' ]; then
  MITSUHIKOS_USER_COLOR=$MITSUHIKOS_RED_COLOR
else
  MITSUHIKOS_USER_COLOR=$MITSUHIKOS_PINK_COLOR
fi


MITSUHIKOS_VC_PROMPT=$' on \033[34m%n\033[00m:\033[00m%b\033[32m%m%u'

mitsuhikos_vcprompt() {
  prompt="$MITSUHIKOS_VC_PROMPT"
  vcprompt -f "$prompt"
}

mitsuhikos_lastcommandfailed() {
  code=$?
  if [ $code != 0 ]; then
    echo -n $'\033[37m exited \033[31m'
    echo -n $code
    echo -n $'\033[37m'
  fi
}

mitsuhikos_virtualenv() {
  if [ x$VIRTUAL_ENV != x ]; then
    if [[ $VIRTUAL_ENV == *.virtualenvs/* ]]; then
      ENV_NAME=`basename "${VIRTUAL_ENV}"`
    else
      folder=`dirname "${VIRTUAL_ENV}"`
      ENV_NAME=`basename "$folder"`
    fi
    echo -n $' \033[37mworkon \033[31m'
    echo -n $ENV_NAME
    echo -n $'\033[00m'
    # Shell title
    echo -n $'\033]0;venv:'
    echo -n $ENV_NAME
    echo -n $'\007'
  fi

  # Also setup our readline properly constantly since
  # stuff tends to overwrite this.
  stty werase undef
  bind '"\C-w": unix-filename-rubout'
}

export MITSUHIKOS_BASEPROMPT='\e]0;\007\n\e${MITSUHIKOS_USER_COLOR}\u \
\e${MITSUHIKOS_GRAY_COLOR}at \e${MITSUHIKOS_ORANGE_COLOR}\h \
\e${MITSUHIKOS_GRAY_COLOR}in \e${MITSUHIKOS_GREEN_COLOR}\w\
`mitsuhikos_lastcommandfailed`\
\e${MITSUHIKOS_GRAY_COLOR}`mitsuhikos_vcprompt`\
`mitsuhikos_virtualenv`\
\e${MITSUHIKOS_DEFAULT_COLOR}'
export PS1="\[\033[G\]${MITSUHIKOS_BASEPROMPT}
$ "

export TERM=xterm-256color
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export CLICOLOR=1
if [ `uname` == "Darwin" ]; then
  export LSCOLORS=ExGxFxDxCxHxHxCbCeEbEb
  export LC_CTYPE=en_US.utf-8
  export LC_ALL=en_US.utf-8
else
  alias ls='ls --color=auto'
fi
export IGNOREEOF=1
export PYTHONDONTWRITEBYTECODE=1
export LESS=FRSX

# virtualenvwrapper and pip
if [ `id -u` != '0' ]; then
  export VIRTUALENV_DISTRIBUTE=1
  if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME=$HOME/.virtualenvs
    source /usr/local/bin/virtualenvwrapper.sh
  fi
  if [ -f ~/.local/venvs/virtualenvwrapper/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME=$HOME/.virtualenvs
    export VIRTUALENVWRAPPER_PYTHON=~/.local/venvs/virtualenvwrapper/bin/python
    source ~/.local/venvs/virtualenvwrapper/bin/virtualenvwrapper.sh
  fi
fi

# don't let virtualenv show prompts by itself
VIRTUAL_ENV_DISABLE_PROMPT=1

# add path to Java binaries
export JAVA_HOME="/usr/lib/jvm/java-8-oracle"

# virtualenvwrapper settings
PROJECT_HOME="/home/vishal/Projects"

# hackerearth bashrc stuff
alias cs='cd ~/webapps/django/mycareerstack'
alias log='sudo tail -f /var/log/apache2/error.log'
alias ar='sudo service apache2 restart'

staticcollect() {
    myvar="$PWD"
    cs
    ./manage.py localcollectstatic --settings=local.hackerearth_settings;
    cd "$myvar"
}

# Make all PATH modifications
CUSTOM_ADDITIONS="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
ANDROID_SDK_PATH="/home/vishal/Downloads/android-sdk-linux/tools:/home/vishal/Downloads/android-sdk-linux/platform-tools:/home/vishal/Downloads/android-sdk-linux/build-tools/23.0.2:/usr/local/android-studio/bin/"
ARCANIST_PATH="/home/vishal/arcanist/bin/"
APACHE_STORM_PATH="/home/vishal/storm/apache-storm-0.9.5/bin"
FLATBUFFER_PATH="/home/vishal/Projects/flatbuffers"

# Define default Go workspace
export GOPATH="/home/vishal/gophers"
GOPATH_BIN="$GOPATH/bin"

# Path to Telegram
TELEGRAM_PATH="/home/vishal/Downloads/Telegram"

# flamegraph path
FLAMEGRAPH_PATH="/home/vishal/Projects/profilers/FlameGraph"

PATH=$PATH:$CUSTOM_ADDITIONS:$ANDROID_SDK_PATH:$ARCANIST_PATH:$APACHE_STORM_PATH
PATH=$PATH:$GOPATH_BIN:$TELEGRAM_PATH:$FLAMEGRAPH_PATH:$FLATBUFFER_PATH
# add path to go binaries
PATH=$PATH:/usr/local/go/bin
export PATH=$PATH

# Preserve the below in case you fucked something up
# export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/vishal/Downloads/android-sdk-linux/tools:/home/vishal/Downloads/android-sdk-linux/platform-tools:~/arcanist/bin/

# Your Aliases

# Management cmd aliases
alias msh='./manage.py shell --settings=local.hackerearth_settings'
alias mdb='./manage.py dbshell --settings=local.hackerearth_settings'

# Custom script aliases
CUSTOM_SCRIPTS_PATH="/home/vishal/custom_scripts"
alias lighten="$CUSTOM_SCRIPTS_PATH/lighten_load.sh"
alias heighten="$CUSTOM_SCRIPTS_PATH/heighten_load.sh"
alias zzz='sudo pm-suspend'
alias sshemu='ssh -i ~/.ssh/hetzner.pem root@136.243.105.104'
alias add_alias='/home/vishal/webapps/django/hackerearth-scripts/scripts/add_alias'
alias mkpkg='/home/vishal/.custom_scripts/make_py_pkg.sh'
alias lbr='git for-each-ref --sort=-committerdate refs/heads'


export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export EC2_HOME=~/.ec2
export PATH=$PATH:$EC2_HOME/bin
export EC2_PRIVATE_KEY=$EC2_HOME/pk-KGYH22KS7ZDDSUK5PINFVPNQADLGWD5B.pem
export EC2_CERT=$EC2_HOME/cert-KGYH22KS7ZDDSUK5PINFVPNQADLGWD5B.pem
export EC2_URL=https://ec2.ap-southeast-1.amazonaws.com

export AWS_AUTO_SCALING_HOME=~/.ec2
export AWS_AUTO_SCALING_URL=https://ec2.ap-southeast-1.amazonaws.com

export AWS_ELB_HOME=~/.ec2
export AWS_ELB_URL=https://elasticloadbalancing.ap-southeast-1.amazonaws.com

export AWS_CREDENTIAL_FILE=~/.ec2/aws-credential
export PATH="$HOME/.embulk/bin:$PATH"
