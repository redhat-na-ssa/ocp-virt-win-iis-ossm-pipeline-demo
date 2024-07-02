# ocp-virt-win-iis-ossm-pipeline-demo


## TODO:

- Leon: Create OSSM skeleton

### Install OSSM operators

*(Assumes the OpenShift Virtualization operator has already been installed and is up and running)*  

To install Red Hat OpenShift Service Mesh, you must install the Red Hat OpenShift Service Mesh Operator. Repeat the procedure for each additional Operator you want to install.

Additional Operators include:

- Kiali Operator provided by Red Hat

- Red Hat OpenShift distributed tracing platform provided by Red Hat  
 
(Note: *Red Hat OpenShift distributed tracing* will need to be replaced with the *Tempo Operator* down the road)


### Create Service Mesh control plane

1. Create a namespace/project called `istio-system` which is where the control plane will be deployed.  
 
 `oc apply -f k8/service-mesh/istio/namespace.yaml`  

2. Deploy a controle plane in `istio-system`  

`oc apply -f k8/service-mesh/istio/service-mesh-controle-plane.yaml`  

Ensure mesh has been successfully deployed with the following pods

`oc get pods -n istio-system`     
```                                                                                            
NAME                                    READY   STATUS    RESTARTS   AGE
grafana-5b984fffd5-hn6mv                2/2     Running   0          2m45s
istio-egressgateway-5d577ccdff-qwslr    1/1     Running   0          2m46s
istio-ingressgateway-75554d57b4-z5qsl   1/1     Running   0          2m46s
istiod-basic-57dfdc6cf-nfsml            1/1     Running   0          3m14s
jaeger-77d67b7fdb-tq8fc                 2/2     Running   0          2m43s
kiali-66499d5bcf-jrrlp                  1/1     Running   0          118s
prometheus-749fd69c7-vzczn              3/3     Running   0          3m3s
```
3. Deploy ingress-gateway  

`oc apply -f k8/service-mesh/istio/ingress-gateway.yaml -n istio-system`

### Create Namespace for app

Create a namespace/project called `demo-vm-ossm` which is where the control plane will be deployed.  
 
 `oc apply -f k8/deployments/namespace.yaml`  

### Add namespace to ServiceMeshMemberRole

`oc apply -f k8/service-mesh/istio/service-mesh-member-role.yaml`

### Create placeholder container deployment and VM with service mesh annotations

#### Container Deployement

`oc apply -f k8/deployments/container/manifests -n demo-vm-ossm`

### Ensure setup is working
1. Get the ingress-gateway URL

```
export GATEWAY=$(oc get route istio-ingressgateway -n istio-system -o template --template '{{ .spec.host }}')

echo $GATEWAY                                                                                                

istio-ingressgateway-istio-system.apps.cluster-phx5k.dynamic.redhatworkshops.io
```
2. Call the front-end service (the container based deployment)
  
  Returns from the local front-end service without makeing any backend calls

```
curl $GATEWAY/web/hello
{"message":"Hello World from web-front-end"}
```

3. Call the back-end service via the front-end  
 TODO

### Eventually replace deployment and VM with new components
TODO



## Dale: Add CICD that deploys stack

### TODO
