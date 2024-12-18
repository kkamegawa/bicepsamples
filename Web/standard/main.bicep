param logicAppName string
param location string = resourceGroup().location
param appServicePlanSku string = 'Standard'

var appServicePlanName = '${logicAppName}-asp'

var name = 'WS1'

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: name
    tier: appServicePlanSku
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

resource logicAppWorkflow 'Microsoft.Logic/workflows@2019-05-01' = {
  name: '${logicAppName}-workflow'
  location: location
  properties: {
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      actions: {}
      contentVersion: '1.0.0.0'
      outputs: {}
      triggers: {}
    }
    integrationServiceEnvironment: {
      id: appServicePlan.id
    }
    parameters: {}
    state: 'Enabled'
  }
}
