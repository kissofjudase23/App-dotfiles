#!/bin/bash
# Create Date: 2015/12/02

#include common functions:
source ./script_funcs.sh


depracted_code() {
cd ~
local file_list=("e23_config_symbolic" ".vimrc");
for filename in "${file_list[@]}"
do
    Check_Link_and_Delete $filename
done

LINE='source ~/e23_config_symbolic'
FILE=.bashrc
sed -i "/$LINE/d" $FILE
}

restore_dotfiles() {

	#restore from backup folder
	cd ${BK_DIR}
	for file in "${FILE_LIST[@]}"
	do
		if [ -e ${file} ]; then
			echo "restore ${file}"
			mv ${file} ~/
		else
			echo "no ${file} detected in ${BK_DIR}"
		fi
	done

	rm -rf ${BK_DIR}
}

un_install_dotfiles() {

	cd ~
	for file in "${FILE_LIST[@]}"
	do
		if [ -L ${file} ]; then
			echo "un-install ${file}"
			rm ${file}
		else
			echo "no ${file} detected in ${HOME}"
		fi
	done

}

uninstall_for_linux() {

	un_install_dotfiles
	#restore_dotfiles
}


main() {

	 print_var

	 case ${OS} in
		"Linux")
		uninstall_for_linux
    ;;
		*)
		echo "Do not support ${OS} now"
		;;
	esac

}

main

