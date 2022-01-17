#!/usr/bin/su root
echo -ne "
-------------------------------------------------------------------------
   █████╗ ██████╗  ██████╗██╗  ██╗████████╗██╗████████╗██╗   ██╗███████╗
  ██╔══██╗██╔══██╗██╔════╝██║  ██║╚══██╔══╝██║╚══██╔══╝██║   ██║██╔════╝
  ███████║██████╔╝██║     ███████║   ██║   ██║   ██║   ██║   ██║███████╗
  ██╔══██║██╔══██╗██║     ██╔══██║   ██║   ██║   ██║   ██║   ██║╚════██║
  ██║  ██║██║  ██║╚██████╗██║  ██║   ██║   ██║   ██║   ╚██████╔╝███████║
  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝   ╚═╝    ╚═════╝ ╚══════╝
-------------------------------------------------------------------------
                    Automated Arch Linux Installer
                        SCRIPTHOME: ArchTitus
-------------------------------------------------------------------------

Installing Spotify and GoldenEggroll Proton
"
#Spotify
echo "INSTALLING SPOTIFY SNAP"
sudo systemctl enable --now snapd.socket
sudo systemctl daemon-reload
sudo systemctl restart snapd.seeded.service
sudo snap install spotify

#Proton
echo "Install GE Proton"
steam #Initialize the Steam folders
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest \
        | grep browser_download_url \
        | grep Proton \
        | grep tar.gz \
        | cut -d '"' -f 4)
DOWNLOAD_FILE=$(echo "$DOWNLOAD_URL" | rev | cut -d '/' -f1 | rev)
DOWNLOAD_URL_CUT=$(echo "$DOWNLOAD_URL" | rev | cut -d '/' -f2- | rev)
DOWNLOAD_URL="$DOWNLOAD_URL_CUT/{$DOWNLOAD_FILE}"
mkdir "$HOME/.local/share/Steam/compatibilitytools.d"
cd "$HOME/.local/share/Steam/compatibilitytools.d"
curl -s -L "$DOWNLOAD_URL" -o '#1'
tar -xf $DOWNLOAD_FILE

echo -ne "
-------------------------------------------------------------------------
                              SYSTEM READY
-------------------------------------------------------------------------
"
exit
