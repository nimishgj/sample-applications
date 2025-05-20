#!/bin/bash

set -euo pipefail

CLUSTER_NAME="nimisha-testing-eks-cluster-fargate"
REGION="ap-south-1"
IAM_POLICY_NAME="AWSLoadBalancerControllerIAMPolicy"

echo "===== Step 1: Create EKS Fargate Cluster ====="
eksctl create cluster \
  --name "$CLUSTER_NAME" \
  --version 1.28 \
  --fargate

echo "===== Step 2: Associate IAM OIDC Provider ====="
eksctl utils associate-iam-oidc-provider \
  --cluster "$CLUSTER_NAME" \
  --approve

echo "===== Step 3: Check and Create IAM Policy if needed ====="
POLICY_EXISTS=$(aws iam list-policies --scope Local | jq -r --arg name "$IAM_POLICY_NAME" '.Policies[] | select(.PolicyName == $name) | .Arn')

if [[ -z "$POLICY_EXISTS" ]]; then
  echo "IAM policy '$IAM_POLICY_NAME' not found. Creating it..."
  curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json

  aws iam create-policy \
    --policy-name "$IAM_POLICY_NAME" \
    --policy-document file://iam_policy.json

  echo "✅ IAM policy '$IAM_POLICY_NAME' created successfully."
else
  echo "✅ IAM policy '$IAM_POLICY_NAME' already exists: $POLICY_EXISTS"
fi

echo "===== Step 4: Get AWS Account ID ====="
AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq -r '.Account')
echo "AWS Account ID: $AWS_ACCOUNT_ID"

echo "===== Step 5: Create IAM Service Account (no substitution) ====="
eksctl create iamserviceaccount \
  --cluster="$CLUSTER_NAME" \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::$AWS_ACCOUNT_ID:policy/$IAM_POLICY_NAME \
  --override-existing-serviceaccounts \
  --approve

echo "===== Step 6: Verify IAM Service Account ====="
eksctl get iamserviceaccount \
  --cluster="$CLUSTER_NAME" \
  --name=aws-load-balancer-controller \
  --namespace=kube-system

kubectl get serviceaccount aws-load-balancer-controller \
  --namespace kube-system \
  -o yaml

echo "===== Step 7: Add and Update Helm Repo ====="
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks

echo "===== Step 8: Get VPC ID from CloudFormation Outputs ====="
STACK_NAME="eksctl-$CLUSTER_NAME-cluster"
VPC_ID=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" | jq -r '[.Stacks[0].Outputs[] | {key: .OutputKey, value: .OutputValue}] | from_entries' | jq -r '.VPC')
echo "VPC ID: $VPC_ID"

echo "===== Step 9: Install AWS Load Balancer Controller via Helm ====="
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  --set clusterName="$CLUSTER_NAME" \
  --set serviceAccount.create=false \
  --set region="$REGION" \
  --set vpcId="$VPC_ID" \
  --set serviceAccount.name=aws-load-balancer-controller \
  --version 1.11.0 \
  -n kube-system

echo "===== Step 10: Verify Controller Deployment ====="
kubectl get deployment -n kube-system aws-load-balancer-controller

echo "===== Step 11: Wait for controller to initialize... (10 mins) ====="
sleep 600

echo "===== Step 12: Create Fargate Profile for app namespace ====="
eksctl create fargateprofile \
  --cluster "$CLUSTER_NAME" \
  --region "$REGION" \
  --name your-alb-sample-app \
  --namespace game-2048

echo "===== Step 13: Deploy 2048 Ingress Sample App ====="
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/examples/2048/2048_full.yaml

echo "===== Step 14: Wait for Ingress resource to initialize... (10 mins) ====="
sleep 600

echo "===== Step 15: Get Ingress address ====="
kubectl get ingress/ingress-2048 -n game-2048

echo "✅ Done! Copy and paste the 'ADDRESS' field from the above output into your browser to access the app."

