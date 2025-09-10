using '../../solution3.main.bicep'
/* 
  file: parameters/solution3/test.solution3.bicepparam
  purpose: We are making use of this bicep parameter file to specify our parameters for our testing environment.
  A quick revision on parameter types: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameters
  What's a bicep parameter file? https://youtu.be/IL4P_1SrJng?si=zrAWtaqOQzcGhYkS
*/

// Parameters
// data type: array
param arrResourceTags = [ 
  {name: 'env', value: 'test'} 
  {name: 'solution', value: '3'}]
  

// data type: object
param objDatabaseSku = {sku_name: 'GP_Gen5_2', tier: 'GeneralPurpose'}

param objShortTermBackupRetentionPolicy = {diff_backup_interval_in_hours: 12, retention_days: 7}

// data type: string
param sLocationPrimary = 'austriaeast'
param sResourceGroupName = 'group3hadr-rg'
param sKeyVaultName = 'dat732group3fa2keyvault'
param sRoleAssignmentName = '00482a5a-887f-4fb3-b363-3b7fe8e74483'
param sRoleAssignmentPrincipalType = 'User'
param sRoleDefinitionIdOrName = '00482a5a-887f-4fb3-b363-3b7fe8e74483'
param sSQLServerInstanceName = 'logistics-srv'

  //SQL Server Instance Specific
param sMinimalTLSVersion = '1.2'
param sPublicNetworkAccessEnabled = 'Enabled'
param sIsIPv6Enabled = 'Disabled'
  // Database Specific 
param sDatabaseName = 'logisticsdb'
param sRequestedBackupStorageRedundancy = 'Local'

param sSQLAdministratorLoginUserName = 'AzureAdmin' 
@Secure()
param sSQLAdministratorLoginPassword = 'R78Y9iRo71A5710'

    // Long Term Backup Policy
@description('The montly retention policy for an LTR backup in an ISO 8601 format, example value: P1Y')
param sMontlyRetention = 'P1Y'

@description('The weekly retention policy for an LTR backup in an ISO 8601 format.')
param sWeeklyRetention = 'P1M'

@description('The yearly retention policy for an LTR backup in an ISO 8601 format. example value: P5Y')
param sYearlyRetention = 'P1Y'

@allowed([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,31,32,33,34,35,36,37,38,39,40,41,42,43,45,46,47,48,49,50,51,52])
@description('The week of year to take the yearly backup in an ISO 8601 format.	')
param iWeekOfYear = 5

// data type: boolean
param bEnableSoftDelete = false

