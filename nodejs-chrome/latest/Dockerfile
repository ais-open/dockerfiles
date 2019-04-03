FROM debian:stable-slim
MAINTAINER Jonathan Meyer <jon@gisjedi.com>

LABEL name="Node with Chrome for Headless Angular testing" \
    vendor="Applied Information Sciences" \
    license="Apache v2.0"

RUN apt-get update \
 && apt-get install -yy wget curl gnupg \
 && curl -sL https://deb.nodesource.com/setup_9.x | bash - \
 && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
 && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
 && apt-get update \
 && apt-get install -y nodejs google-chrome-stable xvfb procps \
 && npm i -g npm@6 \
 && apt clean \
 && rm -rf /var/lib/apt/lists/*

