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

// author: @willie-de-klerk
