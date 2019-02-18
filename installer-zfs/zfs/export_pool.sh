#! /usr/bin/env bash
config="zfs-config.json"

disk=()
for d in `jq '.disks' $config | bash stripper.sh` ; do
	disk+=("$d")
done

TYPE="`jq '.type' $config | bash stripper.sh`"
poolName="`jq '.poolName' $config | bash stripper.sh`"
disks=()
path="`jq '.path' $config | bash stripper.sh`"

function export_zpool(){
	if test "$(zpool list "$poolName" | grep -w "$poolName")" != "" ; then
		zpool export "$poolName"
		for dev in ${disk[@]} ; do
			if test "$TYPE" == "loop" ; then
				losetup	-d /dev/loop"$dev"
			fi
		done
	else
		echo "no pool by that name! [$poolName]"
	fi
}
export_zpool
