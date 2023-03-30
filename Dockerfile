FROM ubuntu:latest

COPY entry.sh /usr/bin/
RUN chmod +x /usr/bin/entry.sh

COPY 0route /etc/ppp/ip-up.d/
# RUN chmod +x /etc/ppp/ip-up.d/0route

# COPY connection /etc/ppp/peers/

RUN apt update
RUN apt install -y sstp-client ppp pptp-linux ca-certificates openssl net-tools --no-install-recommends
#RUN apt install -y sstp-client ppp pptp-linux ca-certificates openssl net-tools iproute2 syslog-ng --no-install-recommends

ARG BUILD_DATE
ARG IMAGE_VERSION

LABEL build-date=$BUILD_DATE
LABEL image-version=$IMAGE_VERSION

ENTRYPOINT [ "/usr/bin/entry.sh" ]