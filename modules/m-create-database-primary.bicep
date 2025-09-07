/* 
  file: modules/m-create-database-primary.bicep
  purpose: We are making use of this bicep file as a module that can be used to create the primary database instance.
  link: https://learn.microsoft.com/en-us/azure/templates/microsoft.sql/servers/databases?pivots=deployment-language-bicep
*/

//Parameters

// data type: string
param sSQLServerName string
param sRequestedBackupStorageRedundancy string
param sDatabaseName string
param sLocation string
//param sSampleName string
param sDatabaseSkuTier string
param sDatabaseSkuName string

resource sqlsrv 'Microsoft.Sql/servers@2024-11-01-preview' existing = {
  name: sSQLServerName
}

resource primarydb 'Microsoft.Sql/servers/databases@2024-11-01-preview' = {
  name: sDatabaseName
  location: sLocation
  properties: {
    requestedBackupStorageRedundancy: sRequestedBackupStorageRedundancy
    //sampleName: sSampleName
  }
  parent: sqlsrv
  sku: {
    name: sDatabaseSkuName
    tier: sDatabaseSkuTier
  }
}
