config="zfs-config.json"
label="starter"
path="`jq '.path' $config | bash stripper.sh`"
file="
[Unit]
Description=setup loop device images for ZFS
Before=zfs.target

[Service]
Type=simple
ExecStart=/bin/sh $path/setup_loop_boot.sh

[Install]
WantedBy=multi-user.target"


echo -e "$file" > loopDisks.service

