#!/bin/bash

# Define variables
AWS_REGION="us-west-2"
CLUSTER_NAME="my-eks-cluster"
SERVICE_NAME="weather-service"

# Step 1: Run IaC and create the Kubernetes cluster
terraform init
terraform apply -auto-approve

# Step 2: Install Jenkins in Kubernetes
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm install jenkins jenkins/jenkins -f jenkins-values.yaml

# Wait for Jenkins deployment to complete
kubectl wait --for=condition=Ready pod -l app.kubernetes.io/component=jenkins-jenkins-master

# Step 3: Create a pipeline for the microservice in Jenkins
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: jenkins-home
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 8Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins-agent
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jenkins-agent
  template:
    metadata:
      labels:
        app: jenkins-agent
    spec:
      containers:
      - name: jnlp
        image: jenkins/jnlp-slave:3.35-6-jdk11
        resources:
          limits:
            cpu: "1"
            memory: "1Gi"
          requests:
            cpu: "500m"
            memory: "256Mi"
        volumeMounts:
          - name: jenkins-home
            mountPath: /home/jenkins/agent
      volumes:
        - name: jenkins-home
          persistentVolumeClaim:
            claimName: jenkins-home
---
apiVersion: v1
kind: Service
metadata:
  name: jenkins-agent
spec:
  selector:
    app: jenkins-agent
  ports:
    - name: jnlp
      port: 50000
      protocol: TCP
      targetPort: 50000
  type: ClusterIP
---
apiVersion: v1
kind: Service
metadata:
  name: jenkins
spec:
  selector:
    app: jenkins
  ports:
    - name: http
      port: 8080
      protocol: TCP
      targetPort: 8080
  type: LoadBalancer
EOF

# Step 4: Execute the pipeline for the microservice
JENKINS_URL=$(kubectl get svc jenkins -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "Jenkins URL: http://$JENKINS_URL"

# Wait for Jenkins to start
sleep 120

# Retrieve the Jenkins admin password
JENKINS_PASSWORD=$(kubectl exec -it $(kubectl get pod -l app.kubernetes.io/component=jenkins-jenkins-master -o jsonpath='{.items[0].metadata.name}') -- cat /var/jenkins_home/secrets/initialAdminPassword)

echo "Jenkins admin password: $JENKINS_PASSWORD"
echo "Please follow the Jenkins setup wizard to complete the installation and configuration."
echo "After that, create a pipeline in Jenkins to build and deploy the microservice."

