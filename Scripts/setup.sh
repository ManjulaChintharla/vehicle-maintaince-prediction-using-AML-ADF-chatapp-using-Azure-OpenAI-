#! /usr/bin/sh

# Create random string
guid=$(cat /proc/sys/kernel/random/uuid)
suffix=${guid//[-]/}
suffix=${suffix:0:18}

# Set the necessary variables
RESOURCE_GROUP="rg-contosobank-l${suffix}"
RESOURCE_PROVIDER="Microsoft.MachineLearningServices"
RESOURCE_PROVIDER1="Microsoft.PolicyInsights"
RESOURCE_PROVIDER2="Microsoft.Cdn"
RESOURCE_PROVIDER3="Microsoft.AlertsManagement"
RESOURCE_PROVIDER4="Microsoft.Web"
REGIONS=("eastus" "westus" "centralus" "northeurope" "westeurope")
RANDOM_REGION=${REGIONS[$RANDOM % ${#REGIONS[@]}]}
WORKSPACE_NAME="mlw-cb-l${suffix}"
COMPUTE_INSTANCE="cb-ci${suffix}"
COMPUTE_CLUSTER="cb-aml-cluster"



# Register the Azure Machine Learning resource provider in the subscription
echo "Register the Machine Learning resource providers:"
az provider register --namespace $RESOURCE_PROVIDER
az provider register --namespace $RESOURCE_PROVIDER1
az provider register --namespace $RESOURCE_PROVIDER2
az provider register --namespace $RESOURCE_PROVIDER3
az provider register --namespace $RESOURCE_PROVIDER4

# Create the resource group and workspace and set to default
echo "Create a resource group and set as default:"
az group create --name $RESOURCE_GROUP --location $RANDOM_REGION
az configure --defaults group=$RESOURCE_GROUP

echo "Create an Azure Machine Learning workspace:"
az ml workspace create --name $WORKSPACE_NAME 
az configure --defaults workspace=$WORKSPACE_NAME 

# Create compute instance
echo "Creating a compute instance with name: " $COMPUTE_INSTANCE
az ml compute create --name ${COMPUTE_INSTANCE} --size STANDARD_DS11_V2 --type ComputeInstance 

# Create compute cluster
echo "Creating a compute cluster with name: " $COMPUTE_CLUSTER
az ml compute create --name ${COMPUTE_CLUSTER} --size STANDARD_DS11_V2 --max-instances 2 --type AmlCompute 

