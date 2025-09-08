targetScope='subscription'
/* 
  Solution2-(geo-replication)
  file: solution3.main.bicep
  purpose: We are making use of this bicep file as our main bicep file for our third proposed solution.

*/


//Parameters
// A quick revision: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameters
// data type: array
param arrResourceTags array
// data type: object
@metadata({sku_name: 'GP_Gen5_2', tier: 'GeneralPurpose'})
param objDatabaseSku object
@metadata({diff_backup_interval_in_hours: '1', retention_days: '7'})
param objShortTermBackupRetentionPolicy object
// data type: string 
param sResourceGroupName string
param sKeyVaultName string
param sLocationPrimary string 
param sRoleAssignmentName string 
param sRoleAssignmentPrincipalType string
param sRoleDefinitionIdOrName string
param sSQLServerInstanceName string
      //SQL Server Specific
param sMinimalTLSVersion string
param sPublicNetworkAccessEnabled string 
param sIsIPv6Enabled string
      //Database Specific
param sDatabaseName string
param sRequestedBackupStorageRedundancy string 

param sSQLAdministratorLoginUserName string
@secure()
param sSQLAdministratorLoginPassword string

  // Long term policy

@description('The montly retention policy for an LTR backup in an ISO 8601 format.')
param sMontlyRetention string

@description('The weekly retention policy for an LTR backup in an ISO 8601 format.')
param sWeeklyRetention string

@description('The yearly retention policy for an LTR backup in an ISO 8601 format. example value: P5Y')
param sYearlyRetention string

// data type: integer
@allowed([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,31,32,33,34,35,36,37,38,39,40,41,42,43,45,46,47,48,49,50,51,52])
@description('The week of year to take the yearly backup in an ISO 8601 format.	')
param iWeekOfYear int

// data type: boolean

param bEnableSoftDelete bool


//Modules 

  // Resource Group
module createresourcegroup 'modules/m-create-resource-group.bicep' = {
  name: sResourceGroupName
  params: {
    sLocation: sLocationPrimary
    sResourceGroupName: sResourceGroupName
  }
}


  // Azure Key Vault 
module deploykeyvault '.bicep/m-create-keyvault.bicep' = {
  name: sKeyVaultName
  params:{
    bEnableSoftDelete: bEnableSoftDelete
    sVaultName: sKeyVaultName
    sLocation: sLocationPrimary
    sRoleAssignmentName: sRoleAssignmentName
    sRoleAssignmentPrincipalId: az.deployer().objectId
    sRoleAssignmentPrincipalType: sRoleAssignmentPrincipalType
    sRoleDefinitionIdOrName: sRoleDefinitionIdOrName
  }
  scope: resourceGroup(sResourceGroupName)
  dependsOn: [createresourcegroup]
}

// Azure Key Vault Secret
module createtestsecret '.bicep/m-create-secret.bicep' = {
  params: {
    sVaultName: sKeyVaultName
    sSecretName: sSQLAdministratorLoginUserName
    sSecretValue: sSQLAdministratorLoginPassword
  }
  scope: resourceGroup(sResourceGroupName)
  dependsOn: [deploykeyvault]
} //We cannot reference the password from the vault in this bicep file, since we are creating the vault in this file. 

// primary  SQL server resource instance

module deploysqlserver 'modules/m-create-sql-srv.bicep' = {
  name: sSQLServerInstanceName
  params:{
    sName: sSQLServerInstanceName
    sAdministratorLoginUserName: sSQLAdministratorLoginUserName
    sAdministratorLoginPassword: sSQLAdministratorLoginPassword
    sIsIPv6Enabled: sIsIPv6Enabled
    sLocation: sLocationPrimary
    sMinimalTLSVersion: sMinimalTLSVersion
    sPublicNetworkAccessEnabled: sPublicNetworkAccessEnabled
  }
  scope: az.resourceGroup(sResourceGroupName)
  
  dependsOn: [createresourcegroup]
}


// primary database 

module deploydbprimary 'modules/m-create-database-primary.bicep' = {
  params: {
    sLocation: sLocationPrimary
    sDatabaseName: sDatabaseName
    sRequestedBackupStorageRedundancy: sRequestedBackupStorageRedundancy
    sSQLServerName: sSQLServerInstanceName
    sDatabaseSkuName: objDatabaseSku.sku_name
    sDatabaseSkuTier: objDatabaseSku.tier
  }
  dependsOn: [deploysqlserver]
  scope: az.resourceGroup(sResourceGroupName)
}

// add resource tagging policies

module policy 'modules/m-policy-append-tag.bicep' = {
  params: {
    arrResourceTags: arrResourceTags
    
  }
  scope: az.resourceGroup(sResourceGroupName)
  dependsOn: [createresourcegroup]
}

// configure short term database backup retention policy

module backuppolicy 'modules/m-create-database-backup-policy-short-term.bicep' = {
  params: {
    sSQLServerInstanceName: sSQLServerInstanceName
    sDatabaseName: sDatabaseName
    iRetentionDays: objShortTermBackupRetentionPolicy.retention_days
    iDiffBackupIntervalInHours: objShortTermBackupRetentionPolicy.diff_backup_interval_in_hours
  }
  scope: az.resourceGroup(sResourceGroupName)
  dependsOn: [deploydbprimary]
}

module backuppolicylong 'modules/m-create-database-backup-policy-long-term.bicep' = {
  params: {
    sDatabaseName: sDatabaseName
    sSQLServerInstanceName: sSQLServerInstanceName
    sWeeklyRetention: sWeeklyRetention
    sMontlyRetention: sMontlyRetention
    sYearlyRetention: sYearlyRetention
    iWeekOfYear: iWeekOfYear
  }
  scope: az.resourceGroup(sResourceGroupName)
  dependsOn: [backuppolicy]
} // Example values: https://learn.microsoft.com/en-us/rest/api/sql/long-term-retention-policies/list-by-database?view=rest-sql-2023-08-01&tabs=HTTP#:~:text=%7B%0A%20%20%22value%22,%3A%205%0A%20%20%20%20%20%20%7D%0A%20%20%20%20%7D%0A%20%20%5D%0A%7D

// author: @willie-de-klerk
