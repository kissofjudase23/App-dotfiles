source ~/.utility/git_prompt.sh

function exitstatus {
    EXITSTATUS="$?"

    # Colors
    RCol='\e[0m'    # Text Reset

    # Regular           Bold                Underline           High Intensity      BoldHigh Intens     Background          High Intensity Backgrounds
    Bla='\e[0;30m';     BBla='\e[1;30m';    UBla='\e[4;30m';    IBla='\e[0;90m';    BIBla='\e[1;90m';   On_Bla='\e[40m';    On_IBla='\e[0;100m';
    Red='\e[0;31m';     BRed='\e[1;31m';    URed='\e[4;31m';    IRed='\e[0;91m';    BIRed='\e[1;91m';   On_Red='\e[41m';    On_IRed='\e[0;101m';
    Gre='\e[0;32m';     BGre='\e[1;32m';    UGre='\e[4;32m';    IGre='\e[0;92m';    BIGre='\e[1;92m';   On_Gre='\e[42m';    On_IGre='\e[0;102m';
    Yel='\e[0;33m';     BYel='\e[1;33m';    UYel='\e[4;33m';    IYel='\e[0;93m';    BIYel='\e[1;93m';   On_Yel='\e[43m';    On_IYel='\e[0;103m';
    Blu='\e[0;34m';     BBlu='\e[1;34m';    UBlu='\e[4;34m';    IBlu='\e[0;94m';    BIBlu='\e[1;94m';   On_Blu='\e[44m';    On_IBlu='\e[0;104m';
    Pur='\e[0;35m';     BPur='\e[1;35m';    UPur='\e[4;35m';    IPur='\e[0;95m';    BIPur='\e[1;95m';   On_Pur='\e[45m';    On_IPur='\e[0;105m';
    Cya='\e[0;36m';     BCya='\e[1;36m';    UCya='\e[4;36m';    ICya='\e[0;96m';    BICya='\e[1;96m';   On_Cya='\e[46m';    On_ICya='\e[0;106m';
    Whi='\e[0;37m';     BWhi='\e[1;37m';    UWhi='\e[4;37m';    IWhi='\e[0;97m';    BIWhi='\e[1;97m';   On_Whi='\e[47m';    On_IWhi='\e[0;107m';

    PROMPT="${RCol}${On_IBla}[\d \t]${RCol} ${IBla}\u@\h${RCol}:${Yel}\w${RCol}${Pur}\$(__git_ps1)${RCol}"

    if [ "${EXITSTATUS}" -eq 0 ]; then
        PS1="${PROMPT} ${BGre}:)${RCol}\n\$ "
    else
        PS1="${PROMPT} ${BRed}:(${RCol}\n\$ "
    fi

    PS2="${BOLD}>${RCol} "
}

envir_var_setting() {
    export VISUAL=vim #set vim as default editor
    export EDITOR="$VISUAL"
    # don't put duplicate lines or lines starting with space in the history.
    # See bash(1) for more options
    HISTCONTROL=ignoreboth
    PROMPT_COMMAND=exitstatus
}

go_env_setting(){
    go_src=/usr/local
    export PATH=$PATH:${go_src}/go/bin
    # your go project.
    #export GOPATH=${HOME}/e23-Git-Dev/Go_Practice
    #export PATH=$PATH:$GOPATH/bin
}

common_alias(){
    alias vi='vim'
    alias tree='tree -C'
}

linux_alias() {
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias ls='ls --colo=auto'
    alias ll='ls -alF --color=auto'
    alias la='ls -A --color=auto'
    alias l='ls -CF --color=auto'
}

darwin_alias() {
    export CLICOLOR='true'
    export LSCOLORS="gxfxcxdxcxegedabagacad"
    alias grep='grep'
    alias fgrep='fgrep'
    alias egrep='egrep'
    alias ls='ls'
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
}

alias_setting() {
    common_alias

    OS=$(uname -s)
    case ${OS} in
        "Linux")
            linux_alias
            ;;
        "Darwin")
            darwin_alias
            ;;
        *)
        echo "Do not support ${OS} now"
    esac
}

main() {
    alias_setting
    envir_var_setting
}

main


