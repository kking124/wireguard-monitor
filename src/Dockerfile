# Dockerfile
# author: https://github.com/kking124
# copyright: 2021
# license: MIT
FROM  jrei/systemd-ubuntu:20.04
LABEL maintainer=https://github.com/kking124
STOPSIGNAL SIGRTMIN+3
ENV CONTAINER=wireguard SVC_HOST=docker
COPY . /app
RUN sed -i 's/#\(ForwardToConsole=\).*$/\1yes/' /etc/systemd/journald.conf && \
    apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get -y update && \
    apt-get -y install docker-ce docker-ce-cli containerd.io && \
    rm -rf /var/lib/apt/lists/* && \
    chmod -x /app/services/wgui.* && \
    ln -s /app/services/wgui.service /etc/systemd/system/wgui.service && \
    ln -s /app/services/wgui.path /etc/systemd/system/wgui.path && \
    systemctl enable wgui.path wgui.service