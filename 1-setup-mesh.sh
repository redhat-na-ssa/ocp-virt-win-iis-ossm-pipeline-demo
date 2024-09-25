echo "1. Create a namespace/project called istio-system which is where the control plane will be deployed."  
 
oc apply -f k8/service-mesh/istio/namespace.yaml 

echo "2. Deploy a control plane in istio-system"  

oc apply -f k8/service-mesh/istio/service-mesh-controle-plane.yaml

echo "Ensure mesh has been successfully deployed"

echo "Waiting for Kiali pod to be ready..."

# Loop until the Kiali pod is in the Running state with a status of 1/1
while true; do
    kiali_status=$(oc get pods -n istio-system -l app=kiali -o jsonpath='{.items[0].status.containerStatuses[0].ready}')
    
    if [ "$kiali_status" == "true" ]; then
        echo "Kiali pod is ready."
        break
    else
        echo "Waiting for Kiali pod to be ready..."
        sleep 5
    fi
done

oc get pods -n istio-system

echo "Deploying ingress-gateway"  

oc apply -f k8/service-mesh/istio/ingress-gateway.yaml -n istio-system