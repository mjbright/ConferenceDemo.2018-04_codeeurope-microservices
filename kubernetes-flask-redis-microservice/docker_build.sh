#!/bin/bash

HUB_PUSH=0

OWNER="mjbright"
APP="flask-web"
VERSIONS="0 1 2 3"

# Build all three versions of our application:

[ "$1" = "-push" ] && HUB_PUSH=1

[ $HUB_PUSH -ne 0 ] && {
    CMD="docker login"
    echo "-- $CMD"
    $CMD
}

for version in $VERSIONS; do
    cp -a versions/app.py.v$version app.py

    CMD="docker build -t $OWNER/$APP:v$version ."
    echo "-- $CMD"
    $CMD

    [ $HUB_PUSH -ne 0 ] && {
        CMD="docker push $OWNER/$APP:v$version"
        echo "-- $CMD"
        $CMD
    }
done

docker search $OWNER/$APP

