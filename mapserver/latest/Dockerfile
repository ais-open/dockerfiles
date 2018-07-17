FROM alpine
MAINTAINER Jonathan Meyer <jon@gisjedi.com>

LABEL name="MapServer Alpine Container" \
    vendor="Applied Information Sciences" \
    license="Apache v2.0"

RUN apk upgrade -U && \
    apk add --repository http://dl-cdn.alpinelinux.org/alpine/edge/main libressl2.7-libcrypto && \
    apk add mapserver --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    apk add apache2 && \
    rm -fr /var/cache/apk

RUN mkdir -p /run/apache2

# Activate cgi modules.
RUN sed -i -e 's/#LoadModule\ cgid_module/LoadModule\ cgid_module/g' /etc/apache2/httpd.conf
RUN sed -i -e 's/#LoadModule\ cgi_module/LoadModule\ cgi_module/g' /etc/apache2/httpd.conf

# Write CustomLog output directly to /proc/self/fd/1 (which is STDOUT) and the ErrorLog to /proc/self/fd/2 (which is STDERR).
RUN sed -ri \
        -e 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g' \
        -e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' \
        "/etc/apache2/httpd.conf"

# Add CORS support
RUN echo 'Header set Access-Control-Allow-Origin "*"' >> /etc/apache2/conf.d/default.conf

RUN cp /usr/bin/mapserv /var/www/localhost/cgi-bin/mapserv

ENV MS_ERRORFILE /dev/stderr
ENV MS_DEBUGLEVEL 5
ENV MAX_REQUESTS_PER_PROCESS 1000

EXPOSE 80

CMD ["/usr/sbin/httpd","-DFOREGROUND"]
