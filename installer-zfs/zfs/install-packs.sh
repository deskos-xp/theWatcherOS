packs=('zfs-dkms')
installer=('yay -S')

for cmd in ${installer[@]} ; do
	for pack in ${packs[@]} ; do
		$cmd $pack
	done
done
