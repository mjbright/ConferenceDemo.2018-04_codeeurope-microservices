
# TODO:
# - create my own flask+redis application, own functionality
# - create my own Go equivalent
# - create my own Node.js equivalent
# - tag as mjbright/flask-xxx
# - push as mjbright/flask-xxx
# - create git repo with Dockerfile and k8s templates
# - add build script (this) + README, and credit
#      blog post: Scaling Python Microservices with Kubernetes
#                 http://blog.apcelent.com/scaling-python-microservices-kubernetes.html
#      git clone https://github.com/codecraf8/kubernetes-flask-redis-microservice
#      note on ErrImagePull: https://stackoverflow.com/questions/36874880/kubernetes-cannot-pull-local-image

#cd ~/src/git/
#git clone https://github.com/codecraf8/kubernetes-flask-redis-microservice

FLASK_IMAGE=mjbright/flask-web
#FLASK_IMAGE=flask-web
SERVICE=flask-app
VERSION=v1

################################################################################
# Helper functions:

die() {
    echo "$0: die - $*" >&2
    for i in 0 1 2 3 4 5 6 7 8 9 10;do
        CALLER_INFO=`caller $i`
        [ -z "$CALLER_INFO" ] && break
        echo "    Line: $CALLER_INFO" >&2
    done
    exit 1
}

warn() {
    echo "$0: warn - $*" >&2
    for i in 0 1 2 3 4 5 6 7 8 9 10;do
        CALLER_INFO=`caller $i`
        [ -z "$CALLER_INFO" ] && break
        echo "    Line: $CALLER_INFO" >&2
    done
}

#
# Function: press <prompt>
# Prompt user to press <return> to continue
# Exit if the user enters q or Q
#
press()
{
    [ ! -z "$1" ] && echo "$*"
    echo "Press <return> to continue"
    read _DUMMY
    [ "$_DUMMY" = "q" ] && exit 0
    [ "$_DUMMY" = "Q" ] && exit 0
}

#
# function yesno <question> [<default>]
# e.g. use as:
#     yesno "Edit reminder file?" && vi $reminder_file_tomerge
#
function yesno
{
    resp=""
    default=""
    [ ! -z "$2" ] && default="$2"

    while [ 1 ]; do
        if [ ! -z "$default" ];then
            echo -n "$1 [yYnNqQ] [$default]:"
            read resp
            [ -z "$resp" ] && resp="$default"
        else
            echo -n "$1 [yYnNqQ]:"
            read resp
        fi
        [ \( "$resp" = "q" \) -o \( "$resp" = "Q" \) ] && exit 0
        [ \( "$resp" = "y" \) -o \( "$resp" = "Y" \) ] && return 0
        [ \( "$resp" = "n" \) -o \( "$resp" = "N" \) ] && return 1
    done
}

# yesno "Should I do this thing?" && echo "YES - you should" || echo "NO - you shouldn't"


################################################################################
# Main functions:


CLEAN() {
    kubectl delete -f flask-service.yaml
    kubectl delete -f redis-service.yaml

    kubectl delete -f flask-deployment.yaml
    kubectl delete -f redis-deployment.yaml

    kubectl get pods
}

MINIKUBE_CACHE() {
    minikube cache add redis:latest
    minikube cache add python:2.7
    minikube cache list
}

BUILD_ALL() {
    eval $(minikube docker-env)
    cp -a versions/app.py.v1 app.py; BUILD v1
    cp -a versions/app.py.v2 app.py; BUILD v2
    cp -a versions/app.py.v3 app.py; BUILD v3
}

BUILD() {
    local VERSION=$1; shift

    eval $(minikube docker-env)
    docker build -t $FLASK_IMAGE:$VERSION .
    docker images |grep $FLASK_IMAGE
}

APPLY() {
    kubectl apply -f flask-deployment.yaml
    kubectl apply -f redis-deployment.yaml
    kubectl apply -f flask-service.yaml
    kubectl apply -f redis-service.yaml

    kubectl get pods
}

ACCESS() {
    kubectl get service/$SERVICE || die "No such service as <$SERVICE>"
    #kubectl get service $SERVICE --output='jsonpath={.spec.ports[0].nodePort}'

    PORT=$(kubectl get service $SERVICE --output='jsonpath={.spec.ports[0].nodePort}')
    [ -z "$PORT" ] && die "Failed to get nodePort for service $SERVICE"

    IP="$(minikube ip)"
    [ -z "$IP" ] && die "Failed to get IP for minikube"

    URL="$IP:$PORT"
    CMD="curl 'http://${URL}/"

    press "About to run: <$CMD>"
    eval $CMD

    ## URL="$IP:$PORT/testobj"
    ## curl -H "Content-Type: application/json" -X PUT -d '{"hello":999}' $URL
    ## curl $URL
}

DO_ALL() {
    CLEAN
    MINIKUBE_CACHE
    BUILD_ALL
    #BUILD $VERSION
    APPLY
    ACCESS
}

PREPA_DEMO() {
    minikube delete
    #minikube start --memory 4096
    minikube start --memory 3072
    BUILD_ALL
}

################################################################################
# Args:

ACTION=ALL

while [ ! -z "$1" ]; do
    case $1 in
        -x)    set -x;;
        +x)    set +x;;

        -pre*)   ACTION=PREPA_DEMO;;
        -c)      ACTION=CLEAN;;

        -ba)    ACTION=BUILD_ALL;;
        -b)     ACTION=BUILD;;
        -v[0-9]) VERSION=${1#-};;

        -curl) ACTION=ACCESS;;

        *) die "Unknown arg <$1>";;
    esac
    shift
done

################################################################################
# Main:

case $ACTION in
    PREPA_DEMO) PREPA_DEMO;;
    ACCESS) ACCESS;;
    BUILD_ALL) BUILD_ALL;;
    BUILD)  BUILD $VERSION;;

    ALL)    DO_ALL;;

    *) die "Unknown action <$ACTION>";;
esac

