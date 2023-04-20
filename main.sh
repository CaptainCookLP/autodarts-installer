#!/bin/bash

#Install

function REQUIREMENTS {
	sudo apt-get update && sudo apt-get upgrade -y
	sudo apt-get install git python3-pip -y
	sudo apt-get install curl unclutter -y
}

function AUTODARTS {
	echo Autodarts wird installiert
	bash <(curl -sL get.autodarts.io)
}

function CALLER {
	echo Caller wird installiert
	
	cd ~
	git clone https://github.com/lbormann/autodarts-caller.git
	cd ~/autodarts-caller
	pip install -r requirements.txt
	mkdir ~/sounds

	cp ~/autodarts-caller/start.sh ~/autodarts-caller/custom.sh
	read -p "Enter Autodarts E-Mail: " mail
	read -p "Enter Autodarts Password: " pass
	read -p "Enter Autodarts-Board ID: " board

	sed -i 's/autodarts_email=/&'"$mail"'/' ~/autodarts-caller/custom.sh
	sed -i 's/autodarts_password=/&'"$pass"'/' ~/autodarts-caller/custom.sh
	sed -i 's/autodarts_board_id=/&'"$board"'/' ~/autodarts-caller/custom.sh
	sed -i 's+media_path=+&~/sounds+' ~/autodarts-caller/custom.sh
	sed -i '0,/caller=/ s/caller=/&aiden-m-english-uk/' ~/autodarts-caller/custom.sh
	sudo chmod +x custom.sh
}

function WLED {
  echo WLED wird installiert
}

function KIOSK {
	echo Kiosk wird eingerichtet
	
	gsettings set org.gnome.desktop.session idle-delay 0
	gsettings set org.gnome.desktop.screensaver lock-enabled false
	
	cd ~/autodarts-installer
	wget https://raw.githubusercontent.com/CaptainCookLP/autodarts-installer/main/kiosk.sh
	sed -i 's/BOARD_ID/'"$board"'/' ~/kiosk.sh
	sudo chmod +x kiosk.sh
}

function AUTOSTART {
	echo Autostart wird  eingerichtet
	
	mkdir ~/.config/autostart
	cd ~/.config/autostart
	
	wget https://raw.githubusercontent.com/CaptainCookLP/autodarts-installer/main/autostartkiosk.desktop
	sed -i 's/USERNAME/'"$USER"'/' ~/.config/autostart/autostartkiosk.desktop
}

#Menu

function progress_bar {
	{
		for ((i = 0 ; i <= 100 ; i+=5)); do
		sleep 0.25
			echo $i
		done
	} | whiptail --gauge "Processing Data......." 6 50 0
}

function whiptail_choice {
	choices=$(whiptail --title "Choose Options" --checklist \
	"Choose Options you want to install" 20 78 5 \
	"AUTODARTS" "Autodarts" ON \
	"CALLER" "Autodarts-Caller" OFF \
	"WLED" "Autodarts-WLED" OFF \
	"KIOSK" "Firefox Kiosk Mode" OFF \
	"AUTOSTART" "Activate Autostart" OFF 3>&1 1>&2 2>&3)
	
	echo "var1='$choices'" > config.txt
}

function whiptail_info {
	mail=$(whiptail --inputbox "Enter your Autodarts E-Mail Address" 8 39 --title "Autodarts Information" 3>&1 1>&2 2>&3)
	pass=$(whiptail --passwordbox "Enter your Autodarts Password" 8 39 --title "Autodarts Information" 3>&1 1>&2 2>&3)
	board=$(whiptail --inputbox "Enter your Autodarts Board-ID" 8 39 --title "Autodarts Information" 3>&1 1>&2 2>&3)

	echo "var2='$mail'" >> config.txt
	echo "var3='$pass'" >> config.txt
	echo "var4='$board'" >> config.txt

	if (whiptail --title "Confirmation" --yesno "Is your Information correct? \n \nChoices: $choices \nMail: $mail \nBoard ID: $board" 12 78); then
		progress_bar
	else
		echo "User selected No, exit status was $?."
	fi
}

function whiptail_install {
	source config.txt

	var=$(echo "$var1" | sed 's/["]//g')

	array=($var)

	for i in "${array[@]}"
	do
		$i
	done
}

whiptail --textbox disclaimer.txt 20 78

menu=$(whiptail --title "Menu" --menu "Choose where you want to start" 25 78 16 \
"Choose Options" "Choose your Options to install" \
"Enter Information" "Reenter your Information" \
"Reinstall" "Reinstall your previous choices" 3>&1 1>&2 2>&3)

REQUIREMENTS

case $menu in
	"Choose Options")
		whiptail_choice
	;&
	"Enter Information")
		whiptail_info
	;&
	"Reinstall")
		whiptail_install
	;;
esac

echo Finished
