#!/bin/bash

function my_realpath(){
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

function get_os_info(){
    # get basic system info
    OS=$(uname -s)
    ARCH=$(uname -m)
    VER=$(uname -r)
    DISTRIBUTION=$(grep DISTRIB_ID /etc/*-release | awk -F '=' '{print $2}')
}


function print_os_info() {
    get_os_info
    echo "========================="
    echo "OS Info:"
    echo "OS=${OS}"
    echo "ARCH=${VER}"
    echo "VER=${VER}"
    echo "DISTRIBUTION=${DISTRIBUTION}"
    echo "========================="
}


function check_file_and_create(){
    local checkFile=$1
    echo $checkFile
    if [[ ! -f "$checkFile" ]];then
        touch "$checkFile"
    fi
    chmod +x "$checkFile"
}

function check_folder_and_create(){
    local check_folder=$1
    echo ${check_folder}
    if [[ ! -d "${check_folder}" ]];then
        mkdir -p ${check_folder}
    fi
}

function check_link_and_create(){
    local checkFile=$1
    echo $checkFile
    if [[ ! -L "$checkFile" ]];then
        touch "$checkFile"
    fi
    chmod +x "$checkFile"
}

function check_file_and_remove(){
    local checkFile=$1
    echo $checkFile
    if [[ -f "$checkFile" ]];then
        rm -rf  "$checkFile"
    fi
}

function check_Link_and_remove(){
    local checkFile=$1
    echo $checkFile
    if [[ -L "$checkFile" ]];then
        rm -rf  "$checkFile"
    fi
}

function check_and_yum_install(){
    local cmd=${1}
    local package_name=${2}
    if ! command -v ${cmd} > /dev/null 2>&1 ; then
        echo "install ${package_name} for ${cmd}"
        sudo yum install ${package_name}
    else
        echo "${package_name} for ${cmd} has been installed"
    fi
}

function check_and_apt_install(){
    local cmd=${1}
    local package_name=${2}
    if ! command -v ${cmd} > /dev/null 2>&1 ; then
        echo "install ${package_name} for ${cmd}"
        sudo apt-get install ${package_name}
    else
        echo "${package_name} for ${cmd} has been installed"
    fi

}

function check_and_brew_install(){
    local cmd=${1}
    local package_name=${2}
    if ! command -v ${cmd} > /dev/null 2>&1 ; then
        echo "install ${package_name} for ${cmd}"
        brew install ${package_name}
    else
        echo "${package_name} for ${cmd} has been installed"
    fi
}
