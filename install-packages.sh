#! /usr/bin/env bash
#NoGuiLinux
pacman-key --init
pacman-key --populate archlinux
if test `whoami` == "root" ; then
	#python3 whichIsIt.py > installed.txt
	grep "OFFICIAL" installed.txt | cut -f1 -d: > official.txt

	#make container
	#mkdir
	pacstrap -C ./etc/pacman.conf -i /mnt base base-devel $(cat official.txt)
	if test $? != 0 ; then 
		exit 1
	fi	
	grep "AUR" installed.txt | cut -f1 -d: > aur.txt

	cp -r groups.sh xfce4-migrate arch-linux-config.sh aur.txt yaourt-install.sh install-aur.sh containerlogin.sh rootlogin.sh install-mysql.sh /mnt/root/
	cp -r etc/* /mnt/etc
	cp -r usr/* /mnt/usr
	genfstab /mnt > /mnt/etc/fstab
	#boot container
	#systemd-nspawn -b -D container
	arch-chroot /mnt
	#log in to root
	#run rootlogin.sh
	##run containerlogin.sh
else
	printf "user '%s' is not 'root'" `whoami`
fi
