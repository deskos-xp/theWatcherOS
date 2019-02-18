bash install-aur.sh aur.txt
states=('enable' 'start')
for i in ${states[@]} ; do
	systemctl --user "$i" pulseaudio
done
