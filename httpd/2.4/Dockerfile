FROM appliedis/centos-gosu:7
MAINTAINER Jonathan Meyer <jon@gisjedi.com>

# Update
RUN yum -y update && \
	yum clean all

# Install Apache httpd 2.4, mod ssl, open ssl
RUN yum install -y httpd mod_ssl openssl && \
	yum clean all

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/httpd/access_log
RUN ln -sf /dev/stderr /var/log/httpd/error_log
RUN ln -sf /dev/stdout /var/log/httpd/ssl_access_log
RUN ln -sf /dev/stderr /var/log/httpd/ssl_error_log

# Simple startup script to avoid some issues observed with container restart
ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

EXPOSE 80

CMD ["/run-httpd.sh"]



