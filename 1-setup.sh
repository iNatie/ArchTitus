#!/usr/bin/env bash
#-------------------------------------------------------------------------
#   █████╗ ██████╗  ██████╗██╗  ██╗████████╗██╗████████╗██╗   ██╗███████╗
#  ██╔══██╗██╔══██╗██╔════╝██║  ██║╚══██╔══╝██║╚══██╔══╝██║   ██║██╔════╝
#  ███████║██████╔╝██║     ███████║   ██║   ██║   ██║   ██║   ██║███████╗
#  ██╔══██║██╔══██╗██║     ██╔══██║   ██║   ██║   ██║   ██║   ██║╚════██║
#  ██║  ██║██║  ██║╚██████╗██║  ██║   ██║   ██║   ██║   ╚██████╔╝███████║
#  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝   ╚═╝    ╚═════╝ ╚══════╝
#-------------------------------------------------------------------------
echo "--------------------------------------"
echo "--          Network Setup           --"
echo "--------------------------------------"
pacman -S networkmanager dhclient --noconfirm --needed
systemctl enable --now NetworkManager
echo "-------------------------------------------------"
echo "Setting up mirrors for optimal download          "
echo "-------------------------------------------------"
pacman -S --noconfirm pacman-contrib curl
pacman -S --noconfirm reflector rsync
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

nc=$(grep -c ^processor /proc/cpuinfo)
echo "You have " $nc" cores."
echo "-------------------------------------------------"
echo "Changing the makeflags for "$nc" cores."
TOTALMEM=$(cat /proc/meminfo | grep -i 'memtotal' | grep -o '[[:digit:]]*')
if [[  $TOTALMEM -gt 8000000 ]]; then
sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$nc\"/g" /etc/makepkg.conf
echo "Changing the compression settings for "$nc" cores."
sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g" /etc/makepkg.conf
fi
echo "-------------------------------------------------"
echo "       Setup Language to US and set locale       "
echo "-------------------------------------------------"
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
timedatectl --no-ask-password set-timezone America/New_York
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_TIME="en_US.UTF-8"

# Set keymaps
localectl --no-ask-password set-keymap us

# Add sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

# Add parallel downloading
sed -i 's/^#Para/Para/' /etc/pacman.conf

# Enable multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Sy --noconfirm

echo -e "\nInstalling Base System\n"

PKGS=(
'mesa' # Essential Xorg First
'xorg'
'xorg-server'
'xorg-apps'
'xorg-drivers'
'xorg-xkill'
'xorg-xinit'
'xterm'
'plasma-desktop' # KDE Load second
'alsa-plugins' # audio plugins
'alsa-utils' # audio utils
'ark' # compression
'abcde' # CD ripper
'audiocd-kio' 
'arduino-avr-core'
'arduino-builder'
'arduino-cli'
'arduino-docs'
'arduino'
'audacity'
'autoconf' # build
'automake' # build
'base'
'bash-completion'
'bind'
'binutils'
'bison'
'bluedevil'
'bluez'
'bluez-libs'
'bluez-utils'
'breeze'
'breeze-gtk'
'bridge-utils'
'btrfs-progs'
'celluloid' # video players
'chromium'
'cmatrix'
'code' # Visual Studio code
'cronie'
'cups'
'cura'
'curl'
'deja-dup'
'deluge'
'dialog'
'discord'
'discover'
'dolphin'
'dosfstools'
'dtc'
'efibootmgr' # EFI boot
'egl-wayland'
'exfat-utils'
'extra-cmake-modules'
'ffmpeg'
'filelight'
'filezilla'
'firefox'
'flex'
'fuse2'
'fuse3'
'fuseiso'
'gamemode'
'gcc'
'gimp' # Photo editing
'git'
'gparted' # partition management
'gptfdisk'
'gpsbabel'
'grub'
'grub-customizer'
'gst-libav'
'gst-plugins-good'
'gst-plugins-ugly'
'gwenview'
'handbrake'
'haveged'
'htop'
'iptables-nft'
'jdk-openjdk' # Java 17
'kate'
'kcodecs'
'kcoreaddons'
'kdeplasma-addons'
'kde-gtk-config'
'kid3'
'kinfocenter'
'kscreen'
'kvantum-qt5'
'kitty'
'konsole'
'kscreen'
'lame'
'layer-shell-qt'
'libdvdcss'
'libnewt'
'libtool'
'linux'
'linux-firmware'
'linux-headers'
'lsof'
'lutris'
'lzop'
'm4'
'make'
'milou'
'mkvtoolnix-gui'
'mkvtoolnix-cli'
'mp3info'
'mysql-workbench'
'nano'
'nautilus'
'neofetch'
'networkmanager'
'ntfs-3g'
'ntp'
'obs-studio'
'okular'
'openbsd-netcat'
'openssh'
'os-prober'
'oxygen'
'p7zip'
'pacman-contrib'
'patch'
'picard'
'picom'
'pkgconf'
'plasma-meta'
'plasma-nm'
'powerdevil'
'powerline-fonts'
'print-manager'
'pulseaudio'
'pulseaudio-alsa'
'pulseaudio-bluetooth'
'python-notify2'
'python-psutil'
'python-pyqt5'
'python-pip'
'qemu'
'rsync'
'sddm'
'sddm-kcm'
'snapper'
'spectacle'
'steam'
'sudo'
'swtpm'
'synergy'
'systemsettings'
'terminus-font'
'traceroute'
'ufw'
'unrar'
'unzip'
'usbutils'
'vim'
'virt-manager'
'virt-viewer'
'vlc'
'wget'
'which'
'wine-gecko'
'wine-mono'
'winetricks'
'wireshark-cli'
'wireshark-qt'
'xdg-desktop-portal-kde'
'xdg-user-dirs'
'yt-dlp'
'yubico-pam'
'yubikey-manager-qt'
'yubikey-manager'
'yubikey-personalization-gui'
'yubikey-touch-detecter'
'yubikey-personalization'
'zeroconf-ioslave'
'zip'
'zsh'
'zsh-syntax-highlighting'
'zsh-autosuggestions'
'wine-staging' # deps for Proton
'winetricks'
'giflib'
'lib32-giflib'
'libpng'
'lib32-libpng'
'libldap'
'lib32-libldap'
'gnutls'
'lib32-gnutls'
'mpg123'
'lib32-mpg123'
'openal'
'lib32-openal'
'v4l-utils'
'lib32-v4l-utils'
'libpulse'
'lib32-libpulse'
'alsa-plugins'
'lib32-alsa-plugins'
'alsa-lib'
'lib32-alsa-lib'
'libjpeg-turbo'
'lib32-libjpeg-turbo'
'libxcomposite'
'lib32-libxcomposite'
'libxinerama'
'lib32-libxinerama'
'ncurses'
'lib32-ncurses'
'opencl-icd-loader'
'lib32-opencl-icd-loader'
'libxslt'
'lib32-libxslt'
'libva'
'lib32-libva'
'gtk3'
'lib32-gtk3'
'gst-plugins-base-libs'
'lib32-gst-plugins-base-libs'
'vulkan-icd-loader'
'lib32-vulkan-icd-loader'
'cups'
'samba'
'dosbox' # End Proton deps
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}" | tee -a pacman.txt
    sudo pacman -S "$PKG" --noconfirm --needed | tee -a pacman.txt
done
steam

#
# determine processor type and install microcode
# 
proc_type=$(lscpu | awk '/Vendor ID:/ {print $3}')
case "$proc_type" in
	GenuineIntel)
		print "Installing Intel microcode"
		pacman -S --noconfirm intel-ucode
		proc_ucode=intel-ucode.img
		;;
	AuthenticAMD)
		print "Installing AMD microcode"
		pacman -S --noconfirm amd-ucode
		proc_ucode=amd-ucode.img
		;;
esac	

# Graphics Drivers find and install
if lspci | grep -E "NVIDIA|GeForce"; then
    pacman -S nvidia nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader nvidia-uvm nvidia-modprobe nvidia-dkms --noconfirm --needed
	nvidia-xconfig
elif lspci | grep -E "Radeon"; then
    pacman -S xf86-video-amdgpu lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader --noconfirm --needed
elif lspci | grep -E "Integrated Graphics Controller"; then
    pacman -S lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils --needed --noconfirm
fi

echo -e "\nDone!\n"
if ! source install.conf; then
	read -p "Please enter username:" username

# Make username lowercase
username=${username,,}

echo "username=$username" >> ${HOME}/ArchTitus/install.conf
fi
if [ $(whoami) = "root"  ];
then
    useradd -m -G wheel,libvirt -s /bin/bash $username 
	passwd $username
	cp -R /root/ArchTitus /home/$username/
    chown -R $username: /home/$username/ArchTitus
	read -p "Please name your machine:" nameofmachine
	echo $nameofmachine > /etc/hostname
else
	echo "You are already a user proceed with aur installs"
fi

