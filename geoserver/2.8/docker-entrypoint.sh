#!/bin/bash
set -e

HEAP_SIZE=`awk 'BEGIN{printf "%.0f\n", '${INSTANCE_MEMORY}'*(3/4)}'`
export CATALINA_OPTS="${CATALINA_OPTS} -Xms${HEAP_SIZE}m -Xmx${HEAP_SIZE}m"
if [ "$OOM_KILL" = true ] ; then
    echo 'Enabling OutOfMemory exception killer'
    export CATALINA_OPTS="${CATALINA_OPTS} -XX:OnOutOfMemoryError='kill %p'"
fi

exec "$@"
