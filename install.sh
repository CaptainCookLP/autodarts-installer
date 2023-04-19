#!/bin/bash

RED='\033[0;32m'
NOCOLOR='\033[0m'

clear -x

echo -e ${RED}Disabling Screensaver and Lockscreen${NOCOLOR}
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.screensaver lock-enabled false
clear -x

echo -e ${RED}Searching for Updates and Installing required Software${NOCOLOR}
sleep 5
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install git python-pip3 curl unclutter wget -y
cd ~
echo -e ${RED}Finished${NOCOLOR}
sleep 5
clear -x

echo -e ${RED}Installing current Autodarts Release${NOCOLOR}
sleep 5
bash <(curl -sL get.autodarts.io)
echo -e ${RED}Finished${NOCOLOR}
sleep 5
clear -x

echo -e ${RED}Installing current Autodarts-Caller Release${NOCOLOR}
sleep 5
cd ~
git clone https://github.com/lbormann/autodarts-caller.git
cd ~/autodarts-caller
pip install -r requirements.txt
sudo chmod +x start.sh
mkdir ~/sounds
echo -e ${RED}Finished${NOCOLOR}
sleep 5
clear -x

echo -e ${RED}Configure Autodarts-Caller${NOCOLOR}
cp ~/autodarts-caller/start.sh ~/autodarts-caller/custom.sh
read -p "Enter Autodarts E-Mail: " mail
read -p "Enter Autodarts Password: " pass
read -p "Enter Autodarts-Board ID: " board

sed -i 's/autodarts_email=/&'"$mail"'/' ~/autodarts-caller/custom.sh
sed -i 's/autodarts_password=/&'"$pass"'/' ~/autodarts-caller/custom.sh
sed -i 's/autodarts_board_id=/&'"$board"'/' ~/autodarts-caller/custom.sh
sed -i 's+media_path=+&~/sounds+' ~/autodarts-caller/custom.sh
sed -i 's/caller=/&aiden-m-english-uk/' ~/autodarts-caller/custom.sh
echo -e ${RED}Finished${NOCOLOR}
sleep 5
clear -x

echo -e ${RED}Creating Startscript${NOCOLOR}
cd ~
wget https://raw.githubusercontent.com/CaptainCookLP/autodarts-installer/main/kiosk.sh
sed -i 's/BOARD_ID/&'"$board"'/' ~/kiosk.sh
sudo chmod +x kiosk.sh
echo -e ${RED}Finished${NOCOLOR}
sleep 5
clear -x
