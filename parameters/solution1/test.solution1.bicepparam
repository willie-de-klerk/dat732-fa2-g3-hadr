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
param sRoleAssignmentName = '00482a5a-887f-4fb3-b363-3b7fe8e74483'
param sRoleAssignmentPrincipalType = 'User'
param sRoleDefinitionIdOrName = '00482a5a-887f-4fb3-b363-3b7fe8e74483'


param sSQLAdministratorLoginUserName = 'AzureAdmin' 
@Secure()
param sSQLAdministratorLoginPassword = 'R78Y9iRo71A5710'

// data type: boolean
param bEnableSoftDelete = false

