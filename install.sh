#!/bin/bash
source ./common_utility.sh 
function print_install_var() {
    echo "========================="
    echo "Install info"
    echo "Script_Name=${0}"
    echo "Script_Dir=${SCRIPT_DIR}"
    echo "Working_Dir=${WORK_DIR}"
    echo "Backup_Dir=${BK_DIR}"
    echo "Source_Dir=${SRC_DIR}"
    echo "========================"
}

function set_install_var() {
    SCRIPT_NAME=${0}
    SCRIPT_DIR=$(my_realpath ${0})
    WORK_DIR=$(dirname $SCRIPT_DIR)
    BK_DIR=${WORK_DIR}/conf_bk
    SRC_DIR=${WORK_DIR}/conf
    UTILITY_DIR=${SRC_DIR}/.utility

    DOT_FILE_LIST=( ".bashrc"\
                ".vimrc"\
                ".gitconfig"\
                ".screenrc"\
                ".gdbinit"\
                ".bash_profile"\
                ".utility"
                )

}

function backup_dotfiles() {
    echo "========================="
    echo "Start to Backup dotfiles:"
    rm -rf ${BK_DIR}/*
    mkdir -p ${BK_DIR}/

    cd ${BK_DIR}
    for file in "${DOT_FILE_LIST[@]}"
    do
        if [ -e ~/${file} ]; then
            echo "backup ${file}"
            mv ~/${file} ${BK_DIR}
        else
            echo "no ${file} detected in ${HOME}"
        fi
    done
    echo "Backup has been done!"
    echo "========================="
}

function install_dotfiles() {
    echo "========================="
    echo "Start to Install dotfiles:"
    cd ${SRC_DIR}
    for file in "${DOT_FILE_LIST[@]}"
    do
        if [ -f ${file} ] || [ -d ${file} ]; then
            echo "install ${file}"
            ln -f -s ${SRC_DIR}/${file} ~/${file}
        else
            echo "no ${file} detected in ${SRC_DIR}"
        fi
    done
    echo "Installation has been done!"
    echo "========================="
}

function install_bundle() {
    echo "install bundle"
    bundleDir=~/.vim/bundle/Vundle.vim/
    if [[ ! -d ${bundleDir} ]]; then
        mkdir -p ~/.vim/bundle
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
     fi
}

function install_ubuntu_package() {
    echo "install for Ubuntu:"
    apt-get -v >/dev/null 2>&1 || { echo "no apt-get found. exit 1" >&2; exit 1; }
    sudo apt-get update
    for package in "${install_list[@]}"
    do
        ${package} --version > /dev/null 2>&1 || {\
            echo "install ${package}";\
            sudo apt-get install ${package}
        }
    done
}

function install_centos_package() {
    echo "install for CentOS"
    sudo yum update
    for package in "${install_list[@]}"
    do
        ${package} --version > /dev/null 2>&1 || {\
            echo "install ${package}";\
            sudo yum install ${package}
        }
    done
}

function install_linux_package() {
    install_list=( "git"\
            "screen"\
            "ctags"\
            "cscope"\
            "realpath"\
    )
    if [ "${DISTRUBUTION}" == "Ubuntu" ]; then
        install_ubuntu_package
    else
        install_centos_package
    fi
    install_bundle
}

function install_darwin_package() {
    echo "install for Darwin"

    #install homebrew
    brew -v > /dev/null 2>&1 || {\
        echo "install homebrew";\
        /usr/bin/ruby -e \
        "$(curl -fsSL \
        https://raw.githubusercontent.com/Homebrew/install/master/install)";\
    }

    # install realpath
    realpath . > /dev/null 2>&1 || {\
        echo "install realpath";\
        brew tap iveney/mocha;\
        brew install realpath;\
    }

    # install git
    git --version > /dev/null 2>&1 || {\
        echo "install git";\
        brew install git;\
    }

    # installm macvim
    mvim -h > /dev/null 2>&1 || {\
        echo "install macvim";\
        brew install macvim;\
    }

    # install 256-color support screen
    brew install screen

}

function install_package() {
    install_bundle
    update_git_script
    case ${OS} in
        "Linux")
        install_linux_package
        ;;
        "Darwin")
        install_darwin_package
        ;;
        *)
        echo "Do not support ${OS} now"
        ;;
    esac
}

function update_git_script() {
    echo "========================="
    echo "try to get latest git-prompt.sh and git-completion.bash"
    local git_src_url="https://raw.githubusercontent.com/git/git/master/contrib/completion/"
    curl ${git_src_url}/git-prompt.sh -o ${UTILITY_DIR}/git-prompt.sh
    curl ${git_src_url}/git-completion.bash -o ${UTILITY_DIR}/git-completion.bash
    echo "========================="
}

function run_dotfiles() {
    echo "========================="
    echo "Run source ~/.bashrc"
    source ~/.bashrc
    echo "========================="
}

function main() {
    get_os_var
    print_os_var

    set_install_var
    print_install_var

    install_package

    backup_dotfiles
    install_dotfiles

    run_dotfiles
}

main
