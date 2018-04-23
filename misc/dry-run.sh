
# From:
#   https://github.com/dabcoder/k8s-dd-minikube

#
# Function: press <prompt>
# Prompt user to press <return> to continue
# Exit if the user enters q or Q
#
press()
{
    echo
    [ ! -z "$1" ] && echo "$*"
    echo "Press <return> to continue"
    read _DUMMY
    [ "$_DUMMY" = "q" ] && exit 0
    [ "$_DUMMY" = "Q" ] && exit 0
}

IMAGE=mjbright/flask-web:v1

press "About to --dry-run -o yaml > flask-deploy.yaml"
kubectl run flask-app --image=$IMAGE --port=5000 \
    --dry-run -o yaml > flask-deploy.yaml

press "About to --dry-run -o yaml > redis-deploy.yaml"
kubectl run redis --image=redis:latest --port=6379 \
    --dry-run -o yaml > redis-deploy.yaml

press "About to deploy flask and redis from yaml files"
kubectl create -f flask-deploy.yaml
kubectl create -f redis-deploy.yaml

press "About to --dry-run -o yaml > flask-service.yaml"
kubectl expose deployment flask-app --type=LoadBalancer \
    --dry-run -o yaml > flask-service.yaml

press "About to --dry-run -o yaml > redis-service.yaml"
kubectl expose deployment redis --type=LoadBalancer \
    --dry-run -o yaml > redis-service.yaml

press "About to expose flask and redis from yaml files"
kubectl create -f flask-service.yaml
kubectl create -f redis-service.yaml

exit 0



Start minikube and use its Docker daemon:
minikube start
...

eval $(minikube docker-env)
Build the web app Docker image
cd in the web directory. Then run:

docker build -t web-flask:v1 .

Create a Deployment that manages a Pod that runs a Container based on the web-flask:v1 Docker image:
Flask uses the port 5000 by default.

kubectl run web-flask --image=web-flask:v1 --port=5000


Pull the latest Redis Docker image
docker pull redis:latest
Create a Deployment that manages a Pod that runs a Container based on the redis:latest Docker image:
Redis will use the port 6379.

kubectl run redis --image=redis:latest --port=6379


Create Services
kubectl expose deployment web-flask --type=LoadBalancer
kubectl expose deployment redis --type=LoadBalancer


Run the web app
minikube service web-flask



