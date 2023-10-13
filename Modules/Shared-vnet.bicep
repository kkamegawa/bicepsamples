@description('Network location')
param location string = resourceGroup().location
@description('Network Name')
param vnetName string
@description('Network Address range')
param vnetAddressPrefix string = '10.0.0.0/16'

var subnets = [
  {
    name: 'default'
    subnetPrefix: '10.0.0.0/24'
    delegations: []
  }
  {
    name: 'storage'
    subnetPrefix: '10.0.1.0/27'
    serviceEndpoints: [
      {
        service: 'Microsoft.Storage'
      }
    ]
  }
]

resource vnetsubnet 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' = [for (subnet, i) in subnets : {
  name: subnet.name
  parent: virtualNetwork
  properties: {
    addressPrefix: subnet.subnetPrefix
  }
}]

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets:[ for subnet in subnets:{
      name: subnet.name
      properties:{
        addressPrefix: subnet.subnetPrefix
      }
    }]
  }
}

output storageSubnetId string = resourceId('Microsoft.Network/VirtualNetworks/subnets', vnetName, 'storage')

