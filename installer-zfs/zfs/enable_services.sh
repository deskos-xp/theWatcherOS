#! /usr/bin/env bash
function main(){
config='zfs-config.json'
mode="$1"
ops=('enable' 'disable')
failCount=0
#'zfs-import-cache'

#services=('zfs-mount' 'zfs-import.target' 'zfs.target' 'loopDisks.service' 'starter_z.service')
services=()
for s in `jq '.services' $config | bash stripper.sh` ; do
	services+=("$s")
done

#service_files=('loopDisks.service' 'starter_z.service')
service_files=()
for s in `jq '.service_files' $config | bash stripper.sh` ; do
	service_files+=("$s")
done

mods=()
for m in `jq '.mods' $config | bash stripper.sh` ; do
	mods+=("$m")
done

bash gen_service.sh

if test "$mode" == "disable" ; then
	#remove service file
	for file in ${service_files[@]} ; do
		rm /etc/systemd/system/"$file"
	done
	for file in ${mods[@]} ; do
		rm /etc/modules-load.d/"$file"
	done
elif test "$mode" == "enable" ; then
	#add service file
	for file in ${service_files[@]} ; do
		cp "$file" /etc/systemd/system/
	done

	for file in ${mods[@]} ; do
		cp $file /etc/modules-load.d/
	done
fi

for op in ${ops[@]} ; do
	if test "$mode" == "$op" ; then
		for serv in ${services[@]} ; do
			systemctl "$op" "$serv"
			if test "$?" != "0" ; then
				failCount=`expr $failCount + 1`
			fi	
		done
	else
		failCount=`expr $failCount + 1`
	fi
done


#fail checks
echo $failCount
if test $failCount -ge ${#ops[@]} ; then
       echo "no operation was performed: multiple failures have occured!"
else
	echo "$mode has completed!"
fi
}
main $@
