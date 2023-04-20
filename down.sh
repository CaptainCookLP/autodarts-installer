#!/bin/bash

echo Starting download.....
mkdir ~/autodarts-installer
cd ~/autodarts-installer

wget https://raw.githubusercontent.com/CaptainCookLP/autodarts-installer/main/kiosk.sh
wget https://raw.githubusercontent.com/CaptainCookLP/autodarts-installer/main/main.sh
wget https://raw.githubusercontent.com/CaptainCookLP/autodarts-installer/main/disclaimer.txt

sudo chmod +x kiosk.sh
sudo chmod +x main.sh

cd /home/$USER/autodarts-installer
./main.sh
