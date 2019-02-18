#!/usr/bin/env bash
#settings will be moved to json
config="zfs-config.json"

disk=()
for d in `jq '.disks' $config | bash stripper.sh` ; do
	disk+=("$d")
done

TYPE="`jq '.type' $config | bash stripper.sh`"
poolName="`jq '.poolName' $config | bash stripper.sh`"
disks=()
path="`jq '.path' $config | bash stripper.sh`"

function mountImage(){
for d in ${disk[@]} ; do
	if test $TYPE == "loop" ; then
		disks+=("/dev/loop""$d")
	else
		disks+=("/dev/""$d")
	fi
	losetup /dev/loop"$d" "$path/zp"$d".img"
done
sudo zpool import "$poolName"
}
mountImage
