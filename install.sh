#!/bin/bash
source ./common_utility.sh

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

    echo "install init.vim for nvim"
    local nvim_config_dir="${HOME}/.config/nvim"
    mkdir -p ${nvim_config_dir}
    ln -f -s ${SRC_DIR}/.vimrc ${nvim_config_dir}/init.vim

    echo "Installation has been done!"
    echo "========================="
}

function install_bundle() {
    echo "install bundle"
    local bundleDir=~/.vim/bundle/Vundle.vim/
    if [[ ! -d ${bundleDir} ]]; then
        mkdir -p ~/.vim/bundle
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
     fi
}

function install_ubuntu_package() {
    echo "install for Ubuntu"
    if ! command -v apt-get > /dev/null 2>&1 ; then
        echo "no apt-get found. exit 1"
        exit 1
    else
        sudo apt-get update
    fi

    for package in "${Linux_package_list[@]}"
    do
        check_and_apt_install ${package} ${package}
    done

    # install ag
    check_and_apt_install "ag" "silversearcher-ag"
}

function install_centos_package() {
    echo "install for CentOS"
    if ! command -v yum > /dev/null 2>&1 ; then
        echo "no yum found. exit 1"
        exit 1
    else
       sudo yum update
    fi

    for package in "${Linux_package_list[@]}"
    do
        check_and_yum_install ${package} ${package}
    done

    # install ag
    check_and_yum_install "ag" "the_silver_searcher"

}

function install_linux_package() {
    Linux_package_list=( "git"\
                         "screen"\
                         "ctags"\
                         "cscope"\
                         "realpath"\
                         "tree"
                       )
    if [ "${DISTRUBUTION}" == "Ubuntu" ]; then
        install_ubuntu_package
    else
        install_centos_package
    fi

    install_bundle

    # install awscli
    if ! command -v aws > /dev/null 2>&1 ; then
        echo "install aws CLI"
        pip install awscli --user --upgrade
    else
        echo "aws CLI  has been installed"
    fi
}

function install_darwin_package() {
    echo "install for Darwin"

    #install homebrew
    if ! command -v brew > /dev/null 2>&1 ; then
        echo "install homebrew"
        /usr/bin/ruby -e \
        "$(curl -fsSL \
        https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        echo "homebrew has been installed"
    fi

    # install realpath
    if ! command -v realpath > /dev/null 2>&1 ; then
        echo "install realpath"
        brew tap iveney/mocha
        brew install realpath
    else
        echo "realpath has been installed"
    fi

    local Darwin_package_list=( "git"\
                                "python"\
                                "screen"\
                                "tree"\
                              )

    for package in "${Darwin_package_list[@]}"
    do
        check_and_brew_install ${package} ${package}
    done

    # install awscli
    if ! command -v aws > /dev/null 2>&1 ; then
        echo "install aws CLI"
        pip install awscli --user --upgrade
    else
        echo "aws CLI  has been installed"
    fi

    # install neovim
    if ! command -v nvim > /dev/null 2>&1 ; then
        echo "install neovim"
        brew install neovim
        pip install neovim --user --upgrade
    else
        echo "neovim has been installed"
    fi

    # install ag
    check_and_brew_install "ag" "the_silver_searcher"

	brew install bash-completion

}

function install_package() {
    install_bundle
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

    update_git_script
    update_docker_script
}

function update_docker_script() {
    echo "========================="
    echo "try to get docker compose and docker machine autocomplete"
    local machine_url="https://raw.githubusercontent.com/docker/machine/v0.13.0/contrib/completion/bash/docker-machine.bash"
    local compose_url="https://raw.githubusercontent.com/docker/compose/1.18.0/contrib/completion/bash/docker-compose"
    case ${OS} in
        "Linux")
         local auto_complete_dir="/etc/bash_completion.d"
        ;;
        "Darwin")
         local auto_complete_dir="/usr/local/etc/bash_completion.d"
        ;;
        *)
        echo "Do not support ${OS} now"
        ;;
    esac
    curl -L ${machine_url} -o ${auto_complete_dir}/docker-machine
    curl -L ${compose_url} -o ${auto_complete_dir}/docker-compose
    echo "========================="
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
    get_os_info
    print_os_info

    set_install_info
    print_install_info

    install_package

    backup_dotfiles
    install_dotfiles

    run_dotfiles
}

main
