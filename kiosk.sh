#!/bin/bash
## Script by FKmedify | Fabi
## Tested on Ubuntu 20.04 with Autodarts 0.19.0 / Caller 2.2.0
## Tested last on 19/04/2023

function online {
  ## Test if autodarts.io is online
  ping -c 1 autodarts.io
  return $?
}

until online
do
  sleep 5
done

echo Ping is Running

function autodarts {
  ## Check if Autodarts-Service is active
  systemctl is-active --quiet autodarts
  return $?
}

until autodarts
do
  sleep 5
done

echo Autodarts is Running

# Start Firefox in Fullscreen to Follow-Link of Autodarts-Board
firefox --kiosk https://autodarts.io/boards/BOARD_ID/follow &

# Start Autodarts-Caller in directory /home/autodarts
~/autodarts-caller/custom.sh &

# Removing the Mousecursor
unclutter -idle 0.01 -root &
