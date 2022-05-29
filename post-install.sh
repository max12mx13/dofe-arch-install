# post-install script

#Installing dialog
# sudo pacman --noconfirm -Sy dialog

#options and info
dialog --colors --infobox "\Z5 This is the post-install script for my dofe!" 4 30
sleep 2

dialog --colors --infobox "\Z5 It will install a selected theme, please check the github for what they look like" 6 30
sleep 2

choice=$(dialog --radiolist "Themes" 15 30 6 \
      	"1" "Catpuccin" OFF \
	"2" "Nordic" OFF \
	"3" "Arc-dark" OFF \
	"4" "Ant-dracula" OFF \
	"5" "Dracula" OFF \
	"6" "Gruvbox-dark" OFF \
	3>&1 1>&2 2>&3 3>&- )

## Installing and enabling shell thems
mkdir -p ~/.local/share/gnome-shell/extensions 
cp -r user-theme@gnome-shell-extensions.gcampax.github.com ~/.local/share/gnome-shell/extensions


if [ $choice = 1 ]; then
	
elif [ $choice = 2 ]; then
	echo who
elif [ $choice = 3 ]; then
elif [ $choice = 4 ]; then
elif [ $choice = 5 ]; then
elif [ $choice = 6 ]; then
