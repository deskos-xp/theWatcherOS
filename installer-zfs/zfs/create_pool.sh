#settings will be moved to json
config="zfs-config.json"
disk=()
for d in `jq '.disks' $config | bash stripper.sh` ; do
	disk+=("$d")
done
TYPE="`jq '.type' $config | bash stripper.sh`"
ptuuid=""
mountPoint="`jq '.mountPoint' $config | bash stripper.sh`"
poolName="`jq '.poolName' $config | bash stripper.sh`"
raidT="`jq '.raidT' $config | bash stripper.sh`"
disks=()
path="`jq '.path' $config | bash stripper.sh`"
size="`jq '.disk_size' $config | bash stripper.sh`"
/sbin/modprobe zfs
function mkImage(){
for d in ${disk[@]} ; do
	if test "$TYPE" == "loop" ; then
		fallocate -l $size zp"$d".img
		losetup /dev/loop"$d" "$path"/zp"$d".img
	fi

	if test $TYPE == "loop" ; then
		disks+=("/dev/loop""$d")
		sudo gdisk /dev/loop"$d" <<< `echo -e 'w\nY'`
	else
		disks+=("/dev/""$d")
		sudo gdisk /dev/"$d" <<< `echo -e 'w\nY'`
	fi
	ptuuid="$ptuuid"" ""`blkid | grep -w "/dev/loop$d:" | cut -f2 -d'"' | cut -f1 -d'"'`"
done
}

function detachImage(){
if test "$TYPE" == "loop" ; then
	for d in ${disk[@]} ; do
		losetup -d /dev/loop"$d"

	done
fi
}

function checks(){
	if test ! -e "$mountPoint" ; then
		mkdir "$mountPoint"
	fi
}

function destroy_zpool(){
	if test "$(zpool list "$poolName" | grep -w "$poolName")" != "" ; then
		zpool destroy -f "$poolName"
	fi
}

function create_zpool(){
	checks
	if test "$raidT" == "skip" ; then
		zpool create -f -m "$mountPoint" "$poolName" ${disks[@]}
	else
		zpool create -f -m "$mountPoint" "$poolName" "$raidT" ${disks[@]}
	fi
}

function unmount_zpool(){
	zfs unmount "$mountPoint"
}
unmount_zpool
destroy_zpool
detachImage
mkImage
echo $ptuuid
create_zpool
bash ./set_permissions.sh

zpool export "$poolName"
detachImage
