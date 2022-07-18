# Bicep samples for Azure Storage

## Storage sample can public access

[storage-enable-internet.bicep](storage-enable-internet.bicep)

How to deploy to Azure.
```
az group create --name biceptest --location 'Japan East'
az deployment group create   --resource-group 'biceptest'\ 
 --template-file .\storage-enable-internet.bicep --parameters storageName=samplestorage
```
