# Bicep samples for Azure Network

## Virtual Network with one subnet and Network Security Group

[vnet-sample.bicep](vnet-sample.bicep)

How to deploy to Azure.
```
az group create --name biceptest --location 'Japan East'
az deployment group create  --resource-group 'biceptest' \
 --template-file .\vnet-sample.bicep --parameters vnetName=vnetbicep
```
