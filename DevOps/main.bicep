param devCenterName string
param location string = 'eastus'
param userAssignedIdentityName string = 'msiforDevCenterIdentity'
param devCenterProjectName string = 'devCenterProjectName'
param maxDevBoxesPerUser int = 1
param devOpsPoolName string = 'devOpsPoolName'

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
  name: userAssignedIdentityName
  location: location
}

resource devCenter 'Microsoft.DevCenter/devcenters@2024-07-01-preview' = {
  name: devCenterName
  location: location
  identity: {
    type: 'userAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentity.id}': {}
    }
  }
}

resource devCenterProject 'Microsoft.DevCenter/projects@2024-07-01-preview' = {
  name: devCenterProjectName
  location: location
  properties: {
    description: 'string'
    devCenterId: devCenter.id
    maxDevBoxesPerUser: maxDevBoxesPerUser
  }
}

resource devOpsPool 'Microsoft.DevCenter/projects/pools@2024-07-01-preview' = {
  name: devOpsPoolName
  location: location
  parent: devCenterProject
  properties: {
  }
}
