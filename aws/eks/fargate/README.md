requirements:
- aws login with admin creds.
- eksctl installed
- helm installed

  Run the following commands to create a eks fargate cluster
  
```shell
eksctl create cluster \
  --name nimisha-testing-eks-cluster-fargate \
  --version 1.28 \
  --fargate
```

-----------------

```shell
eksctl utils associate-iam-oidc-provider \
  --cluster nimisha-testing-eks-cluster-fargate \
  --approve
```

-----------------
> Delete IAM Policy with name `AWSLoadBalancerControllerIAMPolicy` before running the below commands
```shell
curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json
```

------------------
```shell
aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam_policy.json
```
-----------------
```shell
AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq -r '.Account')
```
-----------------
```shell
eksctl create iamserviceaccount \
  --cluster=nimisha-testing-eks-cluster-fargate \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::$(AWS_ACCOUNT_ID):policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve
```
----------------
```shell
eksctl get iamserviceaccount \
  --cluster=nimisha-testing-eks-cluster-fargate \
  --name=aws-load-balancer-controller \
  --namespace=kube-system
```
----------------------
```shell
kubectl get serviceaccount aws-load-balancer-controller \
  --namespace kube-system \
  -o yaml
```
--------------------
```shell
helm repo add eks https://aws.github.io/eks-charts
```
---------------------
```shell
helm repo update eks
```
----------------------
```shell
CLUSTER_NAME=nimisha-testing-eks-cluster-fargate
```
----------------------
```shell
STACK_NAME=eksctl-$CLUSTER_NAME-cluster
```

---------------------
```shell
VPC_ID=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" | jq -r '[.Stacks[0].Outputs[] | {key: .OutputKey, value: .OutputValue}] | from_entries' | jq -r '.VPC')
```
-------------------
```shell
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  --set clusterName=nimisha-testing-eks-cluster-fargate \
  --set serviceAccount.create=false \
  --set region=ap-south-1 \
  --set vpcId=$VPC_ID \
  --set serviceAccount.name=aws-load-balancer-controller \
  --version 1.11.0 \
  -n kube-system
```
-------------------
```shell
kubectl get deployment -n kube-system aws-load-balancer-controller
```
---------------
wait for 10mis
-------------------
```shell
eksctl create fargateprofile \
  --cluster nimisha-testing-eks-cluster-fargate \
  --region ap-south-1 \
  --name your-alb-sample-app \
  --namespace game-2048
```
-----------------
```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/examples/2048/2048_full.yaml
```
------------------
wait for 10mins
------------------
```shell
kubectl get ingress/ingress-2048 -n game-2048
```
------------------
copy and paste the ADDRESS in chrome


ref link: https://repost.aws/knowledge-center/eks-alb-ingress-controller-fargate



