#!/usr/bin/env bash
path="/home/carl/devel/zfs"
config="$path""/zfs-config.json"
disk=()
for d in `jq '.disks' $config | bash $path/stripper.sh` ; do
	disk+=("$d")
done

TYPE="`jq '.type' $config | bash $path/stripper.sh`"
poolName="`jq '.poolName' $config | bash $path/stripper.sh`"
disks=()
path="`jq '.path' $config | bash $path/stripper.sh`"

function setupLoopBoot(){
for d in ${disk[@]} ; do
	if test $TYPE == "loop" ; then
		disks+=("/dev/loop""$d")
	else
		disks+=("/dev/""$d")
	fi
	losetup /dev/loop"$d" "$path/zp"$d".img"
done
printf "\033[1;32;40mloops are setup!\033[1;40;m\n"
#sudo zpool import "$poolName"
}
/sbin/modprobe zfs
setupLoopBoot
