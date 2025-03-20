#! /usr/bin/sh

# Create random string
guid=$(cat /proc/sys/kernel/random/uuid)
suffix=${guid//[-]/}
suffix=${suffix:0:18}

# Set the necessary variables
RESOURCE_GROUP="rg-contosofleetguard-l${suffix}"
RESOURCE_PROVIDER="Microsoft.MachineLearningServices"
RESOURCE_PROVIDER1="Microsoft.PolicyInsights"
RESOURCE_PROVIDER2="Microsoft.Cdn"
RESOURCE_PROVIDER3="Microsoft.AlertsManagement"
RESOURCE_PROVIDER4="Microsoft.Web"
REGIONS=("westus" "centralus" )
RANDOM_REGION=${REGIONS[$RANDOM % ${#REGIONS[@]}]}
WORKSPACE_NAME="mlw-cfg-ws${suffix}"
COMPUTE_INSTANCE="cfg-ci${suffix}"
COMPUTE_CLUSTER="cfg-aml-cluster"
ADF_NAME="adf-cfg-df${suffix}"
Azure_POSTGRESQL_NAME="azpostsql-cfg-psql${suffix}"
USERNAME="citus"
PASSWORD="AZpsql12345"



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

# Create Azure data factory
echo "Creating a Azure data factory with name: " $ADF_NAME
az datafactory create --resource-group $RESOURCE_GROUP --factory-name $ADF_NAME


# Create Azure Database for postgresql
echo "Creating a Azure data base for postgresql with name: " $Azure_POSTGRESQL_NAME
#az postgres flexible-server create --resource-group $RESOURCE_GROUP --name $Azure_POSTGRESQL_NAME --admin-user $USERNAME --admin-password $PASSWORD --sku-name Standard_D2s_v3 --tier GeneralPurpose --public-access 153.24.26.117 --storage-size 128 --tags "key=value" --version 14 --high-availability "Disabled (99.9% SLA)" --authentication-type "PostgreSQL authentication only"  --zone 1 --standby-zone 3
#az postgres flexible-server create --location westus  --resource-group rg-contosofleetguard-lda7fb0dd0daa488499 --name azpostsql-cfg-psql499  --admin-user citus --admin-password Fhtest208  --sku-name Standard_D2s_v3 --tier GeneralPurpose --public-access 153.24.26.117 --storage-size 128 --tags "128" --version 14 --high-availability Disabled
echo "Username of postgresql is  " $USERNAME
echo "Password of postgresql is  " $PASSWORD
