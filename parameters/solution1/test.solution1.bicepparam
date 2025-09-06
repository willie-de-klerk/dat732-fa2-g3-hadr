using '../../solution1.main.bicep'
/* 
  file: parameters/solution1/dev.solution1.bicepparam
  purpose: We are making use of this bicep parameter file to specify our parameters for our testing environment.
*/

// Parameters

// data type: string
param sLocationPrimary = 'southafricanorth'
param sResourceGroupName = 'g3hadr-rg'
param sKeyVaultName = 'dat732group3fa2keyvault'

// data type: boolean
param bEnableSoftDelete = false
