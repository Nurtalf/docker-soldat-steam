FROM centos:8

ENV GAMEMODE 0
ENV FRIENDLYFIRE 0

ENV MAXPLAYERS 32
ENV LOBBYREGISTER 1
ENV SERVERNAME Soldat Server
ENV GREETING Welcome
ENV BALANCETEAMS 0

RUN yum update -y &&  yum install -y glibc.i686 libstdc++.i686 libgcc_s.so.1 wget nano && yum clean all

RUN useradd -m steam; \
        mkdir -p /opt/steam/soldat/custom; \
        chown -R steam /opt/steam;

USER steam
WORKDIR /opt/steam
RUN wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz; \
        tar -xvzf steamcmd_linux.tar.gz; \
        ./steamcmd.sh +login anonymous +force_install_dir /opt/steam/soldat +app_update 638500 validate +quit; \
        rm -fr steamcmd_linux.tar.gz;

USER root
COPY files/ /root/
RUN chmod +x /root/*.sh;

VOLUME /opt/steam/soldat/custom
EXPOSE 23083/tcp 23073/tcp 23073/udp

CMD ["/root/start.sh"]
