#!/bin/bash

function progress_bar {
	{
		for ((i = 0 ; i <= 100 ; i+=5)); do
		sleep 0.1
			echo $i
		done
	} | whiptail --gauge "Please wait while we are sleeping..." 6 50 0
}

function whiptail_choice {
	choices=$(whiptail --title "Choose Options" --checklist \
	"Choose Options you want to install" 20 78 5 \
	"AUTODARTS" "Autodarts" ON \
	"CALLER" "Autodarts-Caller" OFF \
	"WLED" "Autodarts-WLED" OFF \
	"KIOSK" "Firefox Kiosk Mode" OFF \
	"AUTOSTART" "Activate Autostart" OFF 3>&1 1>&2 2>&3)
	
	echo "1|$choices" > config.txt
}

function whiptail_info {
	mail=$(whiptail --inputbox "Enter your Autodarts E-Mail Address" 8 39 --title "Autodarts Information" 3>&1 1>&2 2>&3)
	pass=$(whiptail --passwordbox "Enter your Autodarts Password" 8 39 --title "Autodarts Information" 3>&1 1>&2 2>&3)
	board=$(whiptail --inputbox "Enter your Autodarts Board-ID" 8 39 --title "Autodarts Information" 3>&1 1>&2 2>&3)

	echo "2|$mail" >> config.txt
	echo "3|$pass" >> config.txt
	echo "4|$board" >> config.txt

	if (whiptail --title "Confirmation" --yesno "Is your Information correct? \n \nChoices: $choices \nMail: $mail \nBoard ID: $board" 12 78); then
		progress_bar
	else
		echo "User selected No, exit status was $?."
	fi
}

function whiptail_install {
	progress_bar
}

whiptail --textbox disclaimer.txt 20 78

menu=$(whiptail --title "Menu" --menu "Choose where you want to start" 25 78 16 \
"Choose Options" "Choose your Options to install" \
"Enter Information" "Reenter your Information" \
"Reinstall" "Reinstall your previous choices" 3>&1 1>&2 2>&3)

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
