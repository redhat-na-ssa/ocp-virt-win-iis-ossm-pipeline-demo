### Create Namespace for app

echo "Create a namespace/project called demo-vm-ossm which is where the control plane will be deployed."  
echo "" 
oc apply -f k8/deployments/namespace.yaml  
echo "" 
echo "Add namespace to ServiceMeshMemberRole"
echo "" 
oc apply -f k8/service-mesh/istio/service-mesh-member-role.yaml
echo "" 
echo "Create placeholder container deployment and VM with service mesh annotations (back-end)"
echo "" 
oc apply -f k8/deployments/vm/manifests -n demo-vm-ossm
echo "" 
echo "Container Deployement (front-end)"
echo "" 
oc apply -f k8/deployments/container/manifests -n demo-vm-ossm