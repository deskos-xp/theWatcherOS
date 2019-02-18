function main(){
	if test "$1" == "start" ; then
		modprobe zfs
		zpool set cachefile=/etc/zfs/zpool.cache starter
		systemctl enable zfs.target
		systemctl start zfs.target
	elif test "$1" == "stop" ; then
		systemctl disable zfs.target
		systemctl stop zfs.target
	else
		echo "invalid mode"
	fi
}
main $@
