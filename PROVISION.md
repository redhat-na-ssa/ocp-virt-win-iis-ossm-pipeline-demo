# ocp-virt-win-iis-ossm-pipeline-demo

## Instructions Overview

These are the steps needed to set up and run this demo. Detailed instructions follow:

1. Provision `Red Hat Developer Hub Demo` from Red Hat Demo Platform
2. Upload templates to RHDH and create base app images (container and VM)
3. Enable OpenShift Service Mesh Operators (multiple)
4. Create Service Mesh Control Plane (`istio-system`)

## Instructions Detail

### Provision `Red Hat Developer Hub Demo` from Red Hat Demo Platform

1. Provision the following Demo from Red Hat Demo Platform
- [Link to order demo](https://demo.redhat.com/catalog?item=babylon-catalog-prod/enterprise.red-hat-developer-hub-demo.prod)

2. Login to OpenShift cli using the provided credentials from the Developer Hub Access Demo details

```bash
Example: 

oc login -u admin -p 12345 https://api.cluster-abcd.abcd.sandbox42069.opentlc.com:6443    

Login successful.

You have access to 88 projects, the list has been suppressed. You can list all projects with 'oc projects'

Using project "default". 
```
- Once provisioned, note the URL and Password for gitlab
example (you will use this info later):

```bash
export GITLAB_HOST=$(oc get route/gitlab -n gitlab -o jsonpath={.spec.host})
export GITLAB_PASSWORD=$( oc get secret gitlab-secret -n gitlab  --template={{.data.GITLAB_ROOT_PASSWORD}} | base64 -d)
```

### Upload templates to RHDH and create base app images (container and VM)

### Prereqs
1. Ansible cli is installed on your local workstation
2. `PyYAML` python library is installed on your local workstation
3. `kubernetes` python library is installed on your local workstation
4. `typing-extension` python library is installed on your local workstation

```bash
python3.11 -m venv .venv
source .venv/bin/activate
pip install -r ./ansible/requirements.txt
```

### Steps

You will need to run an ansible playbook to configure the additional items that will be required for this demo.

 
Run the ansible playbook substituting the values for your root password from the demo.redhat.com console and the gitlab dns hostname as well

 ```bash
 cd ansible
 ansible-playbook --extra-vars "gitlab_host=${GITLAB_HOST}" --extra-vars "root_password=${GITLAB_PASSWORD}" ./create_ocp_environment.yaml
```

**Notes:** 
- Do not include `https://` in the `GITLAB_HOST` variable
- If you see a python error when running the playbook, add the following env variable to the `ansible-playbook` command:

```bash
-e 'ansible_python_interpreter=$(which python3.11)’
```


This playbook will create two pinelines/pipeline runs

1. namespace `openshift-virtualization-os-images` - pipeline run `windows-efi-installer`
2. namespace `build-dotnet` - pipeline run `solacetk-ui`

Wait for these pipelineruns to complete before proceeding to the next steps.  
`windows-efi-installer` can take awhile to complete... go get some coffee... take the dog for a walk, etc...    
It took 38 minutes last time I waited for completion.

![OpenShift console view of PRs](image01.png)


