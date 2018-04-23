
APP=flask-app
IMAGE=mjbright/flask-web

VERSION="v2"
[ ! -z "$1" ] && VERSION="$1"

press()
{
    [ ! -z "$1" ] && echo "$*"
    echo "Press <return> to continue"
    read _DUMMY
    [ "$_DUMMY" = "q" ] && exit 0
    [ "$_DUMMY" = "Q" ] && exit 0
}

watch_rollout() {
    CMD="kubectl rollout status deployment/$APP --watch=false"

    echo;
    echo "Following rollout status using '$CMD'"
    #while true; do echo $(date) $(kubectl rollout status deployment/flask-app --watch=false); sleep 5; done

    while true; do
        CMD_OP=$($CMD)
        CMD_RES=$?
        echo $(date) [$CMD_RES] - $CMD_OP

        echo $CMD_OP | grep -q "successfully rolled out" && break

        sleep 5
    done
}

[ "$VERSION" = "-w" ] && {
    watch_rollout; exit
}

#kubectl set image deploy flask-app flask-app=mjbright/flask-web:v2


press "kubectl set image deploy $APP $APP=$IMAGE:$VERSION"
kubectl set image deploy $APP $APP=$IMAGE:$VERSION

watch_rollout

