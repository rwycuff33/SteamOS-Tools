#!/bin/bash

# -------------------------------------------------------------------------------
# Author:    	Michael DeGuzis
# Git:	    	https://github.com/ProfessorKaos64/SteamOS-Tools
# Scipt Name:	build-deb-from-PPA.sh
# Script Ver:	0.1.1
# Description:	Attempts to build a deb package from a PPA
#
# Usage:	sudo ./build-deb-from-PPA.sh
#		source ./build-deb-from-PPA.sh
# -------------------------------------------------------------------------------

arg="$1"

show_help()
{
	clear
	cat <<-EOF
	####################################################
	Usage:	
	####################################################
	./build-deb-from-PPA.sh
	./build-deb-from-PPA.sh --help
	source ./build-deb-from-PPA.sh
	
	The third option, preeceded by 'source' will 
	execute the script in the context of the calling 
	shell and preserve vars for the next run.
	
	EOF
}

if [[ "$arg" == "--help" ]]; then
	#show help
	show_help
	exit
fi

install_prereqs()
{
	clear
	echo -e "\n==>Installing pre-requisites for building...\n"
	sleep 1s
	# install needed packages
	apt-get install devscripts build-essential

}

main()
{
	build_dir="/home/desktop/build-deb-temp"
	
	clear
	# remove previous dirs if they exist
	if [[ -d "$build_dir" ]]; then
		rm -rf "$build_dir"
	fi
	
	# create build dir and enter it
	mkdir -p "$build_dir"
	cd "$build_dir"
	
	# Ask user for repos / vars
	echo -e "Please enter or paste the repo src URL now:"
	
	# set tmp var for last run, if exists
	repo_src_tmp="$repo_src"
	if [[ "$repo_src" == "" ]]; then
		# var blank this run, get input
		read repo_src
	else
		read epo_src
		# user chose to keep var value from last
		if [[ "$repo_src" == "" ]]; then
			user="$repo_src_tmp"
		else
			# keep user choice
			repo_src="$repo_src"
		fi
	fi
	
	echo -e "\nPlease enter or paste the GPG key for this repo now:"
	gpg_pub_key_tmp="$gpg_pub_key"
	if [[ "$gpg_pub_key" == "" ]]; then
		# var blank this run, get input
		read gpg_pub_key
	else
		read gpg_pub_key
		# user chose to keep var value from last
		if [[ "$gpg_pub_key" == "" ]]; then
			gpg_pub_key="$gpg_pub_key_tmp"
		else
			# keep user choice
			gpg_pub_keyst="$gpg_pub_key"
		fi
	fi
	
	echo -e "\nPlease enter or paste the desired package name now:"
	target_tmp="$target"
	if [[ "$target" == "" ]]; then
		# var blank this run, get input
		read target
	else
		read target
		# user chose to keep var value from last
		if [[ "$target" == "" ]]; then
			target="$target_tmp"
		else
			# keep user choice
			target="$target"
		fi
	fi
	
	# prechecks
	echo -e "\n==>Attempting to add source list\n"
	sleep 2s
	
	# check for existance of target, backup if it exists
	if [[ -f /etc/apt/sources.list.d/${target}.list ]]; then
		sudo mv "/etc/apt/sources.list.d/${target}.list" "/etc/apt/sources.list.d/${target}.list.bak"
	fi
	
	# add source to sources.list.d/
	echo ${repo_src} > "${target}.list.tmp"
	sudo mv "${target}.list.tmp" "/etc/apt/sources.list.d/${target}.list"
	
	echo -e "\n==>Adding GPG key:\n"
	sleep 2s
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ${gpg_pub_key}
	
	echo -e "\n==>Updating system package listings...\n"
	sleep 2s
	sudo apt-get update
	
	#Attempt to build target
	echo -e "\n==>Attemption to build ${target}:\n"
	sleep 2s
	sudo apt-get source --build ${target}
	
	# assign value to build folder for exit warning below
	build_folder=$(ls -l | grep "^d" | cut -d ' ' -f12)
	
	# back out of build temp
	cd
	
	# inform user of packages
	echo -e "\n###################################################################"
	echo -e "If package was built without errors you will see it below."
	echo -e "If you do not, please check build dependcy errors listed above."
	echo -e "You could also try manually building outside of this script with"
	echo -e "the following commands (at your own risk!)\n"
	echo -e "cd $build_dir"
	echo -e "cd $build_folder"
	echo -e "sudo dpkg-buildpackage -b -d -uc"
	echo -e "###################################################################\n"
	
	ls "/home/desktop/build-deb-temp" | grep ${target}*.deb
}

# start main
main
