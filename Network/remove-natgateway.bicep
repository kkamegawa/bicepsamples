param natGatewayName string = 'ngw-outbount-001'
param location string = resourceGroup().location
param idleTimeoutInMinutes int = 4
param virtualNetworkName string = 'vnet-base'
param virtualNetworkSubnetName string = 'PublicSubnet'
param virtualNetworkSubnetAddressPrefix string = '10.0.0.0/24'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: virtualNetworkName
}

output virtualNetwork string = virtualNetwork.id

resource natGateway 'Microsoft.Network/natGateways@2022-01-01' = {
  name: natGatewayName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    idleTimeoutInMinutes: idleTimeoutInMinutes
  }
}

resource vnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' = {
  name: virtualNetworkSubnetName
  parent: virtualNetwork
  properties: {
    addressPrefix: virtualNetworkSubnetAddressPrefix
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}