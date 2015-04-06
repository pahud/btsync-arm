#
# BittorrentSync docker image on ARM
#

FROM resin/rpi-raspbian

MAINTAINER Pahud Hsieh <pahudnet@gmail.com>

# Set environment.
ENV \
  DEBCONF_FRONTEND=noninteractive \
  DEBIAN_FRONTEND=noninteractive

# Install packages.
RUN apt-get update 
RUN apt-get -y install \
   wget

ADD https://download-cdn.getsyncapp.com/stable/linux-arm/BitTorrent-Sync_arm.tar.gz /opt/btsync/

# Compile openresty from source.
RUN \
  mkdir -p /opt/btsync/bin && \
  mkdir -p /opt/btsync/etc && \
  mkdir -p /opt/btsync/data && \
  cd /opt/btsync && \
  tar -xzvf BitTorrent-Sync_*.tar.gz && \
  chmod +x btsync && \
  mv btsync bin/ && \
  ln -s /lib/arm-linux-gnueabihf/ld-linux.so.3 /lib/ld-linux.so.3 && \
  ./bin/btsync --dump-sample-config > etc/btsync.conf 

WORKDIR /opt/btsync

#VOLUME ["/opt/btsync/data"]

# expose 
EXPOSE 8888

# Set the entrypoint script.
#ENTRYPOINT ["/opt/btsync/bin/btsync"]

# Define the default command.
CMD [ "/opt/btsync/bin/btsync", "--config", "/opt/btsync/etc/btsync.conf", "--nodaemon"]
