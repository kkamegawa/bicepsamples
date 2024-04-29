//create managed identity
param location string = resourceGroup().location
param networkRoleName string = guid(subscription().subscriptionId, 'networkRoleAssignment')
param managedIdentityName string

resource networkRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' = {
  name: networkRoleName
  properties: {
    roleName: 'Network Contributor'
    description: 'Lets you manage networks, but not access to them.'
    assignableScopes: [
      subscription().subscriptionId
    ]
    permissions: [
      {
        actions: [
          'Microsoft.Network/*'
        ]
        notActions: []
      }
    ]
  }
}

resource networkRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: networkRoleName
  scope: resourceGroup()
  properties: {
    roleDefinitionId: networkRoleDefinition.id
    principalId: managedIdentity.properties.principalId
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
  name: managedIdentityName
  location: location
}

output managedIdentityPrincipalId string = managedIdentity.properties.principalId
