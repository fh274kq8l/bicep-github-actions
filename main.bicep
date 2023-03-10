// =========== main.bicep ===========
targetScope = 'subscription'

param location string = deployment().location

param rgName string

// Log Analytics Workspace
param workspaceName string
param workspaceSku string
param workspaceRetentionDays int

// Sentinel Solution
param solutionName string

// resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
//   name: 'rg-bicep-github-actions'
//   location: location
// }

module rg 'modules/rg.bicep' = {
  name: rgName
  params: {
    rgName: rgName
    location: location
  } 
}

module sentinelModule 'modules/sentinelModule.bicep' = {
  scope: resourceGroup(rg.name)
  name: workspaceName
  params: {
    location: location
    workspaceName: workspaceName
    workspaceSku: workspaceSku
    workspaceRetentionDays: workspaceRetentionDays
    solutionName: solutionName
  }
  dependsOn: [
    rg
  ]
}



// resource sentinelWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
//   name: workspaceName
//   location: location
//   properties: {
//     sku: {
//       name: workspaceSku
//     }
//     retentionInDays: workspaceRetentionDays
//   }
// }

// resource sentinelSolution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
//   name: solutionName
//   location: location
//   properties: {
//     workspaceResourceId: sentinelWorkspace.id
//   }
//   plan: {
//     name: solutionName
//     publisher: 'Microsoft'
//     product: 'OMSGallery/SecurityInsights'
//     promotionCode: ''
//   }
// }
