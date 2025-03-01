# ASCN_TP - Ghost Blog Deployment on Google Kubernetes Engine (GKE)

## Overview

This repository contains the Ansible playbooks and configurations used to
automate the deployment and management of a Ghost blogging platform on Google
Kubernetes Engine (GKE). This project was developed as part of my 4th-year
university coursework, demonstrating proficiency in Infrastructure as Code
(IaC), container orchestration, and cloud deployment strategies.

The project showcases the ability to:

- Provision and manage a GKE cluster using Ansible.
- Deploy a multi-component application (Ghost blog with a MySQL database) on
  Kubernetes.
- Automate secret management using Ansible Vault.
- Implement monitoring and alerting using Google Cloud Operations Suite
  (formerly Stackdriver).
- Perform load testing using JMeter.
- Automate application lifecycle management (deployment, scaling, and
  undeployment).

## Key Skills Demonstrated

- **Ansible:** Playbook creation, task automation, templating, and Vault for
  secret management.
- **Google Kubernetes Engine (GKE):** Cluster provisioning, deployment
  management, and scaling.
- **Kubernetes:** Deployment configuration (Deployments, Services, Persistent
  Volume Claims), Horizontal Pod Autoscaling (HPA).
- **Google Cloud Platform (GCP):** Experience with GCP services (Compute Engine,
  Kubernetes Engine, Cloud Operations).
- **Monitoring and Alerting:** Implementation of monitoring dashboards and alert
  policies using Google Cloud Operations Suite.
- **Load Testing:** Using JMeter to assess application performance under load.
- **Infrastructure as Code (IaC):** Automating infrastructure provisioning and
  application deployment using Ansible.
- **YAML:** Proficient in writing YAML configurations for Ansible and
  Kubernetes.
- **Shell Scripting:** Utilized in various automation tasks within Ansible
  playbooks.

## Architecture

The deployment architecture consists of the following components:

- **GKE Cluster:** A managed Kubernetes cluster on Google Cloud Platform.
- **Ghost Blog:** The Ghost blogging platform, deployed as a containerized
  application on Kubernetes.
- **MySQL Database:** A MySQL database, also deployed as a containerized
  application on Kubernetes, used to store Ghost blog data.
- **Load Balancer:** A Google Cloud Load Balancer that exposes the Ghost blog to
  the internet.
- **Google Cloud Operations Suite:** Used for monitoring the GKE cluster, Ghost
  application, and underlying infrastructure.

```
+---------------------+      +---------------------+
|  User (Web Browser) |------>|  GCP Load Balancer  |
+---------------------+      +---------------------+
                            ^
                            |
                            | (External IP)
+---------------------+      +---------------------+
|   GKE Cluster       |------>|  Ghost Deployment   |
| (Nodes & Pods)      |      |  (Kubernetes Pods)  |
+---------------------+      +---------------------+
                            |
                            | (Internal Service)
+---------------------+      +---------------------+
|   MySQL Deployment  |------>|  MySQL Pod          |
|   (Kubernetes Pod)  |      |  (Database Server)  |
+---------------------+      +---------------------+
```

## Repository Structure

```
ASCN_TP/
├── .gitignore                      # Specifies intentionally untracked files that Git should ignore
├── ansible.cfg                     # Ansible configuration file
├── create-gke-cluster.yml          # Ansible playbook to create a GKE cluster
├── deploy-ghost.yml                # Ansible playbook to deploy Ghost
├── destroy-gke-cluster.yml         # Ansible playbook to destroy a GKE cluster
├── inventory/
│   └── gcp.yml                     # Ansible inventory file with GKE and app variables
├── LICENSE                         # GNU General Public License v3
├── monitoring.yml                  # Ansible playbook for monitoring setup
├── README.md                       # This file
├── roles/
│   ├── deploy-ghost/               # Ansible role to deploy Ghost
│   │   ├── files/
│   │   │   └── .gitignore          # Ignore specific files in the deploy-ghost files directory
│   │   ├── tasks/
│   │   │   └── main.yml             # Main tasks for deploying Ghost
│   │   ├── templates/
│   │   │   ├── deployment.yaml.tpl  # Template for Ghost and DB deployment
│   │   │   ├── deployment_service.yaml.tpl # Template for deployment service
│   │   │   └── mysql-pvc.yml.tpl    # Template for MySQL Persistent Volume Claim
│   ├── gke_cluster_create/          # Ansible role to create a GKE cluster
│   │   └── tasks/
│   │       └── main.yml             # Main tasks for creating the GKE cluster
│   ├── gke_cluster_destroy/         # Ansible role to destroy a GKE cluster
│   │   └── tasks/
│   │       └── main.yml             # Main tasks for destroying the GKE cluster
│   ├── jmeter/                     # Ansible role for load testing with JMeter
│   │   ├── files/
│   │   │   ├── .gitignore          # Ignore specific files in the jmeter files directory
│   │   ├── tasks/
│   │   │   └── main.yml             # Main tasks for running JMeter
│   │   ├── templates/
│   │   │   └── Stress test frontend.jmx.tpl # Template for JMeter test plan
│   ├── kube-secrets/               # Ansible role to manage Kubernetes secrets
│   │   ├── files/
│   │   │   └── .gitignore          # Ignore all files except .gitignore in the kube-secrets files directory
│   │   ├── tasks/
│   │   │   └── main.yaml            # Main tasks for managing Kubernetes secrets
│   │   ├── templates/
│   │   │   └── secrets.yaml.tpl     # Template for Kubernetes secrets
│   ├── monitoring/                 # Ansible role for setting up monitoring
│   │   ├── files/
│   │   │   ├── .gitignore          # Ignore specific files in the monitoring files directory
│   │   ├── tasks/
│   │   │   └── main.yml             # Main tasks for setting up monitoring
│   │   ├── templates/
│   │   │   ├── dashboard/            # Templates for monitoring dashboards
│   │   │   │   └── network_dashboard.json.tpl # Template for network dashboard
│   │   │   │   └── resource_dashboard.json.tpl # Template for resource dashboard
│   │   │   └── policy/               # Templates for monitoring policies
│   │   │   │   └── policy_cpuload.json.tpl # Template for CPU load policy
│   │   │   │   └── policy_diskIO.json.tpl # Template for disk I/O policy
│   │   │   │   └── policy_freememory.json.tpl # Template for free memory policy
│   ├── test_ghost/                 # Ansible role to test Ghost deployment
│   │   └── tasks/
│   │       └── main.yml             # Main tasks for testing Ghost deployment
│   ├── undeploy-ghost/             # Ansible role to undeploy Ghost
│   │   └── tasks/
│   │       └── main.yml             # Main tasks for undeploying Ghost
│   └── undeploy-pv/                # Ansible role to undeploy Persistent Volumes
│       └── tasks/
│           └── main.yml             # Main tasks for undeploying Persistent Volumes
├── service_keys/
│   └── .gitignore                  # Prevents accidental check-in of sensitive service keys
├── stress-test.yml                 # Ansible playbook for stress testing
├── test-all.yml                    # Ansible playbook for complete testing
└── undeploy-ghost.yml              # Ansible playbook to undeploy Ghost

```

## Setup and Usage

**Prerequisites:**

- Google Cloud Platform account.
- [Google Cloud SDK (gcloud)](https://cloud.google.com/sdk/docs/install)
  installed and configured.
- [Ansible](https://docs.ansible.com/get_started/installation.html) installed.
- [JMeter](https://jmeter.apache.org/download_jmeter.cgi) installed (if you want
  to run load tests).
- Python 3 installed.
- `kubectl` installed.

**Configuration:**

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/MrZeLee/ASCN_TP.git
    cd ASCN_TP
    ```

2.  **Set up GCP credentials:**

    - Create a service account in your GCP project with the necessary
      permissions (Kubernetes Engine Admin, Compute Engine Admin, Monitoring
      Admin).
    - Download the service account key file in JSON format and place it in the
      `service_keys/` directory.
    - Update the `inventory/gcp.yml` file with your GCP project ID and the path
      to your service account key file.

    **Security Note:** The `service_keys/` directory contains sensitive
    credentials. Ensure this directory is properly secured with appropriate file
    permissions and is never committed to a public repository. Consider adding
    it to your `.gitignore` file.

3.  **Configure Ansible Vault:**

    - Create a vault password file:

      ```bash
      echo "your_vault_password" > service_keys/vault_password
      ```

    - Encrypt the sensitive data in `inventory/gcp.yml` using Ansible Vault:

      ```bash
      ansible-vault encrypt inventory/gcp.yml
      ```

4.  **Update Inventory Variables:**

    - Edit the `inventory/gcp.yml` file and update the following variables:
      - `gcp_project`: Your Google Cloud Project ID.
      - `gcp_zone`: The GCP zone where you want to deploy the cluster.
      - `gcp_machine_type`: The machine type for the GKE nodes.
      - `admin_user`: The desired username for the Ghost administrator account.
      - `admin_password`: The desired password for the Ghost administrator
        account.
      - `admin_email`: The desired email for the Ghost administrator account.
      - `mailgun_domain`, `mailgun_api_key`, `mailgun_base_url`: If you want to
        configure email sending, provide your Mailgun credentials. Otherwise,
        Ghost will be configured without email.
    - The `ghost_ip` and `ghost_port` are automatically updated by the script to
      the LoadBalancer public IP.

**Deployment:**

1.  **Create the GKE cluster:**

    ```bash
    ansible-playbook create-gke-cluster.yml
    ```

2.  **Deploy Ghost:**

    ```bash
    ansible-playbook deploy-ghost.yml
    ```

    - This playbook will:
      - Create Kubernetes secrets using Ansible Vault.
      - Deploy the MySQL database and Ghost application to the GKE cluster.
      - Configure the Ghost administrator account.

3.  **Access the Ghost blog:**

    - Once the deployment is complete, the external IP address of the Ghost blog
      will be displayed. Open this IP address in your web browser to access the
      Ghost blog. You can also get the IP with the command:
      `kubectl get service ghost -n ghost -o wide` (if you have the namespace
      `ghost` configured)

**Monitoring:**

1.  **Set up monitoring:**

    ```bash
    ansible-playbook monitoring.yml
    ```

    - This playbook will:
      - Install the Google Cloud Operations Agent on the GKE nodes.
      - Create monitoring dashboards and alert policies in Google Cloud
        Operations Suite.

**Load Testing:**

1.  **Run load tests:**

    ```bash
    ansible-playbook stress-test.yml
    ```

    - This playbook will use JMeter to perform load testing on the Ghost blog.

**Undeployment:**

1.  **Undeploy Ghost:**

    ```bash
    ansible-playbook undeploy-ghost.yml
    ```

    - This will remove all Ghost-related deployments, services, and secrets from
      the GKE cluster.

2.  **Destroy the GKE cluster (optional):**

    ```bash
    ansible-playbook destroy-gke-cluster.yml
    ```

    - **Warning:** This will permanently delete the GKE cluster and all its
      resources.

## Playbooks and Roles Overview

- **create-gke-cluster.yml:** Creates a GKE cluster using the
  `gke_cluster_create` role.
- **destroy-gke-cluster.yml:** Destroys the GKE cluster using the
  `gke_cluster_destroy` role.
- **deploy-ghost.yml:** Deploys the Ghost blogging platform and its
  dependencies.
  - Uses the `kube-secrets` role to manage Kubernetes secrets.
  - Uses the `deploy-ghost` role to deploy the application.
- **monitoring.yml:** Configures monitoring and alerting using Google Cloud
  Operations Suite.
  - Uses the `monitoring` role to install agents and create dashboards.
- **stress-test.yml:** Runs load tests against the Ghost blog using JMeter.
  - Uses the `jmeter` role to configure and execute the tests.
- **test-all.yml:** A comprehensive playbook that performs a full deployment,
  testing, and undeployment cycle.
- **undeploy-ghost.yml:** Undeploys the Ghost blogging platform and its
  dependencies.
  - Uses the `undeploy-ghost` role to remove deployments, services and secrets.
- **roles/gke_cluster_create:** Creates the GKE cluster.
- **roles/gke_cluster_destroy:** Destroys the GKE cluster.
- **roles/deploy-ghost:** Deploys the Ghost application on Kubernetes.
- **roles/kube-secrets:** Manages Kubernetes secrets using Ansible Vault.
- **roles/monitoring:** Sets up monitoring and alerting using Google Cloud
  Operations Suite.
- **roles/jmeter:** Configures and runs JMeter load tests.
- **roles/test_ghost:** Performs basic connectivity tests to the deployed Ghost
  application.
- **roles/undeploy-ghost:** Undeploys Ghost and its components.
- **roles/undeploy-pv:** Undeploys Persistent Volumes

## Scaling

```
kubectl scale --replicas=$NUMERO_REPLICAS deployment.apps/ghost
```
