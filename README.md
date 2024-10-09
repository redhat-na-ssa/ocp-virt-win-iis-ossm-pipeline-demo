# ocp-virt-win-iis-ossm-pipeline-demo


See `PROVISION.md` for instructions on setting up the demo environment

## Use RHDH to deploy application stack [DEMO SCRIPT]

This involves clicking "create" filling out three templates `Project`, `IIS Web Application` and `IIS Frontend Application` (in that order). 

Before proceeding, be sure that the pipeline run `windows-efi-installer` mentioned earlier has completed successfully.  

### Steps:
1. Log into Developer Hub using your userX gitlab credentials (provided vi demo hub)

2. **Launch Developer Hub Console and create 'Project`**  

![Project Template](image02.png)  

   - Log in as `user1`.
   - Click "Create" and select the `Project` catalog item.
   - Fill out the `Project` template:
     - **Component Name**: Provide a name for the new component.
     - **Owner**: Set this to `group:user1`.
     - **GitLab URL**: Enter your GitLab URL without the `https://` prefix.
     - **Development Item**: Leave this as the default value.
   - Complete the template setup.  
![example "Project" form values](image.png)  
  

3. **Create IIS Web Application**:  

![Windows IIS Application Template](image-1.png)  

   - After the `Project` template is provisioned, create an `IIS Web Application` using the corresponding catalog item.
   - Keep defaults for all the steps
   - This application can take a few minutes to be up and running (15+ minutes sometimes)

4. **Create Frontend Application**:  

![IIS Frontend Application Template](image-2.png)  

   - After the `IIS Web Application` template is provisioned, create an `IIS Frontend Application` using the corresponding catalog item.
   - Choose the backend you created in step 2
   - Keep defaults for IIS deployment options step


5. **Sync with ArgoCD**:  

![ArgoCD view](image-3.png)  

   - Wait for ArgoCD to automatically sync, or manually trigger the sync from the ArgoCD console.

## Validate application access  

1.  Locate the new project in the OpenShift console. For instance, if the project name is `test`, you will find a `test-dev` project.

2. verify front end is up with and accessible via the `istio-ingressgateway` route - this will run even if the backend is down, but will only display red status circles. They will show up as green if the backend is up.

```bash
export GATEWAY=$(oc get route istio-ingressgateway -n istio-system -o template --template '{{ .spec.host }}')

echo $GATEWAY 
curl -o /dev/null -s -w "%{http_code}\n" $GATEWAY

```

(example output:)
```bash
istio-ingressgateway-istio-system.apps.cluster-nqwzb.nqwzb.sandbox1400.opentlc.com
200 # <- http return code
```
**Note:** If the return code is not `200`, something is not right

3. Access the front end webpage using the `$GATEWAY` URL in a browser (note: `http` not `https`)  

![Web Page](image-4.png)  

If the status shows green next to `Service` and `Data`, then the front end is successfully communicating with the IIS service running on the VM.

4. Check istio connectivity in Kiali

- Go to the topology view of your namespace and click the `Kiali` link in the upper right corner
  
![Topology view](image-5.png)  

- View the flow of traffic in the `Graph` view in Kiali
  
![Kiali](image-6.png)  