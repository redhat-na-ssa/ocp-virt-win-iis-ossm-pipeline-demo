# ocp-virt-win-iis-ossm-pipeline-demo


## TODO:

- Leon: Create OSSM skeleton

### Install Windows Base Image

1. Copy the PKI entitlement key from the managed namespace (this is needed because we are using RHEL specific packages)
  ```
  oc get secret etc-pki-entitlement -n openshift-config-managed -o json | \
  jq 'del(.metadata.resourceVersion)' | jq 'del(.metadata.creationTimestamp)' | \
  jq 'del(.metadata.uid)' | jq 'del(.metadata.namespace)' | \
  oc -n openshift-virtualization-os-images create -f -
  ```
1. Create and build the getiso image
  ```
  oc create -f ./k8/win-base-pipeline/build-iso-fetcher.yaml 
  ```
1. Trigger a build to create the iso puller image
  ```
  oc start-build buildiso -n openshift-virtualization-os-images
  ```
1. Create the pipeline to generate the base windows iso
  ```
  oc apply -f ./k8/win-base-pipeline/windows-efi-installer-pipeline.yaml
  ```
1. Create the pipelinerun which will actually download the iso and build the base windows server golden image
  ```
  oc create -f ./k8/win-base-pipeline/windows-efi-installer-pipelinerun.yaml
  ```

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

### Create placeholder container deployment and VM with service mesh annotations (back-end)

`oc apply -f k8/deployments/vm/manifests -n demo-vm-ossm`

#### Container Deployement (front-end)
 
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

```
curl $GATEWAY/web/hello-service                               
{"response":{"message":"Hello World from vm-backend-b1"}}
```
This is calling the container deployment via the gateway. Internally this API is making a call to the back-end service running on the VM and passing the response from it back

```
   +-----------+       +----------------+       +-----------------------+       +-------------+  
   | API Caller | ---> | Ingress Gateway | ---> | Front-end Deployment  | --->  |  Back-end VM|  
   +-----------+       +----------------+       +-----------------------+       +-------------+  
         |                        |                        |                       |  
         |<-----------------------|<-----------------------|<----------------------|  
          (5) Response from       (4) Response from       (3) Call to VM          (2) Call to Front-end  
              Front-end to            VM to Front-end         from Front-end        from Ingress Gateway  
              API Caller  

(1) API Caller makes a call to the Ingress Gateway.
(2) The Ingress Gateway routes the call to the Front-end Deployment.
(3) The Front-end Deployment makes a call to the Back-end VM.
(4) The Back-end VM sends a response back to the Front-end Deployment.
(5) The Front-end Deployment sends the response from the Back-end VM to the API Caller.
```

### Eventually replace deployment and VM with new components
TODO
[windows deployment git repo](https://github.com/redhat-na-ssa/ocp-virt-win-iis-demo)   
[Windows Server 2022 ISO](https://www.microsoft.com/en-us/evalcenter/download-windows-server-2022)  

To deploy windows app directly from repo **(WARNING IN PROGRESS DOES NOT CURRENTLY WORK!!!)**:  

 ```
 # Configmap with sys-prep data <winserver-iis-sysprep>

 oc create -n demo-vm-ossm \
 -f https://raw.githubusercontent.com/redhat-na-ssa/ocp-virt-win-iis-demo/master/.openshift/winserver-iis-sysprep-configmap.yaml 

# Service for IIS API <solace-api>

oc create -n demo-vm-ossm \
-f https://raw.githubusercontent.com/redhat-na-ssa/ocp-virt-win-iis-demo/master/.openshift/winserver-iis-api-service.yaml

# The VM <winserver-iis> ISO location needs to be updated
oc create -n demo-vm-ossm \
-f https://raw.githubusercontent.com/redhat-na-ssa/ocp-virt-win-iis-demo/levy-ossm/.openshift/winserver-iis-virtualmachine.yaml
```

Note: The ISO will need to live somewhere accessible to the cluster

## Dale: Add CICD that deploys stack

### TODO
