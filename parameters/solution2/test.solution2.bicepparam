using '../../solution2.main.bicep'
/* 
  file: parameters/solution2/test.solution2.bicepparam
  purpose: We are making use of this bicep parameter file to specify our parameters for our testing environment.
  A quick revision on parameter types: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameters
  What's a bicep parameter file? https://youtu.be/IL4P_1SrJng?si=zrAWtaqOQzcGhYkS
*/

// Parameters
// data type: array

param arrLocationSecondary = [
  {location: 'uksouth', backup_storage_redundancy: 'Local' , secondary_type: 'Geo'} 
  {location: 'germanywestcentral',backup_storage_redundancy: 'Local', secondary_type: 'Standby' }]

/*
  secondary_type: Specify that the database is a secondary type. It can be either:
  'Geo'
  'Named'
  'Standby' It allows for disaster recovery in anticipation of a failover event. Cannot serve read queries. Does not incur addiotnal licencing cost (upto 40% savings).
*/

param arrResourceTags = [ 
  {name: 'env', value: 'test'} 
  {name: 'solution', value: '2'}]
  

// data type: object
param objDatabaseSku = {sku_name: 'GP_Gen5_2', tier: 'GeneralPurpose'}

// data type: string
param sLocationPrimary = 'southafricanorth'
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

// data type: boolean
param bEnableSoftDelete = false

