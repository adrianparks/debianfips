FROM debian:buster-20201117-slim as builder

ENV OPENSSL_VER 1.0.2u
ENV OPENSSL_FIPS_VER 2.0.16
WORKDIR /tmp/build

COPY openssl-${OPENSSL_VER}.tar.gz .
COPY openssl-fips-${OPENSSL_FIPS_VER}.tar.gz .

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential \
    && tar xvzf openssl-fips-${OPENSSL_FIPS_VER}.tar.gz \
    && cd openssl-fips-${OPENSSL_FIPS_VER} && ./config \
    && make \
    && make install \
    && cd .. && tar xvzf openssl-${OPENSSL_VER}.tar.gz \
    && cd openssl-${OPENSSL_VER} && ./config fips shared \
    && make depend \
    && make \
    && make install \
    && ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl \
    && rm -rf /tmp/build\
    && apt-get -y remove build-essential && apt -y autoremove