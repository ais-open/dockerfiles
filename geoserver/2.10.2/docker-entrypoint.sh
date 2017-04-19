#!/bin/sh
set -e

HEAP_SIZE=`awk 'BEGIN{printf "%.0f\n", '${INSTANCE_MEMORY}'*(1/2)}'`
export CATALINA_OPTS="${CATALINA_OPTS} -Xms${HEAP_SIZE}m -Xmx${HEAP_SIZE}m"
if [ "$OOM_KILL" = true ] ; then
    echo 'Enabling OutOfMemory exception killer'
    export CATALINA_OPTS="${CATALINA_OPTS} -XX:OnOutOfMemoryError='kill %p'"
fi

# Load defaults if config is missing
if find "$GEOSERVER_DATA_DIR" -mindepth 1 -print -quit | grep -q . ; then
    echo "Existing GeoServer configs detected"
else
    echo "Prepping GeoServer with default configs"
    cp -R $CATALINA_HOME/webapps/geoserver/data/* $GEOSERVER_DATA_DIR
fi

cd $GEOSERVER_DATA_DIR
# Set default logging location internal to container
sed -i 's|<location>logs/geoserver.log</location>|<location>/var/log/geoserver/geoserver.log</location>|g' logging.xml

# Shim in proxyBaseUrl into config if it doesn't exist
grep settings global.xml > /dev/null || \
    grep proxyBaseUrl global.xml > /dev/null || \
    sed -i 's|<global>|<global>\n  <settings>\n    <proxyBaseUrl></proxyBaseUrl>\n  </settings>|g' global.xml

# If GEOSERVER_HOSTNAME is set, place in proxyBaseUrl config
if [ -z "$GEOSERVER_HOSTNAME" ] ; then
    echo "GEOSERVER_HOSTNAME not set. Leaving proxyBaseUrl unset."
else
    echo "Setting GeoServer hostname to $GEOSERVER_HOSTNAME"
    sed -i 's|<proxyBaseUrl>.*</proxyBaseUrl>|<proxyBaseUrl>http://'$GEOSERVER_HOSTNAME'/geoserver</proxyBaseUrl>|g' global.xml
fi

# If tarball URI set, explode tarball into WEB-INF/lib dir
if [ -z "$GEOSERVER_EXTENSION_TARBALL_URI" ] ; then
    echo "GEOSERVER_EXTENSION_TARBALL_URI not set. Leaving extension directory unchanged."
else
    echo "Adding extensions found within tarball at $GEOSERVER_EXTENSION_TARBALL_URI..."
    curl $GEOSERVER_EXTENSION_TARBALL_URI | tar -xzv -C $CATALINA_HOME/webapps/geoserver/WEB-INF/lib
    chown -R $GOSU_USER $CATALINA_HOME/webapps/geoserver/WEB-INF/lib
fi

# Environment variable that will enable entrypoint to fetch and overwrite the GeoServer web.xml file
if [ -z "$GEOSERVER_WEB_XML_URI" ] ; then
    echo "GEOSERVER_WEB_XML_URI not set. Leaving web.xml unchanged."
else
    echo "Adding custom web.xml from $GEOSERVER_WEB_XML_URI..."
    curl $GEOSERVER_WEB_XML_URI > $CATALINA_HOME/webapps/geoserver/WEB-INF/web.xml 
fi

cd $CATALINA_HOME/webapps/geoserver/WEB-INF/

# If ENABLE_CORS is set, place in filter config
if [ -n "$ENABLE_CORS" ] ; then
    if grep -q '<filter-name>CorsFilter</filter-name>' web.xml; then
        #do nothing
        echo "CORS filter already enabled"
    else
        echo "Adding filter config to enable CORS"
        sed -i 's|</web-app>| |g' web.xml
        printf "<filter>\n <filter-name>CorsFilter</filter-name>\n <filter-class>org.apache.catalina.filters.CorsFilter</filter-class>\n</filter>\n<filter-mapping>\n <filter-name>CorsFilter</filter-name>\n <url-pattern>/*</url-pattern>\n</filter-mapping>\n</web-app>" >> web.xml
    fi
fi

cd $CATALINA_HOME

exec /gosu-entrypoint.sh "$@"
