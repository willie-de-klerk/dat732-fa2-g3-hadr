/* 
  file: modules/m-create-database-backup-policy-long-term.bicep
  purpose: We are making use of this bicep file as a module that can be used to create a long term data backup policy.
  link: https://learn.microsoft.com/en-gb/azure/templates/microsoft.sql/servers/databases/backuplongtermretentionpolicies?pivots=deployment-language-bicep
  */

//Parameters

// data type: string
@description('Name of the database to which the policy will apply to.')
param sDatabaseName string

  //Part of the policy property parameters.
@description('Name of the sql server on which the database lives.')
param sSQLServerInstanceName string

@description('The montly retention policy for an LTR backup in an ISO 8601 format, example value: P1Y')
param sMontlyRetention string

@description('The weekly retention policy for an LTR backup in an ISO 8601 format. example value: P1M')
param sWeeklyRetention string

@description('The yearly retention policy for an LTR backup in an ISO 8601 format. example value: P5Y')
param sYearlyRetention string
// data type: int

@allowed([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,31,32,33,34,35,36,37,38,39,40,41,42,43,45,46,47,48,49,50,51,52])
@description('The week of year to take the yearly backup in an ISO 8601 format.	')
param iWeekOfYear int

resource database 'Microsoft.Sql/servers/databases@2024-11-01-preview' existing = {
  name: '${sSQLServerInstanceName}/${sDatabaseName}'
}
 
resource backupShortTermRetentionPolicy 'Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies@2024-11-01-preview' = {
  parent: database
  name: 'default'
  properties: {
    monthlyRetention: sMontlyRetention
    weeklyRetention: sWeeklyRetention
    yearlyRetention: sYearlyRetention
    weekOfYear: iWeekOfYear
  }
}
