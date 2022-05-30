# post-install script

# Functions
gnome() {
	dialog --colors --infobox "\Z5 First, we will install gnome" 4 30
	sleep 2

	# sudo pacman -Syu --noconfirm gnome gnome-tweaks 
	# sudo systemctl enable gdm

	# Enabling shell-themes
	# gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com

	# Preparing themes folder
	# mkdir ~/.config/gtk-4.0/

	# cd /tmp
	if [ $1 = 1 ]; then
		git clone https://aur.archlinux.org/catppuccin-gtk-theme.git
		cd catppuccin-gtk-theme
		makepkg --noconfirm -si
		# cd /tmp
		# git clone https://github.com/catppuccin/gtk.git
		# cp gtk/src/main/gtk-4.0/gtk-dark.css ~/.config/gtk-4.0/gtk.css
		gsettings set org.gnome.desktop.interface gtk-theme "Catppuccin-purple"
		dconf write /org/gnome/shell/extensions/user-theme/name "'Catppuccin-purple'"
	
	elif [ $1 = 2 ]; then
		git clone https://aur.archlinux.org/nordic-theme.git	
		cd nordic-theme
		makepkg --noconfirm -si
		# cd /tmp
		# git clone https://github.com/EliverLara/Nordic.git
		# cp Nordic/gtk-4.0/gtk-dark.css ~/.config/gtk-4.0/gtk.css
		gsettings set org.gnome.desktop.interface gtk-theme "Nordic"
		dconf write /org/gnome/shell/extensions/user-theme/name "'Nordic'"

	elif [ $1 = 3 ]; then
		sudo pacman --noconfirm -Syu arc-gtk-theme
		gsettings set org.gnome.desktop.interface gtk-theme "Arc-Dark"
		dconf write /org/gnome/shell/extensions/user-theme/name "'Arc-Dark'"

	elif [ $1 = 4 ]; then
		git clone https://aur.archlinux.org/ant-gtk-theme.git
		cd ant-gtk-theme
		makepkg --noconfirm -si
		gsettings set org.gnome.desktop.interface gtk-theme "Ant-Dracula"
		dconf write /org/gnome/shell/extensions/user-theme/name "'Ant-Dracula'"

	elif [ $1 = 5 ]; then
		git clone https://aur.archlinux.org/dracula-gtk-theme.git
		cd dracula-gtk-theme
		makepkg --noconfirm -si
		gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
		dconf write /org/gnome/shell/extensions/user-theme/name "'Dracula'"

	elif [ $1 = 6 ]; then
		dialog --colors --infobox "vim" 40 40 
		sleep 10
		git clone https://aur.archlinux.org/gruvbox-material-theme-git.git
		cd gruvbox-material-theme-git
		makepkg --noconfirm -si
		gsettings set org.gnome.desktop.interface gtk-theme "Gruvbox-Material-Dark"
		dconf write /org/gnome/shell/extensions/user-theme/name "'Gruvbox-Material-Dark'"

	fi

}

appsinstall(){
	if [[ *"$1"* =~ "chromium" ]]; then
		sudo pacman --noconfirm -Syu chromium
	fi
	if [[ *"$1"* =~ "firefox" ]]; then
		sudo pacman --noconfirm -Syu firefox
	fi
	if [[ *"$1"* =~ "onlyoffice" ]]; then
		cd /tmp
		git clone https://aur.archlinux.org/onlyoffice-bin.git
		cd onlyoffice-bin
		makepkg --noconfirm -si
	fi
	if [[ *"$1"* =~ "libreoffice" ]]; then
		sudo pacman --noconfirm -Syu libreoffice-still
	fi
	if [[ *"$1"* =~ "lutris" ]]; then
		sudo pacman --noconfirm -Syu lutris
	fi
	if [[ *"$1"* =~ "steam" ]]; then
		sudo pacman --noconfirm -Syu
	fi
	if [[ *"$1"* =~ "vscode" ]]; then
		sudo pacman --noconfirm -Syu code
	fi
	if [[ *"$1"* =~ "atom" ]]; then
		sudo pacman --noconfirm -Syu atom
	fi
	if [[ *"$1"* =~ "cmatrix" ]]; then
		sudo pacman --noconfirm -Syu cmatrix
	fi

}
#Installing dialog
# sudo pacman --noconfirm -Syu dialog

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

dialog --colors --infobox "\Z5 Cancel to skip this step" 3 30
sleep 2

choice=$(dialog --radiolist "Themes" 15 30 6 \
      	"1" "Captpuccin" OFF \
	"2" "Nordic" OFF \
	"3" "Arc-dark" OFF \
	"4" "Ant-dracula" OFF \
	"5" "Dracula" OFF \
	"6" "Gruvbox-dark" OFF \
	3>&1 1>&2 2>&3 3>&- )

exitstatus=$?
if [ $exitstatus = 0 ]; then
	gnome ${choice}
else
	dialog --colors --infobox "\Z5 You chose to cancel." 3 30
	sleep 2
fi

dialog --colors --infobox "\Z5 Lets install some apps!" 4 30
sleep 2

apps=$(dialog --checklist "Apps" 15 50 10\
	"chromium" "Web browser" OFF \
	"firefox" "Web browser" OFF \
	"onlyoffice" "Office suite" OFF \
	"libreoffice" "Office suite" OFF \
	"lutris" "Gaming" OFF \
	"steam" "Gaming" OFF \
	"vscode" "Development" OFF \
	"atom" "Development" OFF \
	"cmatrix" "Misc" OFF 3>&1 1>&2 2>&3 ) 

exitstatus=$?
if [ $exitstatus = 0 ]; then
	appsinstall ${apps}
else
	dialog --colors --infobox "\Z5 You chose to cancel." 3 30
	sleep 2
fi

dialog --colors --infobox "\Z5 Now you should reboot" 4 30
