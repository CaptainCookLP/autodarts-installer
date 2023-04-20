#!/bin/bash

echo Starting download.....
mkdir ~/autodarts-installer
cd ~/autodarts-installer

wget https://raw.githubusercontent.com/CaptainCookLP/autodarts-installer/main/autostartkiosk.desktop
wget https://raw.githubusercontent.com/CaptainCookLP/autodarts-installer/main/kiosk.sh
wget https://raw.githubusercontent.com/CaptainCookLP/autodarts-installer/main/install.sh
wget https://raw.githubusercontent.com/CaptainCookLP/autodarts-installer/main/main.sh

sudo chmod +x kiosk.sh
sudo chmod +x install.sh
sudo chmod +x main.sh

./home/$USER/autodarts-installer/main.sh &
