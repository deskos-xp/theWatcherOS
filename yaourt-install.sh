if [ "$1" == "--verbose-rm" ] ; then
		verbose="-v"
fi

if [ ! -e "/usr/bin/git" ] ; then
	installed=`pacman -Qqe git`
	if [ "$installed" != "git" ] ; then
		sudo pacman -S git
	else
		echo "git is installed already"
	fi
fi


if [ ! -e "build" ] ; then
	mkdir build
else
	echo "build exists... will delete in 5 seconds..."
	sleep 5s
	rm -rf $verbose build
	mkdir build
fi

cd build

installed=`pacman -Qqe yajl`
if [ "$installed" != "yajl" ] ; then
	sudo pacman -S yajl
else
	echo "yajl is installed already"
fi

installed=`pacman -Qq package-query`
if [ "$installed" != "package-query" ] ; then
	git clone https://aur.archlinux.org/package-query.git
	cd package-query
	makepkg
	sudo pacman -U package-query-*.pkg.tar.xz
	cd ..
else
	echo "package-query is installed already"
fi

installed=`pacman -Qqe yaourt`
if [ "$installed" != "yaourt" ]  ; then
	git clone https://aur.archlinux.org/yaourt.git
	cd yaourt
	makepkg
	sudo pacman -U yaourt-*.pkg.tar.xz
	cd ..
else
	echo "yaourt is installed already"
fi

cd ..
echo "Cleaning up..."
rm -rf $verbose build
