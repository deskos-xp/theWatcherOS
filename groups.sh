function appendGroups(){
users=('container')
groups=('sudo' 'audio' 'input' 'lp' 'video' 'optical' 'disk' 'http' 'network' 'video' 'storage' 'scanner' 'power' 'users' 'vboxusers' 'wireshark' 'transmission' 'voice' 'sdkusers')
	for user in ${users[@]} ; do
		for group in ${groups[@]} ; do
			usermod -a -G $group $user
		done
	done
}
appendGroups
