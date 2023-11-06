@description('Location for all resources.')
param location string = resourceGroup().location

@description('The name of the SQL logical server.')
param serverName string = uniqueString('sql', resourceGroup().id)
@description('The name of the SQL Database.')
param databaseName string = 'mySampleDatabase'
@description('The administrator username of the SQL logical server.')
param administratorLogin string = 'sqladmin'

@description('The name of the user assigned identity.')
param identityName string = uniqueString('aib-', 'sqlserver-${resourceGroup().id}')

param skuName string = 'GP_Gen5_2'
param skuTier string = 'GeneralPurpose'
param databaseFamily string = 'Gen5'
param collation string = 'SQL_Latin1_General_CP1_CI_AS'
param restrictedAccess string = 'Enabled'
param publicNetworkAccess string = 'Disabled'
param databaseZoneRedundant bool = false

param databaseCapacity int = 1
param databaseMaxSkuSize string = '20GB'
param databaseLicenseType string = 'LicenseIncluded'

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: identityName
  location: location
}

output identityResourceId string = userAssignedIdentity.id

resource sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: serverName
  location: location
  identity: {
    type: 'userAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentity.id}': {}
    }
  }
  properties: {
    administrators:{
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: true
      login: administratorLogin
      principalType: 'User'
      tenantId: subscription().tenantId
    }
    minimalTlsVersion: '1.2'
    publicNetworkAccess: publicNetworkAccess
    restrictOutboundNetworkAccess: restrictedAccess
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-05-01-preview' = {
  name: databaseName
  location: location
  sku: {
    name: skuName
    tier: skuTier
    capacity: databaseCapacity
    family: databaseFamily
    size: databaseMaxSkuSize
  }
  properties: {
    collation: collation
    zoneRedundant: databaseZoneRedundant
    catalogCollation: collation
    licenseType: databaseLicenseType
  }
}
