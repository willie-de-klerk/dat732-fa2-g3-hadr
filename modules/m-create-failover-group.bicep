/* 
  file: modules/m-create-failover-group.bicep
  purpose: We are making use of this bicep file as a module that can be used to create the failover group for our first solution.
  link: https://learn.microsoft.com/en-gb/azure/templates/microsoft.sql/servers/failovergroups?pivots=deployment-language-bicep
  Extra helpful video (Betabit): https://youtu.be/rhGdZuHJK6M?si=iRqtRL4uC0zHYZRc
*/

@description('value: exampledb')
param sPrimaryDatabaseName string

@description('value: example-srv')
param sPrimarySQLServerName string
@description('example-srv-bak-uksouth')
param sSecondarySQLServerName string

resource primaryserver 'Microsoft.Sql/servers@2024-11-01-preview' existing = {
  name: sPrimarySQLServerName
}

resource failovergroup 'Microsoft.Sql/servers/failoverGroups@2024-11-01-preview' = {
  name: '${sPrimarySQLServerName}-fog'
  parent: primaryserver
  properties: {
    databases: [
      resourceId('Microsoft.Sql/servers/databases','${sPrimarySQLServerName}' ,'${sPrimaryDatabaseName}')
    ]
    partnerServers: [
      {
        id: resourceId('Microsoft.Sql/servers', '${sSecondarySQLServerName}')
      }
    ]
    readWriteEndpoint: {
      failoverPolicy: 'Automatic'
      failoverWithDataLossGracePeriodMinutes: 60
    }
  }
}

