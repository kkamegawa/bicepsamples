param logicAppName string
param location string = resourceGroup().location

var appServicePlanName = '${logicAppName}-asp'

var name = 'WS1'

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: name
    tier: 'Standard'
  }
  kind: 'functionapp'
}

resource logicApp 'Microsoft.Logic/integrationAccounts@2019-05-01' = {
  name: logicAppName
  location: location
  properties: {
    integrationServiceEnvironment: null
    state: 'Enabled'
  }
  sku: {
    name: 'Standard'
  }
}
