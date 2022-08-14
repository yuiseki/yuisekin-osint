FROM ubuntu:22.04

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y \
    #
    # Essential tools
    #
    git \
    curl \
    vim \
    htop \
    jq \
    nkf \
    #
    # Development
    #
    gcc \
    make \
    build-essential \
    python3-pip \
    ruby-dev \
    zlib1g-dev \
    #
    # Passive OSINT
    #
    # ping
    iputils-ping \
    hping3 \
    # ip, ss
    iproute2 \
    whois \
    # geoiplookup
    geoip-bin \
    geoip-database \
    # traceroute, tcptraceroute
    traceroute \
    mtr \
    # dig, nslookup
    dnsutils \
    recon-ng \
    p0f \
    ipcalc \
    grepcidr \
    aha \
    #
    # Active OSINT
    #
    dnsmap \
    zmap \
    # nmap, nping
    nmap \
    ndiff \
    # nc
    ncat

# asn
RUN curl -Ls https://raw.githubusercontent.com/nitefood/asn/master/asn > /usr/bin/asn && \
    chmod 0755 /usr/bin/asn

# nodejs
RUN curl -Ls https://deb.nodesource.com/setup_18.x | bash
RUN apt update && apt install -y nodejs

# wpscan
# https://github.com/wpscanteam/wpscan
RUN gem install wpscan

RUN useradd -m user
USER user

# install recon modules
RUN recon-cli -C "marketplace install all"

# rust
#ENV RUST_VERSION stable
#RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain ${RUST_VERSION}
#RUN echo 'source /home/user/.cargo/env' >> /home/user/.bashrc
#ENV PATH="/home/user/.cargo/bin:${PATH}"
#RUN rustup install stable

# htmlq
#RUN cargo install htmlq

#WORKDIR /workspaces/yuisekin-osint

# masscan
# https://github.com/robertdavidgraham/masscan

# Yeti
#RUN curl https://raw.githubusercontent.com/yeti-platform/yeti/master/extras/ubuntu_bootstrap.sh | /bin/bash

# theHarvester
# https://github.com/laramies/theHarvester
#RUN git clone --depth=1 https://github.com/laramies/theHarvester && \
#    cd theHarvester && \
#    python3 -m pip install -r requirements/base.txt

# SpiderFoot
# https://github.com/smicallef/spiderfoot
#RUN git clone --depth=1 https://github.com/smicallef/spiderfoot.git && \
#    cd spiderfoot \
#    python3 -m pip install -r requirements.txt

# WhatWeb
# https://github.com/urbanadventurer/WhatWeb

# discover.sh
# https://github.com/leebaird/discover

CMD [ "sleep", "infinity" ]
