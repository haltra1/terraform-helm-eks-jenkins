
Ensure you have the necessary tools installed, such as Terraform, Helm, and kubectl. Replace `jenkins-values.yaml` with the appropriate file containing the Helm values for Jenkins.

When executing this script, it will perform the following steps:

1.  Run the Infrastructure-as-Code (IaC) using Terraform to create the Kubernetes cluster.
2.  Install Jenkins in the Kubernetes cluster using Helm.
3.  Create the necessary resources (PersistentVolumeClaim, Deployment, and Services) for the Jenkins agent in Kubernetes.
4.  Execute the pipeline for the microservice in Jenkins. This step requires manual configuration in the Jenkins web interface.

Make sure to update the variables (`AWS_REGION`, `CLUSTER_NAME`, `SERVICE_NAME`) to match your desired settings.