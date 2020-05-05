#!/bin/bash

# Generate random server password if none is set
if [ -z "$ADMINPASS" ]; then
  ADMINPASS=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c16; echo)
fi

# Configure soldat server settings based on docker env's
sed -i "s/GameStyle=3/GameStyle=$GAMEMODE/g" /opt/steam/soldat/soldat.ini
sed -i "s/Friendly_Fire=0/Friendly_Fire=$FRIENDLYFIRE/g" /opt/steam/soldat/soldat.ini
sed -i "s/Max_Players=32/Max_Players=$MAXPLAYERS/g" /opt/steam/soldat/soldat.ini
sed -i "s/Game_Password=/Game_Password=$GAMEPASS/g" /opt/steam/soldat/soldat.ini
sed -i "s/Admin_Password=/Admin_Password=$ADMINPASS/g" /opt/steam/soldat/soldat.ini
sed -i "s/Lobby_Register=1/Lobby_Register=$LOBBYREGISTER/g" /opt/steam/soldat/soldat.ini
sed -i "s/ASE_Register=1/ASE_Register=0/g" /opt/steam/soldat/soldat.ini
sed -i "s/Server_Name=Soldat Server/Server_Name=$SERVERNAME/g" /opt/steam/soldat/soldat.ini
sed -i "s/Greeting_Message=Welcome/Greeting_Message=$GREETING/g" /opt/steam/soldat/soldat.ini
sed -i "s/Greeting_Message2=/Greeting_Message2=$GREETING2/g" /opt/steam/soldat/soldat.ini
sed -i "s/Greeting_Message3=/Greeting_Message3=$GREETING3/g" /opt/steam/soldat/soldat.ini
sed -i "s/Server_Info=/Server_Info=$SERVERINFO/g" /opt/steam/soldat/soldat.ini
sed -i "s/Balance_Teams=0/Balance_Teams=$BALANCETEAMS/g" /opt/steam/soldat/soldat.ini

# Setting realisting mode if game mode is Infiltration
if [ "$GAMEMODE" == 5 ]; then
  sed -i "s/Realistic_Mode=0/Realistic_Mode=1/g" /opt/steam/soldat/soldat.ini
fi

# Setting respawn time to 6 seconds if game mode is Rambomatch
if [ "$GAMEMODE" == 4 ]; then
  sed -i "s/Respawn_Time=180/Respawn_Time=360/g" /opt/steam/soldat/soldat.ini
fi

# Check owner of custom maps volume
SUID=$(stat -c "%u" /opt/steam/soldat/custom)
SGID=$(stat -c "%g" /opt/steam/soldat/custom)

# Set steam user to same UID as owner of custom maps
usermod -u $SUID steam

# Giving ownership to steam user for steam/game folders
chown -R steam /opt/steam

# Copy custom maps to maps directory (if any)
MAPDIR=(/opt/steam/soldat/custom)
if [ "$(ls -A $MAPDIR)" ]; then
  echo "Copying custom maps..."
  cp -f /opt/steam/soldat/custom/* /opt/steam/soldat/maps/
else
  echo "No custom maps added..."
fi

# Creating map list based on game mode
if [ "$GAMEMODE" == "0" ] || [ "$GAMEMODE" == "1" ] || [ "$GAMEMODE" == "2" ] || [ "$GAMEMODE" == "4" ]; then
  ls /opt/steam/soldat/maps | grep -v ctf_ | grep -v inf_ | grep -v htf_ | cut -d "." -f1 > /opt/steam/soldat/mapslist.txt
elif [ "$GAMEMODE" == "3" ]; then
  ls /opt/steam/soldat/maps | grep ctf_ | cut -d "." -f1 > /opt/steam/soldat/mapslist.txt
elif [ "$GAMEMODE" == "6" ]; then
  ls /opt/steam/soldat/maps | grep htf_ | cut -d "." -f1 > /opt/steam/soldat/mapslist.txt
elif [ "$GAMEMODE" == "5" ]; then
  ls /opt/steam/soldat/maps | grep inf_ | cut -d "." -f1 > /opt/steam/soldat/mapslist.txt
fi

#chmod +x /opt/steam/soldat/soldatserver
echo Admin password is: $ADMINPASS
runuser -l steam -c 'cd /opt/steam/soldat; ./soldatserver'
