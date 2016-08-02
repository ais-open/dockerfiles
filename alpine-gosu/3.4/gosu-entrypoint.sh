#!/bin/sh
set -e

if [ -n "$GOSU_CHOWN" ]; then
    for DIR in $GOSU_CHOWN
    do
        chown -R $GOSU_USER $DIR
    done
fi  


if [ "$GOSU_USER" != "0:0" ]; then
    exec gosu $GOSU_USER "$@"
fi

exec "$@"
