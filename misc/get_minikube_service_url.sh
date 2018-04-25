
IP=$(minikube ip)

SERVICE=${1:flask-app}
export NODE_PORT=$(kubectl get services/flask-app -o go-template='{{(index .spec.ports 0).nodePort}}') 
SERVICE_URL=http://${IP}:$NODE_PORT 
echo $SERVICE_URL

#SERVICE_URL=${IP}:$NODE_PORT 
#echo http://$SERVICE_URL

PRES_DIR=~/z/www/REMARK/2018-Apr-23_CodeEurope_DevMicroServicesWithKubernetes

sed "s|SERVICE_URL|$SERVICE_URL|g" \
    < $PRES_DIR/demo.html.template \
    > $PRES_DIR/demo.html

# So decktape takes index.html (most recent html) as entry point:
touch $PRES_DIR/demo.html

# kubectl get service flask-app -o go-template --template="{{.spec.ports}}"

exit 0

# Basic example here:
#   https://gist.github.com/so0k/42313dbb3b547a0f51a547bb968696ba#golang-templates

https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands

https://stackoverflow.com/questions/37648553/is-there-anyway-to-get-the-external-ports-of-the-kubernetes-cluster

https://medium.com/google-cloud/bash-hacks-gcloud-kubectl-jq-etc-c2ff351d9c3b

kubectl get pods \
--output=go-template='{{range .items}}{{.metadata.name}}
{{end}}'

