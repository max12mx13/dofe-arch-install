# dofe-arch-install
## Description
This is a script that is written for my [DofE](https://www.dofe.org/) skills (coding). There are two scripts, one for install and one for post-install (to configure).

In both scripts options will be presented to the user. In the install script these options are: 
* Username
* password
* root password
* hostname

In the configuration script the user will be asked which themes they want to install and which theme they want enabled by default.

The distro that will be installed is [arch linux](https://archlinux.org/). It is a very minimalistic and customizable distribution of linux which is why I have chosen it for this project.

### Themes
<p align="center">These are the 6 themes available:</p> 
<p align="center">Catppuccin:</p>
<p align="center">

![Catppuccin theme display](assets/catppuccin.png)
</p>


<p align="center">Nordic:</p>
<p align="center">

![Nordic theme display](assets/nordic.png)
</p>


<p align="center">Arc-dark:</p>
<p align="center">

![Arc-dark theme display](assets/arc.png)
</p>


<p align="center">Ant-dracula:</p>
<p align="center">

![Ant-dracula theme display](assets/ant-dracula.png)
</p>


<p align="center">Dracula:</p>
<p align="center"

![Dracula theme display](assets/dracula.png)
</p>


<p align="center">Gruvbox-dark</p>
<p align="center">

![Gruvbox-dark theme display](assets/gruvbox,noshell.png)
</p>

## Warnings
* This is only built to work on a live arch linux USB (in a virtual machine or bare metal)
* This means you should **NOT** attempt to use it on windows or mac-os
## Setting up and executing the scripts
#### This in the live usb
```bash
sudo pacman -Sy git 
git clone https://github.com/max12mx13/dofe-arch-install.git
cd dofe-arch-install
./pre-install.sh
```
#### This once installed
```bash
cd Documents
./post-install.sh
```

## TODO
### Git
- [x] Create nice README.md (what you are reading now)
### Install script
- [x] First bits of the install script (Disks and installing base)
- [x] Finishing install script (other stuff in a chroot)
- [x] Documenting and debugging code
- [x] Testing in a vm and recording
### Theming
- [x] Create TUI for theming options
- [x] Make themes arc,nordic and dracula accessible
- [x] Make themes catppuccin, ant and gruvbox accessible
- [ ] Documenting and debugging code
### Final configuration
- [ ] Installation of other apps, e.g firefox
- [ ] Final testing in vm and recording

## Films of tests
### Install in vm
<img src="assets/untitled.gif" width="200" height="200" />

## Credits
[Ant](https://github.com/EliverLara/Ant)

[Nordic](https://github.com/EliverLara/Nordic)

[Gruvbox](https://github.com/jmattheis/gruvbox-dark-gtk)

[Dracula](https://github.com/dracula/gtk)

[Arc](https://github.com/horst3180/arc-theme)

[Catppuccin](https://github.com/catppuccin/gtk)
