#! /usr/bin/env bash

function getPkg(){
pkg="`pacman -Q mariadb`"
if test "$pkg" == "" ; then
	pacman -S mariadb
fi
}
function install(){
	states=('start' 'enable')
	mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	for i in ${states[@]}; do
		systemctl start mariadb
	done
	mysql_secure_installation
}
function echo(){
	printf "\033[1;31;40m%s\033[1;40;m" "$1"
}
function main(){
	if test "`whoami`" != "root" ; then
		/usr/bin/echo "user is not `echo root`"
		exit 1
	fi
	getPkg
	install
}
main
