@description('Network location')
param location string = resourceGroup().location

@description('storage account name')
param storageName string

@description('Public Internet Access')
param publicInternetAccess bool = true

@description('key expiration period days')
param keyExpirationPeriodInDays int = 30

@description('SAS Expiration Period')
param sasExpirationPeriod string ='03.00:00:00'

var containers =[
  {
    name: 'publiccontainer'
    publicAccess: 'Blob'
  }
  {
    name: 'containeraccess'
    publicAccess: 'Container'
  }
  {
    name: 'noneaccess'
    publicAccess: 'None'
  }
]

resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = [for container in containers: {
  name: container.name
  parent: storageBlobService
  properties: {
    publicAccess: container.publicAccess
  }
}]

resource storageBlobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  name: 'default'
  parent: strorageAccount
  properties: {
    changeFeed: {
      enabled: true
      retentionInDays: 1
    }
    containerDeleteRetentionPolicy: {
      allowPermanentDelete: true
      days: 1
      enabled: true
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: true
      days: 1
      enabled: true
    }
    isVersioningEnabled: true
  }
}

resource strorageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: publicInternetAccess
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
    publicNetworkAccess: 'Enabled'
    sasPolicy: {
      expirationAction: 'Log'
      sasExpirationPeriod: sasExpirationPeriod
    }
    supportsHttpsTrafficOnly: true
  }
}
