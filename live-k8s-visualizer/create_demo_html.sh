#!/bin/bash

die() {
    echo "$0: die - $*" >&2
    exit 1
}

cd $(dirname $0)

OPTS=""

SERVE_IP=127.0.0.1
NODE_IP=192.168.99.100
NODE_PORT="PORT_UNSET"

while [ ! -z "$1" ];do
    case $1 in
        -r)   # Access remotely:
            SERVE_IP=$(ip a | awk '!/127.0.0.1/ && / inet / { FS="/"; $0=$2; print $1; exit(0); }')
            ;;

        -s)   # Set service NODE_PORT port:
            NODE_PORT=$(kubectl get svc | awk '/^flask-app/ { FS=":"; $0=$5; FS="/"; $0=$2; print $1; }')
            ;;

        *)  die "Bad option <$1>";;
    esac
    shift
done

SERVICE_URL=http://${NODE_IP}:${NODE_PORT}
VISUALIZER_URL=http://${SERVE_IP}:8002

#sed -e "s/SERVICE_URL/$SERVICE_URL/g" \
    #-e "s/VISUALIZER_URL/$VISUALIZER_URL/g" \
    #demo.html.template > demo.html

sed -e "s-SERVICE_URL-$SERVICE_URL-g" \
    -e "s-VISUALIZER_URL-$VISUALIZER_URL-g" \
    demo.html.template > demo.html

