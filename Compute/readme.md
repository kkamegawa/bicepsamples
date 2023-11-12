# Bicep samples for Azure Virtual Machine

## create a virtual machine with a public IP address

[Create Windows Server 2019 with public IP](create-windows2019-vm-w-pip.bicep)

How to deploy to Azure.

```bash
az group create --name biceptest --location 'Japan East'
az deployment group create  --resource-group 'biceptest' \
 --template-file .\create-windows2019-vm-w-pip.bicep --parameters adminUsername=adminuser adminPassword=P@ssw0rd vmName=samplevm
```
