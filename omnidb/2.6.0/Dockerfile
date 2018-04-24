FROM centos
MAINTAINER Jonathan Meyer <jon@gisjedi.com>

ENV OMNIDB_VERSION 2.6.0

RUN yum install -y https://omnidb.org/dist/$OMNIDB_VERSION/omnidb-server_$OMNIDB_VERSION-centos-amd64.rpm \
	&& rm -fr /var/cache/yum

EXPOSE 8000
EXPOSE 25482

ENTRYPOINT ["omnidb-server"]
