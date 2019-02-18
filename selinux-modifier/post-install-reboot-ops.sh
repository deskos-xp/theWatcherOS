restorecon -r /
mkdir trash
checkmodule -m -o trash/requiredmod.mod configs/requiredmod.te
semodule_package -o trash/requiredmod.pp -m trash/requiredmod.mod
semodule -i trash/requiredmod.pp

systemctl enable restorecond
rm -r trash
printf 'GRUB_DEFAULT=saved\nGRUB_SAVEDEFAULT="true\n' >> /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
