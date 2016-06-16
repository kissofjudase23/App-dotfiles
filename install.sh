#!/bin/bash
# author: Tom_Lin
# date:   2015/12/2

#include common functions
source ./system_info.sh

#this function is dupracted now.
depracted_code() {
	chmod +x "e23_config.sh"
	ln -s $(pwd)/e23_config.sh ~/e23_config_symbolic
	LINE='source ~/e23_config_symbolic'
	FILE=.bashrc
	cd ~
	# check .bashrc and create if necessary.
	Check_File_and_Create $FILE

	# add a entry porint to user-defined script in .bashrc.
	# add LINE to FILE only if this LINE dose not exists.
	grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

	# For .vimrc
	# check .bashrc and delete if necessary.
	FILE=.vimrc
	Check_File_and_Delete $FILE

	cd - 
	# create a symbolic for user-defined .vimrc
	ln -s $(pwd)/$FILE ~/$FILE
}

backup_dotfiles() {
	rm -rf ${BK_DIR}/*
	mkdir -p ${BK_DIR}/

	cd ${BK_DIR}
	for file in "${FILE_LIST[@]}"
	do
		if [ -e ~/${file} ]; then
			echo "backup ${file}"
			mv ~/${file} ${BK_DIR}
		else
			echo "no ${file} detected in ${HOME}"
		fi
	done
}

install_dotfiles() {
	cd ${SRC_DIR}
	for file in "${FILE_LIST[@]}"
	do
		if [ -f ${file} ]; then
			echo "install ${file}"
			ln -s ${SRC_DIR}/${file} ~/${file}
		else
			echo "no ${file} detected in ${SRC_DIR}"
		fi
	done
}

backup_and_install() {
	backup_dotfiles
	install_dotfiles
}

install_bundle() {
	bundleDir=~/.vim/bundle/Vundle.vim/
	echo "${bundleDir}"
	if [[ ! -d ${bundleDir} ]]; then
		mkdir -p ~/.vim/bundle
		git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	fi	
}

install_linux_package() {
	apt-get -v >/dev/null 2>&1 || { echo "no apt-get found. exit 1" >&2; exit 1; }
	sudo apt-get update
	sudo apt-get install git screen ctags cscope realpath
	install_bundle
}

install_darwin_package() {
	#install homebrew
	brew -v > /dev/null 2>&1 || { \
		echo "install homebrew";\
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";\
	}
	#install realpath
	realpath ~ > /dev/null 2>&1 || {\
		echo "install realpath";\
		brew tap iveney/mocha;\
		brew install realpath;\
	}
	#install git
	git --version > /dev/null 2>&1 || {\
		echo "install git";\
		brew install git;\
	}
	#install bundle
	install_bundle
}

install_for_Linux() {
	install_linux_package
	backup_and_install
}

install_for_darwin() {
	install_darwin_package
	backup_and_install
}

main() {
	 #print_var
	 case ${OS} in
		"Linux")
		install_for_Linux
 		;;
		"Darwin")
		install_for_darwin
 		;;
		*)
		echo "Do not support ${OS} now"
		;;
	esac
}


main
