echo "1. Create a namespace/project called istio-system which is where the control plane will be deployed."  
 
oc apply -f k8/service-mesh/istio/namespace.yaml 

echo "2. Deploy a controle plane in istio-system"  

oc apply -f k8/service-mesh/istio/service-mesh-controle-plane.yaml

echo "Ensure mesh has been successfully deployed with the following pods"
sleep 3


watch oc get pods -n istio-system  

# Ctrl-C once all pods are up (there should be 7) KEEP AN EYE OUT FOR KIALI!!!!!!

# NAME                                    READY   STATUS    RESTARTS   AGE
# grafana-58d67499c4-67jhs                2/2     Running   0          108s
# istio-egressgateway-5d577ccdff-k7nbc    1/1     Running   0          108s
# istio-ingressgateway-75554d57b4-tqxmz   1/1     Running   0          108s
# istiod-basic-57dfdc6cf-9n6x6            1/1     Running   0          2m13s
# jaeger-6dbc9b8f95-tbzrg                 2/2     Running   0          105s
# kiali-cbf4cbb84-dgfsw                   1/1     Running   0          72s
# prometheus-6769665b64-6pb6g             3/3     Running   0          2m4s

echo "Is kiali running?"
oc get pods -n istio-system | grep kiali

echo "Deploy ingress-gateway"  

oc apply -f k8/service-mesh/istio/ingress-gateway.yaml -n istio-system