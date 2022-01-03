#!/usr/bin/env bash
#-------------------------------------------------------------------------
#   █████╗ ██████╗  ██████╗██╗  ██╗████████╗██╗████████╗██╗   ██╗███████╗
#  ██╔══██╗██╔══██╗██╔════╝██║  ██║╚══██╔══╝██║╚══██╔══╝██║   ██║██╔════╝
#  ███████║██████╔╝██║     ███████║   ██║   ██║   ██║   ██║   ██║███████╗
#  ██╔══██║██╔══██╗██║     ██╔══██║   ██║   ██║   ██║   ██║   ██║╚════██║
#  ██║  ██║██║  ██║╚██████╗██║  ██║   ██║   ██║   ██║   ╚██████╔╝███████║
#  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝   ╚═╝    ╚═════╝ ╚══════╝
#-------------------------------------------------------------------------

echo -e "\nINSTALLING AUR SOFTWARE\n"
# You can solve users running this script as root with this and then doing the same for the next for statement. However I will leave this up to you.

echo "CLONING: YAY"
cd ~
git clone "https://aur.archlinux.org/yay.git"
cd ${HOME}/yay
makepkg -si --noconfirm

touch "$HOME/.cache/zshhistory"
git clone "https://github.com/iNatie/zsh"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/powerlevel10k
ln -s "$HOME/zsh/.zshrc" $HOME/.zshrc

PKGS=(
'qt5-multimedia' # dep for mkvtoolnix
'python-dateutil' # dep
'xvkbd' # dep for passwordsafe
'nodejs-lts-fermium' # dep for jellyfin
'aegisub-git' # subtitle maker
'arduino-git'
'autojump'
'awesome-terminal-fonts'
'atomicparsley'
'brave-bin' # Brave Browser
'ddclient-git' # Dynamic DNS client
'dxvk-bin' # DXVK DirectX to Vulcan
'canon-pixma-ts5055-complete' # Canon printer driver? https://aur.archlinux.org/packages/canon-pixma-ts5055-complete/
'chirp-daily' # Ham Radio programmer
'cnijfilter2' # Canon printer driver? https://aur.archlinux.org/packages/cnijfilter2/, https://wiki.archlinux.org/title/CUPS/Printer-specific_problems#cnijfilter
'congruity' # Logitech Harmony programmer
'corsairpsu-dkms-git'
'eagle6' # CADsoft Eagle 6
'exact-audio-copy'
'ffmpeg-ndi'
'ffmpeg-full'
'ffmpeg-amd-full' 
'ffmpeg-libfdk_aac'
'ffmpeg-cuda'
'ffmpeg-shinobi'
'ffmpeg-obs'
'filebot'
'fritzing'
'github-desktop-bin' # Github Desktop sync
'gpsbabel'
'hamradio-menus' # dep for CHIRP
'jellyfin'
'lightly-git'
'lightlyshaders-git'
'makemkv'
'mangohud' # Gaming FPS Counter
'mangohud-common'
'meshlab'
'morituri-git' # EAC modded
#'mkvtoolnix-git'
'mp3tag'
'nerd-fonts-fira-code'
'nordic-darker-standard-buttons-theme'
'nordic-darker-theme'
'nordic-kde-git'
'nordic-theme'
'noto-fonts-emoji'
'packettracer' # Cisco packet tracer
'papirus-icon-theme'
'passwordsafe'
'picard-git'
'plasma-pa'
'platformio'
'plex-media-player'
'plex-media-server'
'plex-hama-bundle-git'
'plex-ass-scanner-git'
'plex-anilist-bundle-git'
'powerpanel'
'ocs-url' # install packages from websites
'osu' # rythmm game
'rescrobbled-git' # Last.fm
'samsung-ssd-dc-toolkit' # Samsung magician
'samsung_magician-consumer-ssd'
'sddm-nordic-theme-git'
'snapper-gui-git'
'solaar-git' # Logitech unifying drivers
'svxlink-sounds-en_us-heather-16k' # Dep for svxlink
'svxlink' # Echolink
'teamviewer'
'ttf-droid'
'ttf-hack'
'ttf-meslo' # Nerdfont package
'ttf-roboto'
'viking-git'
'youtube-music'
'zoom' # video conferences
'snap-pac'
'zsh-syntax-highlighting'
'zsh-autosuggestions'
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}" | tee -a "${HOME}/yay.txt"
    yay -S --noconfirm $PKG | tee -a "${HOME}/yay.txt"
done

export PATH=$PATH:~/.local/bin
cp -r $HOME/ArchTitus/dotfiles/* $HOME/.config/
pip install konsave
konsave -i $HOME/ArchTitus/kde.knsv
sleep 1
konsave -a kde

echo -e "\nDone!\n"
exit
