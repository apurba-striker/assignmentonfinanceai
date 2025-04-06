# Stage 3 



## Project Structure

```
onfinance-k8s/
├── backend/
│   ├── Dockerfile
│   ├── server.js / app.js
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── backend-configmap.yaml
│   ├── backend-secret.yaml
│   ├── backend-hpa.yaml
├── frontend/
│   ├── Dockerfile
│   ├── nginx.conf
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   ├── frontend-hpa.yaml
├── README.md
```

---

##  Deployment Steps

### 1. Build & Push Docker Images to Docker Hub

```bash
# Backend
cd backend
docker build -t <your-dockerhub-username>/onfinance-backend .
docker push <your-dockerhub-username>/onfinance-backend

# Frontend
cd ../frontend
docker build -t <your-dockerhub-username>/onfinance-frontend .
docker push <your-dockerhub-username>/onfinance-frontend
```

---

### Optional: Build & Push Docker Images to AWS ECR

```bash
# Set these values
AWS_REGION=us-east-1
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REPO_NAME=onfinance-frontend
IMAGE_NAME=$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME

# Create ECR repository (only once)
aws ecr create-repository --repository-name $REPO_NAME

# Authenticate Docker with ECR
aws ecr get-login-password --region $AWS_REGION | \
docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Build and push the Docker image
docker build -t $REPO_NAME ./frontend
docker tag $REPO_NAME:latest $IMAGE_NAME
docker push $IMAGE_NAME
```

>  Repeat with `onfinance-backend` for the backend Docker image.

---

### 2. Create Kubernetes Secrets & ConfigMaps

```bash
# Backend ConfigMap
kubectl apply -f backend/backend-configmap.yaml

# Backend Secret
kubectl apply -f backend/backend-secret.yaml
```

---

### 3.  Deploy the Application

```bash
# Backend
kubectl apply -f backend/backend-deployment.yaml
kubectl apply -f backend/backend-service.yaml
kubectl apply -f backend/backend-hpa.yaml

# Frontend
kubectl apply -f frontend/frontend-deployment.yaml
kubectl apply -f frontend/frontend-service.yaml
kubectl apply -f frontend/frontend-hpa.yaml
```

---

### 4.  Access the App

```bash
kubectl get svc
```
- Note the **EXTERNAL-IP** from the `frontend-service` of type LoadBalancer.
- Open the IP in your browser to access the app.

---

## What's Included

| Feature                  | Description                                      |
|-------------------------|--------------------------------------------------|
| Deployments             | React frontend + Node backend                   |
| Services                | ClusterIP (backend), LoadBalancer (frontend)    |
| ConfigMaps & Secrets    | Used in backend for configuration               |
| Liveness/Readiness Probes | Ensures app health & restarts on failure     |
| Horizontal Pod Autoscaler | Scales based on CPU for backend & frontend   |

---


##  Notes
- Backend service name used in NGINX config: `http://backend-service:5000`
- Ensure Docker images are public or accessible from EKS nodes
- EKS and kubectl setup must be completed beforehand (Stage 2)

---


