# Demo Provisoning

This demo will utilize the demo.redhat.com platform.  You will need to have access and the ability to request a Red Hat Developer Hub Demo catalog item.

## Prereqs
1. Ansible cli is installed on your local workstation
2. `PyYAML` python library is installed on your local workstation
3. `kubernetes` python library is installed on your local workstation
4. `typing-extension` python library is installed on your local workstation

```
python3.11 -m pip install PyYAML
python3.11 -m pip install kubernetes
python3.11 -m pip install typing-extensions
```

## Request Environment

1. Request https://demo.redhat.com/catalog?search=developer+hub&item=babylon-catalog-prod%2Fenterprise.red-hat-developer-hub-demo.prod
2. Login to OpenShift web console with provided credentials and then login via the CLI in your local terminal
3. Make note of the gitlab `URL` `USERNAME` and `PASSWORD` from the Developer Hub Access Demo details

## Setup Demo Environment

You will need to run an ansible playbook to configure the additional items that will be required for this lab.

1. Login to OpenShift cli using the provided credentials from the Developer Hub Access Demo details

```
Example: 

oc login -u admin -p 12345 https://api.cluster-abcd.abcd.sandbox42069.opentlc.com:6443    

Login successful.

You have access to 88 projects, the list has been suppressed. You can list all projects with 'oc projects'

Using project "default". 
```
 
2. Run the ansible playbook substituting the values for your root password from the demo.redhat.com console and the gitlab dns hostname as well
    ```
    cd ansible
    ansible-playbook --extra-vars "gitlab_host=<gitlab-hostname-here>" --extra-vars "root_password=<gitlab-root-password-here>" ./create_ocp_environment.yaml
    ```

Note: Do not include `https://` in the `gitlab_host` variable

## Create Windows IIS App
1. Launch the Developer Hub console and click "create" and select the "Project" catalog item (logged in as a user1).
- When filling out the template, provide: a name for the new comoponent, set the "Owner" as `group:user1`

2. Once completed create an IIS Web Application catalog item.
3. Use the defaults except for putting in the gitlab url (without `https://`) for your environment on step 2.  Leave the development item as the default.
4. Once complete either wait for the argocd to sync or manually trigger the sync from the argo console.
5. Find the new project in OpenShift for example if the project name was test you will find a test-dev project in your OpenShift console and get the network route to test that the vm is routing traffic correctly.