param logicAppName string
param location string = resourceGroup().location
param testUri string = 'https://azure.status.microsoft/status/'
var workflowSchema = 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location
  properties: {
    state: 'Enabled'
    integrationServiceEnvironment: null
    definition: {
      '$schema': workflowSchema
      contentVersion: '1.0.0.0'
      parameters: {
        testUri: {
          type: 'String'
          defaultValue: testUri
        }
      }
    }
  }
}
