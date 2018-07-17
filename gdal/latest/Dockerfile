FROM alpine
MAINTAINER Jonathan Meyer <jon@gisjedi.com>

LABEL name="Lightweight Geospatial Data Abstraction Library (GDAL) on Alpine Linux" \
    vendor="Applied Information Sciences" \
    license="Apache v2.0"

RUN apk upgrade -U && \
    apk add --repository http://dl-cdn.alpinelinux.org/alpine/edge/main libressl2.7-libcrypto && \
    apk add gdal --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    rm -fr /var/cache/apk
