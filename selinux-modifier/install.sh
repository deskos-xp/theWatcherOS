#! /usr/bin/env bash
#get system ready for selinux
PKGS='configs/packages.txt'

for pkg in `cat ./$PKGS` ; do
	if test "`pacman -Qq $pkg`" == '' ; then
		yaourt -S $pkg
		if test $? ! -eq 0 ; then
			printf "install failed while installing $pkg\n"
			echo "failed to install # $pkg" >> fail-log
			exit 1
		fi
	else
		echo "$pkg skipped as already installed"
	fi
done

if test "`pacman -Qq sudo-selinux`" == ""; then
	sudo cp /etc/sudoers /etc/sudoers.bak
	yaourt -S sudo-selinux
	su -c "cp /etc/sudoers.bak /etc/sudoers" root
fi

yaourt -G systemd-selinux
cd systemd-selinux
makepkg
sudo pacman -U systemd-selinux-*.pkg.tar.xz --force
cd ..
rm -rf systemd-selinux

yaourt -G libsystemd-selinux
cd libsystemd-selinux
makepkg
sudo pacman -U libsystemd-selinux-*.pkg.tar.xz --force
cd ..
rm -rf libsystemd-selinux

yaourt -G util-linux-selinux
cd util-linux-selinux
makepkg
sudo pacman -U util-linux-selinux-??????-x86_64.pkg.tar.xz
cd ..
rm -rf util-linux-selinux

yaourt -S systemd-selinux
yaourt -S dbus-selinux
yaourt -S selinux-alpm-hook

yaourt -S linux-selinux
yaourt -S linux-hardened
yaourt -S selinux-refpolicy-arch

grub_cmd='GRUB_CMDLINE_LINUX_DEFAULT="quiet"'
grub_cmd_fix=`echo "$grub_cmd" | sed s/'"$'/''/g`
grub_cmd_new=$grub_cmd_fix" security=selinux selinux=1\""
sudo cp /etc/default/grub /etc/default/grub.bak
sudo sed -i s/"$grub_cmd"/"$grub_cmd_new"/g /etc/default/grub

sudo grub-mkconfig -o /boot/grub/grub.cfg

sudo cp configs/selinux-config /etc/selinux/config

