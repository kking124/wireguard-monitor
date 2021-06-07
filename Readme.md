# wireguard-monitor

A systemd service container to monitor `wg0.conf` and restart a docker container on the same host if the monitored file changes. 

## Features

- Choose container name to restart

## Run wireguard-monitor

You can run the container directly from the command line:

```sh
docker run -d --name wg-monitor \
    --security-opt seccomp=unconfined \  # see parent image
    --tmpfs /tmp \  # see parent image
    --tmpfs /run \  # see parent image
    --tmpfs /run/lock \  # see parent image
    -v /path/to/wireguard/config/folder:/etc/wireguard:ro # required
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \ # see parent image
    -v /var/run/docker.sock:/var/run/docker.sock \ #required
    -e SVC_HOST=docker \ #optional - currently docker is the only service host
    -e CONTAINER=wireguard \ #optional - default container name is wireguard
    kking124/wireguard-monitor
```

Or you can run using docker-compose:

```yaml
version: "2.1"
services:
  wg-monitor:
    image: kking124/wireguard-monitor
    container_name: wg-monitor
    security_opt:
      - seccomp:unconfined # see parent image
    environment:
      - SVC_HOST=docker #optional - currently docker is the only service host
      - CONTAINER=wireguard #optional - default container name is wireguard
    volumes:
      - /path/to/wireguard/config:/etc/wireguard:ro # required
      - /sys/fs/cgroup:/sys/fs/cgroup:ro # see parent image
      - /var/run/docker.sock:/var/run/docker.sock # required if SVC_HOST=docker
    tmpfs:
      - /tmp # see parent image
      - /run # see parent image
      - /run/lock # see parent image
    tty: true # see parent image
```

## Example Usage

Original use is in a 3 container setup with `ghcr.io/linuxserver/wireguard` and `ngoduykhanh/wireguard-ui`.

```yaml
version: "2.1"
services:
  wireguard:
    image: ghcr.io/linuxserver/wireguard
    container_name: wireguard
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    environment:
      - PUID=1000
      - PGID=1000
      - PEERS=0
    volumes:
      - ./config:/config
    ports:
      - 51820:51820/udp
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
    restart: always
  wgui:
    image: ngoduykhanh/wireguard-ui
    container_name: wireguard-ui
    ports:
      - 5000:5000
    environment:
      - PASS="S0M3_C0MPLEX_P@$$W0RD"
    volumes:
      - ./config:/etc/wireguard
    depends_on:
      - "wireguard"
    restart: always
  wg-monitor:
    image: kking124/wireguard-monitor:1.0
    container_name: wireguard-monitor
    security_opt:
      - seccomp:unconfined # see parent image
    environment:
      - SVC_HOST=docker #optional - currently docker is the only service host
      - CONTAINER=wireguard #optional - default container name is wireguard
    volumes:
      - ./config:/etc/wireguard:ro # required
      - /sys/fs/cgroup:/sys/fs/cgroup:ro # see parent image
      - /var/run/docker.sock:/var/run/docker.sock # required if SVC_HOST=docker
    depends_on:
      - "wireguard"
    restart: always
    tmpfs:
      - /tmp # see parent image
      - /run # see parent image
      - /run/lock # see parent image
    tty: true # see parent image
```

For more information on the above wireguard container, see: [https://github.com/linuxserver/docker-wireguard](https://github.com/linuxserver/docker-wireguard)

For more information on the above admin ui container, see: [https://github.com/ngoduykhanh/wireguard-ui](https://github.com/ngoduykhanh/wireguard-ui)

For more information on the parent image's startup values, see: [https://github.com/j8r/dockerfiles/tree/master/systemd](https://github.com/j8r/dockerfiles/tree/master/systemd) 

## Build

### Build docker image

Go to the project `src` directory and run the following command:

```
docker build -t wireguard-monitor .
```

## License
MIT. See [LICENSE](https://github.com/kking124/wireguard-monitor/blob/master/LICENSE).