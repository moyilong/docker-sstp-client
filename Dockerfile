FROM ubuntu:24.04 as base

ENV DEBIAN_FRONTEND=noninteractive
# COPY connection /etc/ppp/peers/


RUN apt update && apt upgrade -y

FROM base as build

RUN apt update && apt install --fix-missing -y \
        git git-lfs build-essential autoconf libtool-bin pkg-config

RUN git clone --depth 1 -b 1.0.19 https://gitlab.com/sstp-project/sstp-client/ /src

WORKDIR /src

RUN apt update && apt install --fix-missing -y \
        ppp-dev libssl-dev libevent-dev

RUN ls /usr/include/pppd

RUN ./autogen.sh

RUN ./configure \
        --disable-shared \
        --prefix=/usr \
        --with-pic \
        --with-gnu-ld


RUN make -j 

RUN make install DESTDIR=/install




FROM base

RUN apt update && apt install -y --no-install-recommends --fix-missing \
        ppp pptp-linux ca-certificates openssl net-tools dos2unix \
        $(sudo apt list | grep libevent | grep openssl | awk -F '/' '{print $1}')

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

COPY --from=build /install /

RUN ldd $(which sstpc)

ENTRYPOINT [ "/usr/bin/entry.sh" ]