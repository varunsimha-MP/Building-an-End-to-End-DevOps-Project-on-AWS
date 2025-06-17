Building an End-to-End DevOps Project on AWS using Terraform, Kubernetes, Jenkins (CI/CD), GitOps, ArgoCD with Full Prometheus Monitoring & Grafana Visualization

In this project, I build a full end-to-end DevOps project on AWS with GitOps workflow. The entire infrastructure was provisioned using Terraform, with state and lock management in AWS S3. The application code is managed on GitHub, and a webhook triggers Jenkins to clone the repo, build a Docker image, push it to Amazon ECR, and update a GitOps-managed repo. ArgoCD watches this repo and automatically deploys to Amazon EKS, using Kubernetes Deployments for app pods and StatefulSets for database pods, backed by Amazon EFS for persistent storage. External access is routed via an Ingress Controller using AWS ALB, secured by AWS Certificate Manager (ACM) and Route 53 for DNS. The entire stack is monitored by Prometheus and visualized through Grafana, with RBAC controlling access and alerts sent via email for any failures in Jenkins pipelines or unhealthy services. 

The tech stack includes Terraform, GitHub, Jenkins, Docker, ArgoCD, Helm, Kubernetes, AWS EKS, ECR, EFS, ALB, ACM, Route 53, Prometheus, Grafana, ConfigMap, Secrets, RBAC, and more — delivering a robust, automated, scalable, and secure DevOps pipeline.

![DevOps](https://github.com/user-attachments/assets/9cdbbd38-930b-4b7e-87f7-dd3e98c25f4a)
