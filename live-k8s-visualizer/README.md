## Kubernetes/Container Engine Visualizer

This is a simple visualizer for use with the Kubernetes API.

It is a clone of https://github.com/brendandburns/gcp-live-k8s-visualizer
(not a fork as I already forked a descendant fork)

### Usage:
   * First install a Kubernetes or Container Engine Cluster
   * ```git clone https://github.com/mjbright/live-k8s-visualizer.gite``
   * ```kubectl proxy --www=path/to/live-k8s-visualizer --www-prefix=/my-mountpoint/ --api-prefix=/api/```

Then

    http://127.0.0.1:8001/my-mountpoint/

E.g.

    ```kubectl proxy --www=path/to/live-k8s-visualizer --www-prefix=/ --api-prefix=/api/```

    http://127.0.0.1:8001/

That's it.  The visualizer uses labels to organize the visualization.  In particular it expects that

   * pods, replicationcontrollers, and services have a ```name``` label, and pods and their associated replication controller share the same ```name```, and
   * the pods in your cluster will have a ```uses``` label which contains a comma separated list of services that the pod uses.
