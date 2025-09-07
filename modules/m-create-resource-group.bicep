/* 
  file: modules/m-create-resource-group.bicep
  purpose: We are making use of this bicep file as a module that can be used to create resource groups.
  link: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/create-resource-group
*/

targetScope='subscription'

//Parameters

//data type: string
param sResourceGroupName string
param sLocation string

resource newRG 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: sResourceGroupName
  location: sLocation
}

