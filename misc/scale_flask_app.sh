
APP=flask-app
#IMAGE=mjbright/flask-web

REPLICAS="4"
[ ! -z "$1" ] && REPLICAS="$1"

press()
{
    [ ! -z "$1" ] && echo "$*"
    echo "Press <return> to continue"
    read _DUMMY
    [ "$_DUMMY" = "q" ] && exit 0
    [ "$_DUMMY" = "Q" ] && exit 0
}


#kubectl scale deploy  flask-app  --replicas=4

press "kubectl scale deploy $APP --replicas=$REPLICAS"
kubectl scale deploy $APP --replicas=$REPLICAS

