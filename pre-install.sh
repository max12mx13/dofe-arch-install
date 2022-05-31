encryptionpreinstall(){
	passwd=$(dialog --colors --inputbox "\Z5 Enter the encryption password that you want to use" 10 50 \
		3>&1 1>&2 2>&3 3>&-  )
	echo -en "${passwd}" | cryptsetup -v luksFormat $1
	echo -en "${passwd}" | cryptsetup open $1 root
	mkfs.ext4 /dev/mapper/root
}

encryptionpostinstall(){
	sed -i '/HOOKS/s/block/block encrypt keyboard /' /mnt/etc/mkinitcpio.conf	
	deviceuuid=$(blkid $1 | awk -F"[ ',]+" '{print $2}')
	sed -i 'GRUB_CMDLINE_LINUX_DEFAULT=/s/quiet/cryptdevice=${deviceuuid}:root root=/dev/mapper/root' /mnt/etc/default/grub
	arch-chroot /mnt mkinitcpio -P
	arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
}

#Installing dialog
sudo pacman --noconfirm -Sy dialog

#options and info
dialog --colors --infobox "\Z5 This is a script to install Arch kinda-automatically" 5 30
sleep 2

## disks
sdavsvda=$(dialog --menu "Choose where we are installing to" 10 50 10 \
	"sda" "A bare-metal install" \
	"vda" "In a virtual machine" \
	"sdb" "An external drive" 3>&1 1>&2 2>&3 )

dialog --colors --infobox "\Z5 First, lets start partitioning!" 4 30
sleep 4
cfdisk /dev/${sdavsvda}

boot=$(dialog --colors --inputbox "\Z5 Enter the disk identifier for the boot partition (often /dev/${sdavsvda}1)" 10 50 \
	3>&1 1>&2 2>&3 3>&-  )

dialog --colors --yesno "\Z5 Do you want this partition to be formatted?" 6 50
formatboot=$?

root=$(dialog --colors --inputbox "\Z5 Now thats done, enter the disk identifier for the root partition" 10 50 \
	3>&1 1>&2 2>&3 3>&-  )

dialog --colors --yesno "\Z5 Do you want this install to be encrypted?" 6 50
encrypted=$?

if [ $encrypted -eq "0" ]; then
	encryptionpreinstall ${root} 
fi

username=$(dialog --colors --inputbox "\Z5 What do you want your username to be" 10 38\
   3>&1 1>&2 2>&3 3>&-  )

password=$(dialog --colors --inputbox '\Z5 What do you want the password to be for your user' 10 38\
   3>&1 1>&2 2>&3 3>&-  )

rootpassword=$(dialog --colors --inputbox '\Z5 What do you want the password to be for your root user' 10 38\
   3>&1 1>&2 2>&3 3>&-  )

hosname=$(dialog --colors --inputbox '\Z5 What do you want the hostname to be' 10 38\
   3>&1 1>&2 2>&3 3>&-  )

dialog --colors --yesno "\Z5 Do you want to start the install" 8 25
yesorno=$?

case $yesorno in
        0);;
        1) exit 130;;
        255) exit 130;;
esac

sleep 4

#make the file systems
if [ $encrypted -eq "0" ]; then
	mkfs.ext4 /dev/mapper/root
	mount /dev/mapper/root /mnt
else
	mkfs.ext4 ${root}
	mount ${root} /mnt
fi

if [ $formatboot -eq "0" ]; then
	mkfs.fat -F 32 ${boot}
fi

#mount boot
mkdir /mnt/boot
mount ${boot} /mnt/boot

#install needed packages in new install
pacstrap /mnt base linux linux-firmware linux-headers base-devel vim networkmanager sudo git grub os-prober efibootmgr xdg-user-dirs

#generate the fstab 
genfstab -U /mnt >> /mnt/etc/fstab

#all things in chroot (cant add comments in code)
cat << EOF | sudo arch-chroot /mnt 

ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc
sed -i "s/#en_GB/en_GB/g; s/#en_US.UTF-8/en_US.UTF-8/g" /etc/locale.gen
echo "LANG=en_GB.UTF-8" > /etc/locale.conf
locale-gen

echo -e "${hosname}" > /etc/hostname

mkinitcpio -P

systemctl enable NetworkManager 

useradd -m -g users -G wheel,games,power,optical,storage,scanner,lp,audio,video,input,adm,users -s /bin/bash $username

echo -en "${password}\n${password}" | passwd $username
echo -en "${rootpassword}\n${rootpassword}" | passwd

sed -i "s/^# %wheel/%wheel/g" /etc/sudoers
tee -a /etc/sudoers << END
END

mkdir -p /etc/X11/xorg.conf.d && tee <<'END' /etc/X11/xorg.conf.d/90-touchpad.conf 1> /dev/null
Section "InputClass"
        Identifier "touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
        Option "Tapping" "on"
EndSection
END

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

su ${username}
cd
xdg-user-dirs-update

EOF

#chroot exited

if [ $encrypted -eq "0" ]; then
	encryptionpostinstall ${root}
fi

#setting up post install
cp post-install.sh /mnt/home/${username}/Documents/

#unmount all partitions
umount -a 
