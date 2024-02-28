FROM ubuntu:latest


# COPY connection /etc/ppp/peers/

RUN sed -i \
        -e 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' \
        -e 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' \
        /etc/apt/sources.list && \
        apt update

RUN apt update && apt upgrade -y && \
    apt install -y --no-install-recommends \
        sstp-client ppp pptp-linux ca-certificates openssl net-tools dos2unix


COPY entry.sh /usr/bin/
COPY 0route /etc/ppp/ip-up.d/

RUN chmod +x /usr/bin/entry.sh && \
    chmod +x /etc/ppp/ip-up.d/0route && \
    dos2unix /usr/bin/entry.sh && \
    dos2unix /etc/ppp/ip-up.d/0route

ARG BUILD_DATE
ARG IMAGE_VERSION

LABEL build-date=$BUILD_DATE
LABEL image-version=$IMAGE_VERSION


ENTRYPOINT [ "/usr/bin/entry.sh" ]