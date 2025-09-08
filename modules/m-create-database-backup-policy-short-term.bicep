/* 
  file: modules/m-create-database-backup.bicep
  purpose: We are making use of this bicep file as a module that can be used to create a short term database backup retention policy.
  link: https://learn.microsoft.com/en-gb/azure/templates/microsoft.sql/servers/databases/backupshorttermretentionpolicies?pivots=deployment-language-bicep
*/

//Parameters

// data type: string
param sDatabaseName string
param sSQLServerInstanceName string
// data type: int

param iDiffBackupIntervalInHours int

param iRetentionDays int

resource database 'Microsoft.Sql/servers/databases@2024-11-01-preview' existing = {
  name: '${sSQLServerInstanceName}/${sDatabaseName}'
}
 
resource backupShortTermRetentionPolicy 'Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies@2024-11-01-preview' = {
  properties: {
    diffBackupIntervalInHours: iDiffBackupIntervalInHours
    retentionDays: iRetentionDays
  }
  name: 'default'
  parent:  database
}
