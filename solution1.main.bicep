targetScope='subscription'
/* 
  Solution1-(failover-groups)
  file: solution1.main.bicep
  purpose: We are making use of this bicep file as our main bicep file for our first proposed solution.
*/


//Parameters

// data type: string 
param sResourceGroupName string
param sKeyVaultName string
param sLocationPrimary string 
// data type: boolean
param bEnableSoftDelete bool


//Modules 

  // Resource Group
module createresourcegroup 'modules/m-create-resource-group.bicep' = {
  params: {
    sLocation: sLocationPrimary
    sResourceGroupName: sResourceGroupName
  }
}

  // Azure Key Vault 
module deploykeyvault '.bicep/m-create-keyvault.bicep' = {
  params:{
    bEnableSoftDelete: bEnableSoftDelete
    sVaultName: sKeyVaultName
    sLocation: sLocationPrimary
  }
  scope: resourceGroup(sResourceGroupName)
  dependsOn: [createresourcegroup]
}





// author: @willie-de-klerk
