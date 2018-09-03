# codeeurope-microservices

Microservice/Kubernetes examples used in my 2018-Apr presentations at CodeEurope,
Warsaw and Wroclaw.

Refer to [https://mjbright.github.io/Talks/index.html#codeeu_2018](https://mjbright.github.io/Talks/index.html#codeeu_2018) for the slides and other information about that talk.

The demo at Wroclaw was run on a Mac AirBook Pro using
- minikube as a single-node Kubernetes cluster
- a hacked up dashboard allowing to integrate a test button & output, a shell console and a visualization of the cluster
    - ttyd to provide a web console, useful for typing commands without having to change browser window (installed via homebrew)
    - live-8s-visualizer (see below)
    - a simple Flask/Redis counter application

The demo has also been tested/documented on
- Windows10 using Docker Desktop to provide the Kubernetes cluster, using a MSYS2 buid of ttyd.
- Ubuntu 18.04.1 LTS

A revised version will be available after Pyconfr, Lille happening in October 2018.

#### Launch ttyd

```
cd live-k8s-visualizer/
launch_ttyd.sh -r
```
### live-k8s-visualizer

Contains a local copy of my fork of Brendan Burns' K8S visualizer integrated into my demos.

# To run the demos:

## Setup steps

### Create your own Kubernetes cluster.

It is recommended to use minikube for this.

Type ```minikube start``` to start the cluster, this may take some time especially if it is necessary to download the iso and associated containers over a slow network.

Once finished check that you can access your cluster using kubectl:
    ```kubectl get nodes```
you should see something like:
    ```NAME       STATUS    ROLES     AGE       VERSION
minikube   Ready     master    15m       v1.10.0```

### Create the "demo dashboard"

#### [optional] Installing/running ttyd
To run the dashboard you optionally require the ttyd daemon installed (to allow to type console commands locally in the browser window).

Executables are readily available for Linux and MacOS on the [release page](https://github.com/tsl0922/ttyd/releases).  On Windows you will first need to install MSYS2 and then compile your own executable, instructions are provided for this [here](https://github.com/tsl0922/ttyd/tree/master/msys2).

I would have made a Windows executable available but I only have a dynamically linked executable, ... 

Once you have ttyd available launch the executable.
Note: we are launching ttyd without any special security ... be careful, you may want to investigate use of https.

You can open the dashboard in your browser either using
- file protocol
- or via a local web server

In my case under Windows I had the files under
- [cygwin path] ```/home/windo/src/git/GIT_mjbright/codeeurope-microservices```
- [DOS path] ```C:\tools\cygwin\home\windo\src\git\GIT_mjbright\codeeurope-microservices```

#### Create the "demo dashboard" page
```
cd live-k8s-visualizer/
./create_demo_html.sh
```

#### Accessing the *demo dashboard* using local files:
I can access the *demo dashboard* in my browser using:
```
    file:///C:/tools/cygwin/home/windo/src/git/GIT_mjbright/codeeurope-microservices/demo.html
```

Alternatively I could launch a web server, e.g. using Python3, from the codeeurope-microservices repo directory as such:
```
    cd C:/tools/cygwin/home/windo/src/git/GIT_mjbright/codeeurope-microservices/

    python3 -m http.server 8000 --bind 127.0.0.1
```

to serve up files just on the same machine, or if you want to access from another machine:
```
/usr/bin/python3 -m http.server 8000 --bind 0.0.0.0
```

#### Accessing the *demo dashboard* using a web server:
You can now open your browser at
```http://127.0.0.1:8000/live-k8s-visualizer/demo.sh```

Replace ```127.0.0.1``` by the remote ip if running on a different machine

### visualizer:

#### In a separate terminal window launch the visualizer:
```
cd live-k8s-visualizer/
./visualize.sh
```

Note: if accessing remotely run with the '-r' option:
```
cd live-k8s-visualizer/
./visualize.sh -r
```




### Slides

You can refer to the [presentation slides](https://mjbright.github.io/Talks/2018-Apr-26_CodeEurope_DevMicroServicesWithKubernetes/) to see the commands used.

PDF available [here](https://mjbright.github.io/Talks/2018-Apr-26_CodeEurope_DevMicroServicesWithKubernetes/2018-Apr-26_CodeEurope_DevMicroServicesWithKubernetes.pdf)

The demo steps are described from [slide#23](https://mjbright.github.io/Talks/2018-Apr-26_CodeEurope_DevMicroServicesWithKubernetes/#43) onwards.



