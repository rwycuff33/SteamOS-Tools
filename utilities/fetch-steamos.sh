#!/bin/bash

# -------------------------------------------------------------------------------
# Author:    	  	Michael DeGuzis
# Git:			      https://github.com/ProfessorKaos64/SteamOS-Tools
# Scipt Name:	  	fetch-steamos.sh
# Script Ver:		  0.1.1
# Description:		Fetch latest Alchemist and Brewmaster SteamOS release files
#                 to specified directory and run SHA512 checks against them.
#
# Usage:      		./fetch-steamos.sh
# -------------------------------------------------------------------------------

a_download_dir="/home/$USER/downloads/alchemist"
b_download_dir="/home/$USER/downloads/brewmaster"

clear

#####################
# directories
#####################

# check fo existance of dirs

if [[ ! -d $"a_download_dir" ]]; then
  mkdir -p "$a_download_dir"
fi

if [[ ! -d $"b_download_dir" ]]; then
  mkdir -p "$b_download_dir"
fi

#####################
# alchemist
#####################

if [[ -f "$a_download_dir/SteamOS.DVD.iso" || -f "$a_download_dir/SteamOSInstaller.zip" ]]; then
  echo -e "Alchemist release installers found, overwrite?"
else
  echo -e "not found"
fi

# Download only on user confirmation

echo -e "==> Fetching Alchemist"