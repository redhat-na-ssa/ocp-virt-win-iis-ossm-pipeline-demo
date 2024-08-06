export GATEWAY=$(oc get route istio-ingressgateway -n istio-system -o template --template '{{ .spec.host }}')

echo "ingress-gateway route:"
echo $GATEWAY 


echo "Call the front-end service (the container based deployment)"
echo "" 
curl $GATEWAY/web/hello
echo ""
echo ""
echo "Call the back-end service via the front-end"  
echo ""
curl $GATEWAY/web/hello-service   
echo ""    
