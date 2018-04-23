
#kubectl set image deploy flask-app flask-app=mjbright/flask-web:v2

APP=flask-app
IMAGE=mjbright/flask-web

VERSION="v2"

press()
{
    [ ! -z "$1" ] && echo "$*"
    echo "Press <return> to continue"
    read _DUMMY
    [ "$_DUMMY" = "q" ] && exit 0
    [ "$_DUMMY" = "Q" ] && exit 0
}

die() {
    echo "$0: die - $*" >&2
    exit 1
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

case $1 in
    v[0-9])VERSION="$1";;
    [0-9]) VERSION="v$1";;

    -w) watch_rollout; exit;;

    *) die "Bad version format";;
esac

press "kubectl set image deploy $APP $APP=$IMAGE:$VERSION"
kubectl set image deploy $APP $APP=$IMAGE:$VERSION

watch_rollout

