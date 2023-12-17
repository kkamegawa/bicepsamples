using './function_consumption_public.bicep'

@description('Storage Account type')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
])
param storageAccountType = 'Standard_LRS'

@description('Location for all resources.')
param location = 'eastus'

@description('Location for Application Insights')
param appInsightsLocation = 'eastus'

@description('The language worker runtime to load in the function app.')
@allowed([
  'node'
  'dotnet'
  'java'
])
param runtime = 'dotnet'
