
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

press "About to create redis-deployment"
kubectl create -f redis-deployment.yaml

press "About to create redis-service"
kubectl create -f redis-service.yaml

press "About to create flask-deployment"
kubectl create -f flask-deployment.yaml

press "About to create flask-service"
kubectl create -f flask-service.yaml


