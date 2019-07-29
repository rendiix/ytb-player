#!/data/data/com.termux/files/usr/bin/bash
# File       : install.sh
# Author     : rendiix <vanzdobz@gmail.com>
# Create date: 25-Jul-2019 21:46
# install.sh
# Copyright (c) 2019 rendiix <vanzdobz@gmail.com>
#
#      DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#               Version 2, December 2004
#
# Everyone is permitted to copy and distribute verbatim or 
# modified copies of this license document,and changing it
# is allowed as long as the name is changed.
#
#      DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#           TERMS AND CONDITIONS FOR COPYING,
#             DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

TUAN_RUMAH="$(pwd)"	
NO='\033[00m';ME='\033[31m';HI='\033[32m';KU='\033[33m';BI='\033[34m';CY='\033[36m';PU='\033[37m'

function CHECK_DEP() {
	DEP=( bc busybox coreutils curl findutils gnupg jq mpv ncurses ncurses-ui-libs ncurses-utils python sed util-linux wget )
	for i in ${DEP[*]}; do
		status="$(dpkg-query -W --showformat='${Status}\n' $i 2> /dev/null)"
		echo -e "memeriksa ${KU}$i${NO} sudah terinstall...\c"
		if [ "$status"  == "install ok installed" ]; then
			sleep 0.2
			echo -e " ${HI}ya${NO}"
		else
			echo -e " ${ME}tidak${NO}"
			echo -e "memasang...\c" 
			apt-get --yes install $i > /dev/null 2>&1
			if [ "$?" = "0" ]; then
				echo -e " ${HI}selesai${NO}"
			else
				echo -e " ${ME}gagal${NO}"
			fi
		fi
	done
}

function DONE() {
	echo -e "${HI}Instalasi selesai...${NO}
cara menggunakan :

$ ytb \"lagu yang mau dicari\"\n"
}

echo -e "memeriksa update...\c"
apt-get update > /dev/null 2>&1
apt-get upgrade -y > /dev/null 2>&1
if [ "$?" = "0" ]; then
	echo -e " ${HI}ok${NO}"
	CHECK_DEP
else
	echo -e " ${ME}gagal${NO}"
	exit 1
fi
function TYPE_INSTALL() {
	echo -e "\nPilih metode instalasi:\n\t1) default deb (recommended)\n\t2) symlink"
	read -n 1 -p "Jawab:" jawab
	if [ "$jawab" == "2" ]; then
		method=slink
	else
		method=deb
	fi

}

function DEB() {
	echo -e "\nmenginstall custom repo...\c"
	[ ! -d $PREFIX/etc/apt/sources.list.d ] && mkdir $PREFIX/etc/apt/sources.list.d
	if [ ! -f "$PREFIX/etc/apt/sources.list.d/rendiix.list" ]; then
		echo -e "deb https://rendiix.github.io android-tools termux" > $PREFIX/etc/apt/sources.list.d/rendiix.list
		wget https://rendiix.github.io/rendiix.gpg
		apt-key add rendiix.gpg
		apt update -y
		sleep 0.2
		echo -e " ${HI}selesai${NO}"
	else
		sleep 0.2
		echo " repo already installed"

	fi
	if [ "$?" == "0" ]; then
		echo -e "memasang ytb-player...\c"
		apt install -y ytb-player
		DONE
	fi
}

function SYMLINK() {
	echo -e "\nmembuat pintasan ytb-player...\c"
	chmod +x ${TUAN_RUMAH}/src/ytb-player.sh
	ln -sf ${TUAN_RUMAH}/src/ytb-player.sh $PREFIX/bin/ytb
	ln -sf ${TUAN_RUMAH}/src/ytb-player.sh $PREFIX/bin/ytb-player
	sleep 1
	DONE
}

TYPE_INSTALL
case $method in
	deb) DEB;;
	*) SYMLINK;;
esac
