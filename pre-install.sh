#Installing dialog
sudo pacman --noconfirm -Sy dialog

#options and info
dialog --colors --infobox "\Z5 This is a script to install Arch kinda-automatically" 5 30
sleep 2

dialog --colors --infobox "\Z5 Also please make sure to have partitioned the disks using tools such as cfdisk -tui- or fdisk -commandline- and then edited the script accordingly" 9 30
sleep 2

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
mkfs.ext4 /dev/vda2
mkfs.fat -F 32 /dev/vda1

#mount root and swap 
mount /dev/vda2 /mnt

#install needed packages in new install
pacstrap /mnt base linux linux-firmware linux-headers base-devel vim networkmanager sudo git grub os-prober efibootmgr xdg-user-dirs

#mount efi
mkdir /mnt/boot/efi
mount /dev/vda1 /mnt/boot/efi

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
echo -e "127.0.0.1\tlocalhost" >> /etc/hosts
echo -e "::1\t\tlocalhost" >> /etc/hosts
echo -e "127.0.1.1\t${hosname}" >> /etc/hosts

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

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
sudo sed -e s/quiet//g -i /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

su ${username}
cd
xdg-user-dirs-update

EOF

#chroot exited

#setting up post install
cp post-install.sh /mnt/home/${username}/Documents/

#unmount all partitions
umount -a 
