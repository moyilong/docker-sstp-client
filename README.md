# SSTP client running in docker

Allows other docker containers to connect to SSTP network.

## Usage

### With Docker compose


_docker-compose.yml_
```yaml
version: '3'

services:
  sstpc:
    container_name: sstpc
    image: "tiomny/docker-sstp-client"
    restart: unless-stopped
    cap_add:
      - NET_ADMIN
    privileged: true 
    ports:
      - <port>:<port>
    environment:
      REMOTEHOST: ${REMOTEHOST}
      USER: ${USER}
      PASSWORD: ${PASSWORD}

  container_to_connect_sstp_network:
    image: xxx/xxx
    restart: unless-stopped
    network_mode: "service:sstpc"
```
where \<port> - port to share from `container_to_connect_sstp_network`.

_run_
```bash
USER="xxx" PASSWORD="xxx" REMOTEHOST="xxx" docker compose up -d
```

### With docker command

```bash
docker run \
    -d \
    -it \
    --privileged \
    --cap-add=NET_ADMIN \
    -p <port>:<port> \
    -e REMOTEHOST: <REMOTEHOST> \
    -e USER: <USER> \
    -e PASSWORD: <PASSWORD> \
    tiomny/docker-sstp-client
```
