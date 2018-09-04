
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


#kubectl set image deploy flask-app flask-app=mjbright/flask-web:v2


press "kubectl set image deploy $APP $APP=$IMAGE:$VERSION"
kubectl set image deploy $APP $APP=$IMAGE:$VERSION

