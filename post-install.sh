# post-install script

#Installing dialog
# sudo pacman --noconfirm -Sy dialog

## Root or not

if [[ $(id -u) -eq 0 ]] ; then
	dialog --colors --infobox "\Z5 Please do not run this script as root" 4 30
	sleep 2
	exit 1 
fi

#options and info
dialog --colors --infobox "\Z5 This is the post-install script for my dofe!" 4 30
sleep 2

dialog --colors --infobox "\Z5 It will install a selected theme, please check the github for what they look like" 6 30
sleep 2

choice=$(dialog --radiolist "Themes" 15 30 6 \
      	"1" "Captpuccin" OFF \
	"2" "Nordic" OFF \
	"3" "Arc-dark" OFF \
	"4" "Ant-dracula" OFF \
	"5" "Dracula" OFF \
	"6" "Gruvbox-dark" OFF \
	3>&1 1>&2 2>&3 3>&- )

dialog --colors --infobox "\Z5 First, we will install gnome" 4 30
sleep 2

sudo pacman -Sy --noconfirm gnome gnome-tweaks
sudo systemctl enable gdm

# Enabling shell-themes
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com

# Preparing themes folder
mkdir ~/.config/gtk-4.0/

if [ $choice = 1 ]; then
	cd /tmp 
	git clone https://aur.archlinux.org/catppuccin-gtk-theme.git
	cd catppuccin-gtk-theme
	makepkg --noconfirm -si
	cd /tmp
	git clone https://github.com/catppuccin/gtk.git
	cp gtk/src/main/gtk-4.0/gtk-dark.css ~/.config/gtk-4.0/gtk.css
	gsettings set org.gnome.desktop.interface gtk-theme "Catppuccin-purple"
	dconf write /org/gnome/shell/extensions/user-theme/name "'Catppuccin-purple'"

elif [ $choice = 2 ]; then
	cd /tmp
	git clone https://aur.archlinux.org/nordic-theme.git	
	cd nordic-theme
	makepkg --noconfirm -si
	cd /tmp
	git clone https://github.com/EliverLara/Nordic.git
	cp Nordic/gtk-4.0/gtk-dark.css ~/.config/gtk-4.0/gtk.css
	gsettings set org.gnome.desktop.interface gtk-theme "Nordic"
	dconf write /org/gnome/shell/extensions/user-theme/name "'Nordic'"

elif [ $choice = 3 ]; then
elif [ $choice = 4 ]; then
elif [ $choice = 5 ]; then
elif [ $choice = 6 ]; then
