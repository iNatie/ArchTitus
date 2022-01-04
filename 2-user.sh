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

# Install Snap
echo "CLONING: SNAP & INSTALLING: SPOTIFY"
cd ~
git clone "https://aur.archlinux.org/snapd.git"
cd ${HOME}/snapd
sleep 5
makepkg -si --noconfirm
sleep 5
cd ~

echo -e "# Final snapd setup and Install Spotify\n" >> "$HOME/final-setup.sh"
echo -e "sudo systemctl enable --now snapd.socket\n" >> "$HOME/final-setup.sh"
echo -e "sudo systemctl daemon-reload\n" >> "$HOME/final-setup.sh"
echo -e "sudo systemctl restart snapd.seeded.service\n" >> "$HOME/final-setup.sh"
echo -e "sudo snap install spotify\n\n" >> "$HOME/final-setup.sh"

echo -e "# Proton install\n" >> "$HOME/final-setup.sh"
echo -e "steam\n" >> "$HOME/final-setup.sh"
echo -e 'DOWNLOAD_URL=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest \
        | grep browser_download_url \
        | grep Proton \
        | grep tar.gz \
        | cut -d ''"'' -f 4)\n' >> "$HOME/final-setup.sh"
echo -e 'DOWNLOAD_FILE=$(echo "$DOWNLOAD_URL" | rev | cut -d ''/'' -f1 | rev)\n' >> "$HOME/final-setup.sh"
echo -e 'DOWNLOAD_URL_CUT=$(echo "$DOWNLOAD_URL" | rev | cut -d ''/'' -f2- | rev)\n' >> "$HOME/final-setup.sh"
echo -e 'DOWNLOAD_URL="$DOWNLOAD_URL_CUT/{$DOWNLOAD_FILE}"\n' >> "$HOME/final-setup.sh"
echo -e 'mkdir "~/.local/share/Steam/compatibilitytools.d"\n' >> "$HOME/final-setup.sh"
echo -e 'cd "$HOME/.local/share/Steam/compatibilitytools.d"\n' >> "$HOME/final-setup.sh"
echo -e 'curl -s -L "$DOWNLOAD_URL" -o "#1"\n' >> "$HOME/final-setup.sh"
echo -e 'tar -xf "$DOWNLOAD_FILE"\n' >> "$HOME/final-setup.sh"

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

echo "INSTALLING SPOTIFY SNAP"
sudo systemctl enable --now snapd.socket
read -p "Press any key to resume ..."
sudo systemctl daemon-reload
read -p "Press any key to resume ..."
sudo systemctl restart snapd.seeded.service
read -p "Press any key to resume ..."
sudo snap install spotify
read -p "Press any key to resume ..."