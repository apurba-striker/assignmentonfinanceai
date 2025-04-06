# Stage 1: High-Level Architecture Design 

## Objective
Design a highly available, scalable, and secure AWS infrastructure for deploying full-stack application using Kubernetes (EKS).

---

## Architecture Overview

This architecture leverages managed AWS services to ensure availability, scalability, and security while simplifying operational overhead.

### Compute Platform
- **Amazon EKS (Elastic Kubernetes Service)**: Used to deploy containerized backend and frontend applications with managed control plane.
- **AWS Fargate (Optional)**: Can be used for running workloads without managing servers.

###  Networking
- **VPC (Virtual Private Cloud)** with:
  - 3 Public Subnets (for ELB, NAT Gateway)
  - 3 Private Subnets (for EKS worker nodes, RDS, Lambda)
  - Internet Gateway (for public access)
  - NAT Gateways (for outbound internet from private subnets)
- **Route Tables** for proper network segmentation

###  Load Balancing
- **Application Load Balancer (ALB)**:
  - Handles traffic to frontend/backend services deployed on EKS.
  - Integrated with Kubernetes Ingress controller.

###  Data Storage
- **Amazon RDS (PostgreSQL)**: Used to store transactional data securely with multi-AZ failover support.
- **Amazon S3**: Stores static assets, logs, and ETL outputs.

###  Security
- **IAM Roles and Policies**: Fine-grained permissions for EC2, EKS, Lambda, S3, RDS, etc.
- **Secrets Manager**: Securely store API keys, DB credentials.
- **Security Groups and NACLs**: Protect traffic at subnet and instance level.
- **Private Subnets**: RDS and EKS worker nodes are not publicly accessible.

### Logging and Monitoring
- **Amazon CloudWatch**:
  - Logs from EKS (via Fluent Bit)
  - Lambda logs
  - Metrics and Dashboards
- **CloudWatch Alarms + SNS**: For alerting on critical metrics
- **Kubernetes Metrics Server**: For pod-level monitoring and autoscaling

### 🔷 Auto Scaling and Availability
- **EKS Node Group Auto Scaling**
- **Horizontal Pod Autoscaler (HPA)** for Kubernetes
- **Multi-AZ Deployment**: Resources spread across at least 3 Availability Zones

---

## Data Flow

1. **Users access the application** via ALB (HTTPS)
2. **Requests routed** to the frontend/backend services running on EKS
3. **App logic communicates** with RDS for data and S3 for static/media content
4. **Metrics and logs** are sent to CloudWatch
5. **ETL Lambda** fetches weather data from public API and stores it in S3 on a schedule
6. **Alerts** are triggered via CloudWatch Alarms -> SNS -> Email/SMS

---

## Justification for Service Choices
| Component            | Service Used          | Reason                                                                 |
|---------------------|-----------------------|------------------------------------------------------------------------|
| Compute             | Amazon EKS            | Highly available, scalable container orchestration                    |
| Networking          | VPC/Subnets/NAT       | Isolated network with internet access control                         |
| Load Balancer       | ALB                   | Scalable, integrated with Kubernetes Ingress                          |
| Database            | RDS (PostgreSQL)      | Managed relational DB with HA support                                 |
| Object Storage      | S3                    | Durable, scalable storage for ETL, logs                               |
| Secrets Management  | AWS Secrets Manager   | Securely manage sensitive credentials                                 |
| Logging & Metrics   | CloudWatch + FluentBit| Centralized logging and monitoring for observability                  |
| Alerting            | CloudWatch + SNS      | Notify stakeholders of anomalies and downtimes                        |

---

## Diagram
```
  [Users]
     |
     v
+--------------+
|    ALB       |
+--------------+
     |
     v
+------------+       +------------+
| Frontend   | <---> | Backend    |
| (EKS)      |       | (EKS)      |
+------------+       +------------+
     |                   |
     v                   v
 [S3 Bucket]        [RDS Database]
     ^
     |
+------------+
| Lambda     |
| (ETL Job)  |
+------------+
     |
     v
[Weather API]
```

---

## Summary
This architecture provides a cloud-native foundation for a scalable and secure deployment of the OnFinance AI application using AWS best practices. It supports high availability, centralized logging/monitoring, secure secret management, and future extensibility via modular infrastructure.

