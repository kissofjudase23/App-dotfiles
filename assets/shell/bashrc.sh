source ~/.assets/shell/common.sh
source ~/.assets/git/git-prompt.sh
source ~/.assets/git/git-completion.bash
[[ -s ~/.gvm/scripts/gvm ]] && source ~/.gvm/scripts/gvm

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

function common_env_setting() {
    # don't put duplicate lines or lines starting with space in the history.
    # See bash(1) for more options
    HISTCONTROL=ignoreboth
    PROMPT_COMMAND=exitstatus



    if command -v nvim > /dev/null 2>&1 ; then
        export VISUAL=nvim       # set nvim as default editor
        export EDITOR="$VISUAL"
    else
        export VISUAL=vim       # set vim as default editor
        export EDITOR="$VISUAL"
    fi

    if command -v aws > /dev/null 2>&1 ; then
        local aws_completer_path=$(command -v aws_completer)
        complete -C ${aws_completer_path} aws
    fi
}

function linux_env_setting() {

   # auto jump script
    if [ -f /etc/profile.d/autojump.bash ]; then
       . /etc/profile.d/autojump.bash
    fi
}

function darwin_env_setting() {

    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi

   # auto jump script
    if [ -f /usr/local/etc/profile.d/autojump.sh ]; then
       . /usr/local/etc/profile.d/autojump.sh
    fi
}

function envir_setting() {
    common_env_setting

    OS=$(uname)
    case ${OS} in
        "Linux")
            linux_env_setting
            ;;
        "Darwin")
            darwin_env_setting
            ;;
        *)
        echo "Do not support ${OS} now"
    esac

}

function main() {
    envir_setting

}

main



[ -f ~/.fzf.bash ] && source ~/.fzf.bash
