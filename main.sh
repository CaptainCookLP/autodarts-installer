#!/bin/bash

#Install

function REQUIREMENTS {
	sudo apt-get -qq update
	sudo apt-get -qq upgrade -y
	sudo apt-get -qq install git python3-pip -y
	sudo apt-get -qq install curl unclutter -y
}

function AUTODARTS {
	bash <(curl -sL get.autodarts.io)
}

function CALLER {
	cd ~
	git clone https://github.com/lbormann/autodarts-caller.git
	cd ~/autodarts-caller
	pip install -r requirements.txt
	mkdir ~/sounds
	cp ~/autodarts-caller/start.sh ~/autodarts-caller/custom.sh
	sudo chmod +x custom.sh
}

function WLED {
  echo WLED wird installiert
}

function KIOSK {
	gsettings set org.gnome.desktop.session idle-delay 0
	gsettings set org.gnome.desktop.screensaver lock-enabled false
	
	cd ~/autodarts-installer
	sed -i 's/BOARD_ID/'"$board"'/' ~/autodarts-installer/kiosk.sh
	sudo chmod +x kiosk.sh
}

function AUTOSTART {
	mkdir /home/$USER/.config/autostart
	cd /home/$USER/.config/autostart
	
	wget https://raw.githubusercontent.com/CaptainCookLP/autodarts-installer/main/autostartkiosk.desktop
	sed -i 's/USERNAME/'"$USER"'/' /home/$USER/.config/autostart/autostartkiosk.desktop
}

#Menu

function progress_bar {
	pid=$!

	trap "kill $pid 2> /dev/null" EXIT

	while kill -0 $pid 2> /dev/null; do
		{
			for ((i = 0 ; i <= 100 ; i+=5)); do
			sleep 0.25
				echo $i
			done
		} | whiptail --gauge "Processing Data......." 6 50 0
	done

	trap - EXIT
}

function menu {
	menu=$(whiptail --title "Menu" --menu "Choose where you want to start" 25 78 16 \
	"Choose Options" "Choose your Options to install" \
	"Enter Information" "Reenter your Information" \
	"Reinstall" "Reinstall your previous choices" \
	"EXIT" "Exit installer" 3>&1 1>&2 2>&3)
	
	exitstatus=$?
	if [ $exitstatus = 0 ]; then
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
		"EXIT")
			exit
		;;
	esac
	else
		exit
	fi
}

function whiptail_choice {
	choices=$(whiptail --title "Choose Options" --checklist \
	"Choose Options you want to install" 20 78 5 \
	"AUTODARTS" "Autodarts" ON \
	"CALLER" "Autodarts-Caller" OFF \
	"WLED" "Autodarts-WLED" OFF \
	"KIOSK" "Firefox Kiosk Mode" OFF \
	"AUTOSTART" "Activate Autostart" OFF 3>&1 1>&2 2>&3)
	
	exitstatus=$?
	if [ $exitstatus = 0 ]; then
		echo "var1='$choices'" > config.txt
	else
		menu
	fi
}

function whiptail_info {
	mail=$(whiptail --inputbox "Enter your Autodarts E-Mail Address" 8 39 --title "Autodarts Information" 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [ $exitstatus = 1 ]; then
		menu
	fi
	pass=$(whiptail --passwordbox "Enter your Autodarts Password" 8 39 --title "Autodarts Information" 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [ $exitstatus = 1 ]; then
		menu
	fi
	board=$(whiptail --inputbox "Enter your Autodarts Board-ID" 8 39 --title "Autodarts Information" 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [ $exitstatus = 1 ]; then
		menu
	fi

	echo "var2='$mail'" >> config.txt
	echo "var3='$pass'" >> config.txt
	echo "var4='$board'" >> config.txt

	if (whiptail --title "Confirmation" --yesno "Is your Information correct? \n \nChoices: $choices \nMail: $mail \nBoard ID: $board" 12 78); then
		progress_bar
	else
		menu
	fi
}

function whiptail_install {
	source config.txt

	var=$(echo "$var1" | sed 's/["]//g')

	array=($var)

	for i in "${array[@]}"
	do
		$i &
		progress_bar
	done
}

whiptail --textbox disclaimer.txt 20 78

REQUIREMENTS &
progress_bar

menu

echo Finished
