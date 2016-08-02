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

cd $CATALINA_HOME

exec /gosu-entrypoint.sh "$@"
