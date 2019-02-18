#! /usr/bin/env bash
#NoGuiLinux
cmd='yaourt'
function manualBuild(){
	#handle getting dependencies
        #need to get a complete list dependencies
	#install dependencies
        yaourt -G $i 
	cd $i 
        read -rp "edit pkgbuild [y/n]" ans
	if test $ans == "y" ; then
        	vim PKGBUILD
	fi      
        makepkg --skippgpcheck --skipinteg
	if test $? -eq 0 ; then
        	sudo pacman -U $i*.pkg.tar.xz 
	        cd .. 
                rm -r $i 
        fi
}
$cmd -S yay
cmd='yay'
for i in `cat aur.txt` ; do 
        installed=`pacman -Qq $i`
        if test "$i" != "$installed" ; then
		inLog="`fgrep -w "$i" fail.txt`"
		if test "$inLog" == "" ; then
	                $cmd -S $i |& tee action_log.txt
        	        if test $? != 0 ; then 
 			read -rp "build manually?[y/n]:" ans
        			if test "$ans" == "y" ; then
					echo $i >> fail.txt
	               			manualBuild
				else
					echo $i >> fail.txt
				fi
			fi
		fi
        fi
done
