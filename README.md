# docker-soldat-steam

Docker container for Soldat server through Steam

## Prerequisite

If you want to have your server available from the Internet, you will need to configure your router/firewall.\
The Soldat server uses the following ports:\
UDP: game port (default 23073)\
TCP/IP: admin port = game port (default 23073)\
TCP/IP: files port = game port + 10 (default 23083)

Check Wiki for more information:\
[https://wiki.soldat.pl/](https://wiki.soldat.pl/)

## Running the container

Default:
```
docker run -d --name soldat \
    -p 23073:23073 \
    -p 23073:23073/udp \
    -p 23083:23083 \
nurtalf/soldat-steam
```
If you do not specify admin password, it will be random generated and shown in the log `docker logs soldat`\
\
If you want to change any of the default settings:
```
docker run -d --name soldat \
    -p 23073:23073 \
    -p 23073:23073/udp \
    -p 23083:23083 \
    -e GAMEMODE=0 \
    -e FRIENDLYFIRE=0 \
    -e MAXPLAYERS=32 \
    -e GAMEPASS="" \
    -e ADMINPASS="" \
    -e LOBBYREGISTER=1 \
    -e SERVERNAME="Soldat server" \
    -e GREETING="Welcome" \
    -e GREETING2="" \
    -e GREETING3="" \
    -e SERVERINFO="" \
    -e BALANCETEAMS=0 \
    -v </path/to/maps/folder>:/opt/steam/soldat/custom \
nurtalf/soldat-steam
```
Game modes:\
0: Deathmatch\
1: Pointmatch\
2: Teammatch\
3: Capture the Flag\
4: Rambomatch\
5: Infiltration\
6: Hold the Flag\
\
The game modes decide which maps will be used, based on their filename:\
Capture the Flag: ctf_xxxxx.pms\
Infiltrate: inf_xxxxx.pms\
Hold the Flag: htf_xxxxx.pms\
All other game modes loads the maps that does not contain these prefixes.\
This is important if you want to add custom maps.\
If you want to add custom maps, just add the volume (-v option) as shown above.\
\
Realistic is automatically enabled on Infiltrate game mode.\
Rambomatch will automatically increase spawn time from 3 to 6 seconds.

## Howto

Connect to to shell:  `docker exec -it soldat /bin/bash`\
Logs:  `docker logs -f soldat`
