echo "Deploy ingress-gateway"  

oc apply -f k8/service-mesh/istio/ingress-gateway.yaml -n istio-system

### Create Namespace for app

echo "Create a namespace/project called demo-vm-ossm which is where the control plane will be deployed."  
 
oc apply -f k8/deployments/namespace.yaml  

echo "Add namespace to ServiceMeshMemberRole"

oc apply -f k8/service-mesh/istio/service-mesh-member-role.yaml

echo "Create placeholder container deployment and VM with service mesh annotations (back-end)"

oc apply -f k8/deployments/vm/manifests -n demo-vm-ossm

echo "Container Deployement (front-end)"
 
oc apply -f k8/deployments/container/manifests -n demo-vm-ossm