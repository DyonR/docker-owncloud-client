FROM debian:10
MAINTAINER DyonR

# Create the directory in which the scripts will be stored
RUN mkdir -p /opt/Scripts

# Update, upgrade and install some packages
RUN apt update \
    && apt -y upgrade \
    && apt -y install \
    apt-transport-https \
    wget \
    dialog \
    apt-utils \
    htop \
    gnupg2

RUN echo 'deb https://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Debian_10/ /' > /etc/apt/sources.list.d/owncloud-client.list \
    && wget -nv https://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Debian_10/Release.key -O Release.key \
    && apt-key add - < Release.key \
    && apt update \
    && apt install -yq --no-install-recommends owncloud-client \
    && apt upgrade -y \
    && apt-get clean \
    && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /usr/share/doc \
    /usr/share/man \
    /usr/share/locale \
    /usr/share/info \
    /usr/share/lintian \
    /Release.key

COPY *.sh /opt/Scripts/
WORKDIR /ocdata

ENTRYPOINT ["/opt/Scripts/docker-entrypoint.sh"]
CMD ["/opt/Scripts/run.sh"]

ENV OC_USER=oc_username \
    OC_PASS=oc_passwordORtoken \
    OC_PROTO=https \
    OC_SERVER=yourserver.com \
    OC_URLPATH=/ \
    OC_WEBDAV=remote.php/webdav \
    OC_FILEPATH=/ \
    TRUST_SELFSIGN=0 \
    SYNC_HIDDEN=0 \
    SILENCE_OUTPUT=1 \
    RUN_INTERVAL=30 \
    RUN_UID=99 \
    RUN_GID=100
