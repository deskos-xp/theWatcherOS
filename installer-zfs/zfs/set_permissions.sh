config="zfs-config.json"
zmount="`jq '.mountPoint' $config | bash stripper.sh`"
USER="`jq '.user' $config | bash stripper.sh`"
GROUP="`jq '.group' $config | bash stripper.sh`"
PERM="`jq '.permission' $config | bash stripper.sh`"
echo "$USER:$GROUP"
chown -R $USER:$GROUP "$zmount"
su -c "chmod 0700 -R $zmount" $USER
