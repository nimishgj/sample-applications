#!/bin/bash

# Exit on error
set -e

# Script to create an EKS cluster with AWS Load Balancer Controller
echo "===== Starting EKS Cluster Creation Script ====="

# Define variables
CLUSTER_NAME="nimisha-testing-eks-cluster-ec2"
REGION="ap-south-1"
NODE_TYPE="t3.medium"
K8S_VERSION="1.28"

# Check for required tools
echo "Checking prerequisites..."
if ! command -v aws &> /dev/null; then
    echo "AWS CLI not found. Please install it first."
    exit 1
fi

if ! command -v eksctl &> /dev/null; then
    echo "eksctl not found. Please install it first."
    exit 1
fi

if ! command -v kubectl &> /dev/null; then
    echo "kubectl not found. Please install it first."
    exit 1
fi

if ! command -v helm &> /dev/null; then
    echo "helm not found. Please install it first."
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "jq not found. Please install it first."
    exit 1
fi

# Function to check EKS cluster status
wait_for_cluster() {
    echo "Waiting for EKS cluster to be ready..."
    while true; do
        status=$(eksctl get cluster --name $CLUSTER_NAME --region $REGION -o json 2>/dev/null | jq -r '.[0].Status')
        if [[ "$status" == "ACTIVE" ]]; then
            echo "EKS cluster is now active!"
            break
        fi
        echo "Cluster status: $status - waiting 30 seconds..."
        sleep 30
    done
}

# Function to wait for deployment to be ready
wait_for_deployment() {
    local namespace=$1
    local deployment=$2
    local timeout=$3
    
    echo "Waiting for deployment $deployment in namespace $namespace to be ready..."
    kubectl wait --for=condition=available --timeout=${timeout}s deployment/$deployment -n $namespace
    
    if [ $? -eq 0 ]; then
        echo "Deployment $deployment is ready!"
    else
        echo "Deployment $deployment timed out waiting for readiness."
        kubectl get deployment/$deployment -n $namespace -o yaml
        exit 1
    fi
}

# Function to wait for service to get external IP/hostname
wait_for_ingress() {
    local namespace=$1
    local ingress=$2
    local timeout=600
    local counter=0
    local step=10
    
    echo "Waiting for ingress $ingress in namespace $namespace to get ADDRESS..."
    
    while [ $counter -lt $timeout ]; do
        address=$(kubectl get ingress/$ingress -n $namespace -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null)
        
        if [[ -n "$address" && "$address" != "null" ]]; then
            echo "Ingress $ingress ADDRESS: $address"
            return 0
        fi
        
        counter=$((counter + step))
        echo "Waiting for ingress address... ($counter/$timeout seconds)"
        sleep $step
    done
    
    echo "Timed out waiting for ingress to get ADDRESS."
    kubectl get ingress/$ingress -n $namespace -o yaml
    return 1
}

echo "===== Creating EKS cluster ====="
echo "Cluster name: $CLUSTER_NAME"
echo "Region: $REGION"
echo "Node type: $NODE_TYPE"
echo "Kubernetes version: $K8S_VERSION"

# Create EKS cluster
echo "Creating EKS cluster..."
eksctl create cluster \
  --name $CLUSTER_NAME \
  --version $K8S_VERSION \
  --region $REGION \
  --nodegroup-name linux-nodes \
  --node-type $NODE_TYPE \
  --nodes 2 \
  --nodes-min 1 \
  --nodes-max 3 \
  --managed

# Wait for cluster to be ready
wait_for_cluster

echo "===== Setting up IAM OIDC provider ====="
# Associate IAM OIDC provider
eksctl utils associate-iam-oidc-provider \
  --cluster $CLUSTER_NAME \
  --approve

echo "===== Getting AWS Account ID ====="
# Get AWS Account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq -r '.Account')
echo "AWS Account ID: $AWS_ACCOUNT_ID"

echo "===== Creating IAM service account ====="
# Create IAM service account
eksctl create iamserviceaccount \
  --cluster=$CLUSTER_NAME \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::$AWS_ACCOUNT_ID:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve

echo "===== Verifying IAM service account ====="
# Get IAM service account
eksctl get iamserviceaccount \
  --cluster=$CLUSTER_NAME \
  --name=aws-load-balancer-controller \
  --namespace=kube-system

# Get service account details
kubectl get serviceaccount aws-load-balancer-controller \
  --namespace kube-system \
  -o yaml

echo "===== Adding EKS Helm repo ====="
# Add EKS Helm repo
helm repo add eks https://aws.github.io/eks-charts

# Update Helm repo
helm repo update eks

echo "===== Setting up environment variables ====="
# Set cluster name
CLUSTER_NAME=$CLUSTER_NAME

# Set stack name
STACK_NAME=eksctl-$CLUSTER_NAME-cluster
echo "CloudFormation Stack Name: $STACK_NAME"

# Get VPC ID
echo "Getting VPC ID from CloudFormation stack..."
VPC_ID=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" | jq -r '[.Stacks[0].Outputs[] | {key: .OutputKey, value: .OutputValue}] | from_entries' | jq -r '.VPC')
echo "VPC ID: $VPC_ID"

echo "===== Installing AWS Load Balancer Controller ====="
# Install AWS Load Balancer Controller
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  --set clusterName=$CLUSTER_NAME \
  --set serviceAccount.create=false \
  --set region=$REGION \
  --set vpcId=$VPC_ID \
  --set serviceAccount.name=aws-load-balancer-controller \
  --version 1.11.0 \
  -n kube-system

echo "===== Waiting for AWS Load Balancer Controller deployment ====="
# Wait for AWS Load Balancer Controller deployment
wait_for_deployment "kube-system" "aws-load-balancer-controller" 300

# Check deployment status
kubectl get deployment -n kube-system aws-load-balancer-controller

echo "===== Deploying 2048 game ====="
# Deploy 2048 game
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/examples/2048/2048_full.yaml

echo "===== Waiting for 2048 game deployment ====="
# Wait for 2048 game deployment
wait_for_deployment "game-2048" "deployment-2048" 300

echo "===== Waiting for ingress to be ready ====="
# Wait for ingress to get ADDRESS
wait_for_ingress "game-2048" "ingress-2048"

echo "===== EKS Cluster Setup Complete ====="
echo "Ingress ADDRESS for 2048 game:"
kubectl get ingress/ingress-2048 -n game-2048

echo "Copy and paste the ADDRESS in your browser to access the 2048 game."
echo "===== Script completed successfully ====="
