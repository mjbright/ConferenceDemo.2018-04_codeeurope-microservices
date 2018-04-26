
SCRIPT_DIR=$(dirname $0)

set -x
kubectl apply -f redis-deployment.yaml 
kubectl get pods

kubectl apply -f flask-deployment.yaml 
kubectl get pods

kubectl apply -f redis-service.yaml 
kubectl get svc

kubectl apply -f flask-service.yaml 
kubectl get svc

set +x

$SCRIPT_DIR/get_minikube_service_url.sh

