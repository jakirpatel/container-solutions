#! /bin/bash 
# This script is for creating the certificates for kubernetes user using OpenSSL
# It also creates the context for the user. 

echo "Enter the username (Username for the user):"
read username

echo "Enter the cluster-name (kubectl config get-clusters):"
read clustername

echo "Enter the Kubernetes certiticate location(/etc/kubernetes/pki):"
read kubecertpath

echo "Enter the user certificates path location:"
read userpath

echo "Enter the kubernetes namespace:"
read namespace


function createUser(){
  openssl genrsa -out $1/$4.key 2048
  openssl req -new -key $1/$4.key -out $1/$4.csr -subj "/CN=$4/O=$3"
  openssl x509 -req -in $1/$4.csr -CA $2/ca.crt -CAkey $2/ca.key -CAcreateserial -out $1/$4.crt -days 500
  kubectl config set-credentials $4 --client-certificate=$1/$4.crt  --client-key=$1/$4.key
  kubectl config set-context $4-context --cluster=$5 --namespace=$3 --user=$4
}

createUser $userpath $kubecertpath $namespace $username $clustername
