# Stage 4: Logging and Monitoring Implementation

This stage focuses on implementing **logging**, **monitoring**, **alerting**, and **reliability mechanisms** for your Kubernetes-based architecture on AWS.

---

## 1. Logging (Fluent Bit + CloudWatch)

### 1.1 Create Namespace
```bash
kubectl create namespace amazon-cloudwatch
```

### 1.2 Create IAM Policy for Fluent Bit
Attach this policy to an IAM role used by a Kubernetes service account (IRSA):
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": "*"
    }
  ]
}
```

### 1.3 Install Fluent Bit with Helm
```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update

helm upgrade --install fluent-bit eks/aws-for-fluent-bit \
  --namespace amazon-cloudwatch \
  --create-namespace \
  --set serviceAccount.create=true \
  --set serviceAccount.name=fluent-bit \
  --set awsRegion=us-east-1 \
  --set cloudWatch.logs.region=us-east-1 \
  --set cloudWatch.logs.groupName=/aws/eks/onfinance \
  --set cloudWatch.logs.streamPrefix=fluentbit \
  --set cloudWatch.enabled=true
```

This sends logs from containers to CloudWatch.

---

## 2. Monitoring (Metrics Server + CloudWatch Container Insights)

### 2.1 Deploy Kubernetes Metrics Server
```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

### 2.2 Enable CloudWatch Container Insights
```bash
eksctl utils update-cluster-logging \
  --region us-east-1 \
  --cluster onfinance-cluster \
  --enable-types all
```

CloudWatch will now collect EKS performance metrics, logs, and offer dashboards.

---

##  3. Alerts (CloudWatch Alarm + SNS)

### 3.1 Create SNS Topic & Email Subscription
```bash
aws sns create-topic --name onfinance-alerts

aws sns subscribe \
  --topic-arn arn:aws:sns:us-east-1:<ACCOUNT_ID>:onfinance-alerts \
  --protocol email \
  --notification-endpoint your-email@example.com
```

Check your inbox and confirm the subscription.

### 3.2 Create CloudWatch Alarm
```bash
aws cloudwatch put-metric-alarm \
  --alarm-name HighCPUUsageEKSNode \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --statistic Average \
  --period 300 \
  --threshold 80 \
  --comparison-operator GreaterThanThreshold \
  --dimensions Name=AutoScalingGroupName,Value=<your-eks-asg-name> \
  --evaluation-periods 2 \
  --alarm-actions arn:aws:sns:us-east-1:<ACCOUNT_ID>:onfinance-alerts
```

---

## 4. Reliability Measures

- **Kubernetes Self-Healing:**
  - Liveness and readiness probes are configured in deployments (Stage 3)
  - HPA ensures auto-scaling
- **Multi-AZ Deployment:**
  - Achieved via Terraform modules (Stage 2)

---





