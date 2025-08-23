Blue-Green Deployment Project
https://opensource.org/license/MIT
https://nodejs.org/
https://www.docker.com/
https://kubernetes.io/
🚀 Overview
This project implements a zero-downtime blue-green deployment strategy using Node.js, MongoDB, Docker, and Kubernetes. The setup allows for seamless application updates with instant rollback capabilities.
Architecture Components

Backend: Node.js REST API server
Frontend: Dual environment setup (Blue/Green versions)
Database: MongoDB with persistent storage
Orchestration: Kubernetes manifests and services
Load Balancing: Nginx reverse proxy
Automation: Shell scripts for deployment automation

📋 Prerequisites
Before you begin, ensure you have the following installed:

Docker (v20.10+)
Docker Compose (v2.0+)
Kubernetes cluster (minikube/kind/cloud)
kubectl CLI tool
Node.js (v16.0+) and npm
Git

🛠️ Quick Start
1. Clone and Setup
bashgit clone <repository-url>
cd BLUE-GREEN-DEPLOYMENT

# Install root dependencies
npm install

# Install backend dependencies
cd backend && npm install && cd ..

# Install frontend dependencies
cd frontend-blue && npm install && cd ..
cd frontend-green && npm install && cd ..
2. Environment Configuration
Create environment files for each service:
bash# Backend environment
cp backend/.env.example backend/.env

# Frontend Blue environment
cp frontend-blue/.env.example frontend-blue/.env

# Frontend Green environment
cp frontend-green/.env.example frontend-green/.env
3. Docker Build and Push
bash# Build all images
docker build -t your-registry/backend:latest ./backend
docker build -t your-registry/frontend-blue:latest ./frontend-blue
docker build -t your-registry/frontend-green:latest ./frontend-green

# Push to registry
docker push your-registry/backend:latest
docker push your-registry/frontend-blue:latest
docker push your-registry/frontend-green:latest
4. Kubernetes Deployment
bash# Create namespace
kubectl create namespace blue-green-app

# Deploy secrets and config
kubectl apply -f k8s/config-secrets.yaml

# Deploy MongoDB
kubectl apply -f k8s/mongo-deployment.yaml

# Deploy backend
kubectl apply -f k8s/backend-deployment.yaml

# Deploy initial frontend (Blue)
kubectl apply -f k8s/frontend-blue-deployment.yaml
kubectl apply -f k8s/frontend-service.yaml
kubectl apply -f k8s/bluegreen-ingress.yaml
🔄 Blue-Green Deployment Process
Automated Deployment
Use the provided script for seamless deployments:
bash# Make script executable
chmod +x deploy-bluegreen.sh

# Deploy to green environment
./deploy-bluegreen.sh deploy green

# Switch traffic to green
./deploy-bluegreen.sh switch-to-green

# Rollback if needed
./deploy-bluegreen.sh switch-to-blue
Manual Deployment Steps

Deploy Green Environment
bashkubectl apply -f k8s/frontend-green-deployment.yaml
kubectl wait --for=condition=available deployment/frontend-green

Test Green Environment
bashkubectl port-forward service/frontend-green-service 8080:80
# Test at http://localhost:8080

Switch Traffic
bashkubectl patch service frontend-service -p '{"spec":{"selector":{"version":"green"}}}'

Verify and Cleanup
bash# Verify the switch
kubectl get endpoints frontend-service

# Scale down blue (optional)
kubectl scale deployment frontend-blue --replicas=0


📁 Project Structure
BLUE-GREEN-DEPLOYMENT/
├── backend/
│   ├── models/              # Database models
│   ├── node_modules/        # Backend dependencies
│   ├── routes/              # API routes
│   ├── .env                 # Environment variables
│   ├──           # Backend container config
│   ├── package.json        # Backend dependencies
│   └── server.js           # Main server file
├── frontend-blue/
│   ├── node_modules/        # Frontend dependencies
│   ├── public/              # Static assets
│   ├── .env                 # Environment variables
│   ├── dockerfile          # Frontend container config
│   ├── nginx.conf          # Nginx configuration
│   ├── package.json        # Frontend dependencies
│   └── server.js           # Frontend server
├── frontend-green/
│   ├── node_modules/        # Frontend dependencies
│   ├── public/              # Static assets
│   ├── .env                 # Environment variables
│   ├──           # Frontend container config
│   ├── nginx.conf          # Nginx configuration
│   ├── package.json        # Frontend dependencies
│   └── server.js           # Frontend server
├── k8s/
│   ├── backend-deployment.yaml        # Backend K8s deployment
│   ├── bluegreen-ingress.yaml        # Ingress configuration
│   ├── config-secrets.yaml          # Configuration secrets
│   ├── frontend-blue-deployment.yaml # Blue frontend deployment
│   ├── frontend-green-deployment.yaml # Green frontend deployment
│   ├── frontend-service.yaml        # Frontend service
│   ├── mongo-deployment.yaml        # MongoDB deployment
│   └── Namespace.yaml               # Kubernetes namespace
├── node_modules/            # Root project dependencies
├── deploy-bluegreen.sh     # Deployment automation script
├── docker-compose.yml      # Local development setup
├── .gitignore             # Git ignore file
├── package.json           # Root package configuration
├── package-lock.json      # Dependency lock file
└── README.md              # This file
🔧 Configuration
Environment Variables
Backend (.env)
envNODE_ENV=production
PORT=3000
MONGODB_URI=mongodb://mongodb:27017/bluegreen
JWT_SECRET=your-jwt-secret
API_VERSION=v1
Frontend (.env)
envNODE_ENV=production
PORT=80
API_BASE_URL=http://backend-service:3000
REACT_APP_VERSION=blue  # or green
Kubernetes Secrets
Update k8s/config-secrets.yaml with your configuration:
yamlapiVersion: v1
kind: Secret
metadata:
  name: app-secrets
type: Opaque
stringData:
  mongodb-uri: "mongodb://mongodb:27017/bluegreen"
  jwt-secret: "your-jwt-secret"
  api-key: "your-api-key"
🎯 Deployment Strategies
Blue-Green Deployment

Zero Downtime: Traffic switches instantly between environments
Quick Rollback: Immediate fallback to previous version
Testing: Full testing on green before switching traffic

Rollback Process
bash# Quick rollback to blue
./deploy-bluegreen.sh switch-to-blue

# Or manual rollback
kubectl patch service frontend-service -p '{"spec":{"selector":{"version":"blue"}}}'

# Scale up blue if needed
kubectl scale deployment frontend-blue --replicas=3
📊 Monitoring and Health Checks
Application Health
bash# Check deployment status
kubectl get deployments -w

# Monitor application logs
kubectl logs -f deployment/frontend-green
kubectl logs -f deployment/backend

# Check service endpoints
kubectl get endpoints
Resource Monitoring
bash# Pod resource usage
kubectl top pods

# Node resource usage
kubectl top nodes

# Describe resources for detailed info
kubectl describe deployment <deployment-name>
🐛 Troubleshooting
Common Issues
IssueCauseSolutionPods not startingResource constraintsCheck kubectl describe podService unreachableWrong selectorsVerify service selectors match labelsDatabase connection failedWrong connection stringCheck secrets and network policiesImage pull errorsRegistry accessVerify image names and registry credentials
Debug Commands
bash# Pod logs
kubectl logs <pod-name> -c <container-name>

# Execute into pod
kubectl exec -it <pod-name> -- /bin/bash

# Check events
kubectl get events --sort-by='.lastTimestamp'

# Network debugging
kubectl exec -it <pod-name> -- nslookup <service-name>
🔒 Security Best Practices

✅ Use Kubernetes secrets for sensitive data
✅ Implement RBAC (Role-Based Access Control)
✅ Enable network policies
✅ Use non-root containers
✅ Regular security updates
✅ Scan images for vulnerabilities

🚀 Performance Optimization

Resource Management: Set appropriate CPU/memory requests and limits
Horizontal Scaling: Configure HPA (Horizontal Pod Autoscaler)
Health Probes: Implement readiness and liveness probes
Persistent Storage: Use persistent volumes for MongoDB
Caching: Implement Redis or similar for session management

🤝 Contributing

Fork the repository
Create a feature branch (git checkout -b feature/amazing-feature)
Commit your changes (git commit -m 'Add amazing feature')
Push to the branch (git push origin feature/amazing-feature)
Open a Pull Request

📄 License
This project is licensed under the MIT License - see the LICENSE file for details.