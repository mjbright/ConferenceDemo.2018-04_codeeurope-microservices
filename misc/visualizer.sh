
# See here for info on 'kubectl proxy' command:
#   https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#proxy

#kubectl proxy --www=/Users/mjb/src/git/brendandburns.gcp-live-k8s-visualizer --www-prefix=/my-mountpoint/ --api-prefix=/api/

#SRC_DIR=~/src/git/brendandburns.gcp-live-k8s-visualizer
SRC_DIR=~/src/git/mjbright.live-k8s-visualizer

if [ "$1" = "." ];then
    SRC_DIR=$PWD
fi

if [ "$1" = "-l" ];then
    SRC_DIR=~/src/git/larrycai.gcp-live-k8s-visualizer
fi


#kubectl proxy --www=$SRC_DIR --www-prefix=/ --api-prefix=/api/ --port 8001
#kubectl proxy --www=$SRC_DIR --www-prefix=/viz --api-prefix=/api/
set -x
kubectl proxy --www=$SRC_DIR --www-prefix=/ --api-prefix=/api/
set +x

