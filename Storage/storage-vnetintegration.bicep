@description('Network Name')
param vnetName string

@description('resource location')
param location string = resourceGroup().location

@description('storage account name')
param storageName string

@description('key expiration period days')
param keyExpirationPeriodInDays int = 30

@description('SAS Expiration Period')
param sasExpirationPeriod string ='03.00:00:00'

module vnetBase '../Modules/Shared-vnet.bicep' ={
  name: 'sharedvnetdeploy'
  params:{
    vnetName: vnetName
    location: location
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: vnetName
}

var storageSubnetId = resourceId('Microsoft.Network/VirtualNetworks/subnets', vnetName, 'storage')

resource privateBlobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  name: 'privateContainer'
  parent: privateBlob
  properties: {
    denyEncryptionScopeOverride: true
    enableNfsV3AllSquash: false
    enableNfsV3RootSquash: false
    immutableStorageWithVersioning: {
      enabled: true
    }
    metadata: {}
    publicAccess: 'None'
  }
}

resource privateEndpointforStorage 'Microsoft.Network/privateEndpoints@2022-01-01' = {
  name: 'private-endpoint-${storageName}'
  properties: {
    customDnsConfigs: [
      {
        fqdn: 'string'
        ipAddresses: [
          'string'
        ]
      }
    ]
    customNetworkInterfaceName: 'string'
    ipConfigurations: [
      {
        name: 'string'
        properties: {
          groupId: 'string'
          memberName: 'string'
          privateIPAddress: 'string'
        }
      }
    ]
    manualPrivateLinkServiceConnections: [
      {
        id: 'string'
        name: 'string'
        properties: {
          groupIds: [
            'string'
          ]
          privateLinkServiceConnectionState: {
            actionsRequired: 'string'
            description: 'string'
            status: 'string'
          }
          privateLinkServiceId: 'string'
          requestMessage: 'string'
        }
      }
    ]
    privateLinkServiceConnections: [
      {
        id: 'string'
        name: 'string'
        properties: {
          groupIds: [
            'string'
          ]
          privateLinkServiceConnectionState: {
            actionsRequired: 'string'
            description: 'string'
            status: 'string'
          }
          privateLinkServiceId: 'string'
          requestMessage: 'string'
        }
      }
    ]
    subnet: {
      id: storageSubnetId
    }
  }
}

resource privateBlob 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' = {
  name: 'default'
  parent: vnetIntegrationStorage
  properties: {
    automaticSnapshotPolicyEnabled: false
    changeFeed: {
      enabled: true
      retentionInDays: 30
    }
    containerDeleteRetentionPolicy: {
      allowPermanentDelete: true
      days: 3
      enabled: true
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: true
      days: 3
      enabled: true
    }
    isVersioningEnabled: true
    lastAccessTimeTrackingPolicy: {
      enable: false
      name: 'AccessTimeTracking'
      trackingGranularityInDays: 1
    }
    restorePolicy: {
      days: 3
      enabled: true
    }
  }
}

resource privateStorageEndpoint 'Microsoft.Storage/storageAccounts/privateEndpointConnections@2022-05-01' = {
  name: 'private-endpoint-${storageName}'
  parent: vnetIntegrationStorage
  properties: {
    privateLinkServiceConnectionState: {
      actionRequired: 'string'
      description: 'private endpoint for Storage'
      status: 'Approved'
    }
  }
}

resource vnetIntegrationStorage 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageName
  location: location
  dependsOn: [
    virtualNetwork
  ]
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    encryption: {
      keySource: 'Microsoft.Storage'
      requireInfrastructureEncryption: true
    }
    isHnsEnabled: false
    isLocalUserEnabled: false
    isNfsV3Enabled: false
    isSftpEnabled: false
    keyPolicy: {
      keyExpirationPeriodInDays: keyExpirationPeriodInDays
    }
    largeFileSharesState: 'Disabled'
    minimumTlsVersion: 'TLS1_2'
    publicNetworkAccess: 'Disabled'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
      virtualNetworkRules: [
        {
          action: 'Allow'
          id: virtualNetwork.id
        }
      ]
    }
    sasPolicy: {
      expirationAction: 'Log'
      sasExpirationPeriod: sasExpirationPeriod
    }
    supportsHttpsTrafficOnly: true
  }
}
