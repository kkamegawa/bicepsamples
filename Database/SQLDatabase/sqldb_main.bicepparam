using 'sqldb_main.bicep'

param databaseName = 'mySampleDatabase'
@description('The administrator username of the SQL logical server.')
param administratorLogin = 'sqladmin'

param skuName = 'Basic'
param skuTier = 'GeneralPurpose'
param databaseFamily = 'Gen5'
param collation = 'SQL_Latin1_General_CP1_CI_AS'
param restrictedAccess = 'Enabled'
param publicNetworkAccess = 'Disabled'
param databaseZoneRedundant = false

param databaseCapacity = 1
param databaseMaxSkuSize = '5GB'
param databaseLicenseType = 'LicenseIncluded'
