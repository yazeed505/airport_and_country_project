# Airport and Country services foodices

## Design Decisions and Chosen Technologies

In this project, two services can be deployed independently. The deployment process offers three options: using a kubectl YAML file, employing Ansible as Infrastructure as Code (IaC), and utilizing Helm charts for deployment with ArgoCD. The choice of these methods is based on specific considerations:

### 1. Kubectl YAML file:

- **Design Decision:**
  - **Reasoning:** The decision to use a kubectl YAML file is rooted in the need for a straightforward and direct approach to deploying Kubernetes resources.
  - **Advantages:**
    - **Simplicity:** This method is simple and easy to understand, making it accessible for developers and administrators.
    - **Direct Control:** Allows direct control over the deployment process with explicit resource definitions.

### 2. Ansible as IaC:

- **Design Decision:**
  - **Reasoning:** The choice of Ansible as Infrastructure as Code (IaC) is driven by the desire for a declarative and human-readable configuration for managing infrastructure.
  - **Advantages:**
    - **Declarative Configuration:** Ansible allows expressing the desired state of infrastructure, making it easier to understand and maintain.
    - **Automation:** Automation capabilities of Ansible reduce manual intervention, improving efficiency and reliability.

### 3. Helm chart with ArgoCD:

- **Design Decision:**
  - **Reasoning:** Helm charts with ArgoCD are chosen to implement a GitOps approach, ensuring a centralized source of truth for the application.
  - **Advantages:**
    - **GitOps Workflow:** GitOps provides a structured and version-controlled way to manage changes in the application.
    - **Centralized Source of Truth:** ArgoCD synchronizes with a Git repository, promoting consistency and traceability.

- **In the context of ArgoCD:**
  - **Reason for GitOps:**
    - **Reasoning:** Given the dynamic nature of the application and the potential for numerous changes, adopting a GitOps methodology becomes imperative.
    - **Advantages:**
      - **Consistency:** Ensures that all changes align with a singular source of truth, promoting a consistent deployment environment.
      - **Traceability:** Changes are tracked through version control, providing a history of modifications.
      - **Efficient Collaboration:** GitOps facilitates efficient collaboration among team members, as all changes are synchronized through a central repository.

These design decisions aim to balance simplicity, control, automation, and a structured approach to accommodate the specific needs of the project.

## **Note:**

Initially, my goal was to provision three virtual machines on my MacBook Pro M2 for the Vanilla Kubernetes cluster setup. Unfortunately, the hypervisor limitations on my MacBook Pro M2 limited the available virtualization options, posing a challenge to the seamless deployment of multiple virtual machines. To overcome this hurdle, I turned to Minikube, opting for a two-node configuration. Minikube's versatility allowed me to successfully accomplish the task, providing a practical solution within the constraints of my laptop's hypervisor compatibility.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Run minikube](#run-minikube)
- [Run bash script](#run-bash-script)
- [Deploy using services ](#kubectl-apply)
- [Helm Charts with ArgoCD](#helm-charts-with-argocd)

## Prerequisites

Ensure you have the following dependencies installed:

- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [Helm](https://helm.sh/docs/intro/install/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)

### Run minikube

1. Run minikube command start with two node and name cluster foodices:

    ```bash
    sudo minikube start --nodes 2 -p foodices
    ```

2. Enable ingress nginx with minikube:

    ```bash
    sudo minikube addons enable ingress -p foodices
    ```
### Run bash script
1. Ensure you are in the root of the repo directory
2. This bash script automate build, tag, and push docker images. Also, it is updated tag in the values.yaml for helm in order to automate the whole process with Argocd later for now just run the below commands:
    ```bash
    bash countries/countries.sh
    ```
    ```bash
    bash airports/airports.sh
    ```
### Kubectl apply

1. Ensure you are in the root of the repo directory

2. Run yaml file for airports:

    ```bash
    kubectl apply -f airports/deploy-airports.yaml
    ```
3. Run yaml file for countries:

    ```bash
    kubectl apply -f countries/deploy-countries.yaml
    ```
4. Check pods are running:
    ```bash
    kubectl get po -n airports
    ```
    ```bash
    kubectl get po -n countries
    ```
5. In a different terminal window, run this command to open a tunnel in your local machine.
    ```bash
    sudo minikube tunnel -p foodices
    ```
6. Now go the browser and check the two services are running ([http://127.0.0.1/countries](http://127.0.0.1/countries)) and [http://127.0.0.1/airports](http://127.0.0.1/airports))


### Deployment with ansible
1. Ensure you are in the root of the repo directory

2. Run yaml file for airports:

    ```bash
    ansible-playbook airports/deploy-airports-anisble.yml
    ```
3. Run yaml file for countries:

    ```bash
    ansible-playbook countries/deploy-countries-anisble.yml
    ```
4. Check pods are running:
    ```bash
    kubectl get po -n airports
    ```
    ```bash
    kubectl get po -n countries
    ```
5. If the tunnel is still open then skip otherwise you have to run it again.
    ```bash
    sudo minikube tunnel -p foodices
    ```
6. Now go the browser and check the two services are running ([http://127.0.0.1/countries](http://127.0.0.1/countries)) and [http://127.0.0.1/airports](http://127.0.0.1/airports))
### Helm Charts with ArgoCD

1. Install ArgoCD:

    ```bash
    ansible-playbook argocd/argocd.yml
    ```

2. Ensure all the pods are up and running:

    ```bash
    kubectl get pods -n argocd
    ```
3. In differenet terminal, portforward argocd:

    ```bash
    kubectl port-forward svc/argocd-server -n argocd 8080:443
    ```
4. Go to [https://localhost:8080](https://localhost:8080)
5. username is ' admin ' and the password would be the output of below commands:
    ```bash
    kubectl get secrets -n argocd argocd-initial-admin-secret -ojsonpath={'.data.password'} | base64 -d ; echo ""
    ```
6. Run the following commands to automate deploying the argocd application + adding repository.
    ```bash
    ansible-playbook argocd/applications.yml 
    ```
7. Now you can see the application are appearing and if they are not synced, you can sync them.

### END OF PROJECT AND THANKS