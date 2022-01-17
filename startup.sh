#!/usr/bin/env bash
# This script will ask users about their prefrences 
# like disk, file system, timezone, keyboard layout,
# user name, password, etc.

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# set up a config file
CONFIG_FILE=$SCRIPT_DIR/setup.conf
if [ ! -f $CONFIG_FILE ]; then # check if file exists
    touch -f $CONFIG_FILE # create file if not exists
fi

# set options in setup.conf
set_option() {
    if grep -Eq "^${1}.*" $CONFIG_FILE; then # check if option exists
        sed -i -e "/^${1}.*/d" $CONFIG_FILE # delete option if exists
    fi
    echo "${1}=${2}" >>$CONFIG_FILE # add option
}
logo () {
# This will be shown on every set as user is progressing
echo -ne "
-------------------------------------------------------------------------
 █████╗ ██████╗  ██████╗██╗  ██╗████████╗██╗████████╗██╗   ██╗███████╗
██╔══██╗██╔══██╗██╔════╝██║  ██║╚══██╔══╝██║╚══██╔══╝██║   ██║██╔════╝
███████║██████╔╝██║     ███████║   ██║   ██║   ██║   ██║   ██║███████╗
██╔══██║██╔══██╗██║     ██╔══██║   ██║   ██║   ██║   ██║   ██║╚════██║
██║  ██║██║  ██║╚██████╗██║  ██║   ██║   ██║   ██║   ╚██████╔╝███████║
╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝   ╚═╝    ╚═════╝ ╚══════╝
------------------------------------------------------------------------
            Please select presetup settings for your system              
------------------------------------------------------------------------
"
}
filesystem () {
# This function will handle file systems. At this movement we are handling only
# btrfs and ext4. Others will be added in future.
echo -ne "
    Please Select your file system for both boot and root
    1)      btrfs
    2)      ext4
    3)      luks with btrfs
    0)      exit
"
read FS
case $FS in
1) set_option FS btrfs;;
2) set_option FS ext4;;
3) 
while true; do
  echo -ne "Please enter your luks password: \n"
  read -s luks_password # read password without echo

  echo -ne "Please repeat your luks password: \n"
  read -s luks_password2 # read password without echo

  if [ "$luks_password" = "$luks_password2" ]; then
    set_option LUKS_PASSWORD $luks_password
    set_option FS luks
    break
  else
    echo -e "\nPasswords do not match. Please try again. \n"
  fi
done
;;
0) exit ;;
*) echo "Wrong option please select again"; filesystem;;
esac
}
timezone () {
# Added this from arch wiki https://wiki.archlinux.org/title/System_time
time_zone="$(curl --fail https://ipapi.co/timezone)"
echo -ne "System detected your timezone to be '$time_zone' \n"
echo -ne "Is this correct? yes/no:" 
read answer
case $answer in
    y|Y|yes|Yes|YES)
    set_option TIMEZONE $time_zone;;
    n|N|no|NO|No)
    echo "Please enter your desired timezone e.g. Europe/London :" 
    read new_timezone
    set_option TIMEZONE $new_timezone;;
    *) echo "Wrong option. Try again";timezone;;
esac
}
keymap () {
# These are default key maps as presented in official arch repo archinstall
options=(by ca cf cz de dk es et fa fi fr gr hu il it lt lv mk nl no pl ro ru sg ua uk us)
PS3="
Please select key board layout from this list

"
select keymap in "${options[@]}"
do
# check if selection is part of list, silence error output and use else block for output
if echo -e '%s\n' "${options[@]}" | grep -Fqw $keymap 2> /dev/null; then
    echo -e "\nYour key boards layout: ${keymap} \n"
    set_option KEYMAP $keymap
    break
else
    echo -e "\nInvalid selection, please try again. \n"
fi

done
}

drivessd () {
echo -ne "
Is this an ssd? yes/no:
"
read ssd_drive

case $ssd_drive in
    y|Y|yes|Yes|YES)
    set_option MOUNT_OPTIONS "noatime,compress=zstd,ssd,commit=120";;
    n|N|no|NO|No)
    set_option MOUNT_OPTIONS "noatime,compress=zstd,commit=120";;
    *) echo "Wrong option. Try again";drivessd;;
esac
}

# selection for disk type
diskpart () {
echo -ne "
------------------------------------------------------------------------
    THIS WILL FORMAT AND DELETE ALL DATA ON THE DISK             
    Please make sure you know what you are doing because         
    after formating your disk there is no way to get data back      
------------------------------------------------------------------------

"

PS3='
Select the disk to install on: '
options=($(lsblk -n --output TYPE,KNAME,SIZE | awk '$1=="disk"{print "/dev/"$2"|"$3}'))
select disk in "${options[@]}"
do

# check if selection is part of list, silence error output and use else block for output
if echo -e '%s\n' "${options[@]}" | grep -Fqw ${disk} 2> /dev/null; then
    echo -e "\n${disk%|*} selected \n"
    set_option DISK ${disk%|*}
    break
else
    echo -e "\nInvalid selection, please try again. \n"
fi

done

drivessd
}
userinfo () {
read -p "Please enter your username: " username
set_option USERNAME ${username,,} # convert to lower case as in issue #109 
while true; do
  echo -ne "Please enter your password: \n"
  read -s password # read password without echo

  echo -ne "Please repeat your password: \n"
  read -s password2 # read password without echo

  if [ "$password" = "$password2" ]; then
    set_option PASSWORD $password
    break
  else
    echo -e "\nPasswords do not match. Please try again. \n"
  fi
done
read -rep "Please enter your hostname: " nameofmachine
set_option nameofmachine $nameofmachine
}
# More features in future
# language (){}

# Starting functions
clear
logo
userinfo
clear
logo
diskpart
clear
logo
filesystem
clear
logo
timezone
clear
logo
keymap