# Demo Provisoning

This demo will utilize the demo.redhat.com platform.  You will need to have access and the ability to request a Red Hat Developer Hub Demo catalog item.

## Request Environment

1. Request https://demo.redhat.com/catalog?search=developer+hub&item=babylon-catalog-prod%2Fenterprise.red-hat-developer-hub-demo.prod
1. Login to OpenShift with provided credentials and then login to your local terminal

## Setup Demo Environment

You will need to run an ansible playbook to configure the additional items that will be required for this lab.

1. Login to OpenShift cli
1. Capture the oc login command from the console and run it in your terminal
1. Run the ansible playbook substituting the values for your root password from the demo.redhat.com console and the gitlab dns hostname as well
    ```
    cd ansible
    ansible-playbook --extra-vars "gitlab_host=gitlab-hostname-here" --extra-vars "root_password=gitlab-root-password-here" ./create_ocp_environment.yaml
    ```
