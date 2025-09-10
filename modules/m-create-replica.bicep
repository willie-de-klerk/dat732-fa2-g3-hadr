/* 
  file: modules/m-create-replica.bicep
  purpose: We are making use of this bicep file as a module that can be used to create geo-replicas for our second solution.
  link: https://learn.microsoft.com/en-gb/azure/templates/microsoft.sql/servers/failovergroups?pivots=deployment-language-bicep
*/

//Parameters 

// data type: string 

@description('value: uksouth')
param sLocation string

@description('value: logistics-srv')
param sSQLServerName string

@description('value: Local')
param sRequestedBackupStorageStrategy string

@description('value: logisticsdb')
param sDatabaseName string

param sDatabaseSKUName string

param sDatabaseSKUTier string

@description('value: g3-hadr-rg')
param sResourceGroupName string



param sSecondaryType string

resource sqlsrv 'Microsoft.Sql/servers@2024-11-01-preview' existing = {
  name: sSQLServerName
}

resource logisticsdb 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  name: '${sSQLServerName}-bak-${sLocation}${sDatabaseName}'
  properties: {
    requestedBackupStorageRedundancy: sRequestedBackupStorageStrategy
    createMode: 'Secondary'
    secondaryType: sSecondaryType
    sourceDatabaseId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${sResourceGroupName}/providers/Microsoft.SQL/servers/logistics-srv/databases/${sDatabaseName}/'
  }
  location: sLocation
  parent: sqlsrv
  sku: {
    name: sDatabaseSKUName
    tier: sDatabaseSKUTier
  }
}
