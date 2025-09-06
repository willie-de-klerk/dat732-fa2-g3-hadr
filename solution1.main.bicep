targetScope='subscription'
/* 
  Solution1-(failover-groups)
  file: solution1.main.bicep
  purpose: We are making use of this bicep file as our main bicep file for our first proposed solution.
*/


//Parameters
// data type: array
param arrLocationSecondary array 

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


param sSQLAdministratorLoginUserName string
@secure()
param sSQLAdministratorLoginPassword string
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

// secondary instances

module deploysqlserversecondary 'modules/m-create-sql-srv.bicep' = [for location in arrLocationSecondary: {
  name: '${sSQLServerInstanceName}-bak-${location}'
  params: {
    sName: '${sSQLServerInstanceName}-bak-${location}'
    sAdministratorLoginPassword: sSQLAdministratorLoginPassword
    sAdministratorLoginUserName: sSQLAdministratorLoginUserName
    sLocation: location
    sPublicNetworkAccessEnabled: sPublicNetworkAccessEnabled
    sIsIPv6Enabled: sIsIPv6Enabled
    sMinimalTLSVersion: sMinimalTLSVersion
  }
  scope: az.resourceGroup(sResourceGroupName)
  dependsOn: [createresourcegroup]
}]





// author: @willie-de-klerk
