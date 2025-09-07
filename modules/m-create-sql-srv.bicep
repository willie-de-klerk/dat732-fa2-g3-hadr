/* 
  file: modules/m-create-sql-srv.bicep
  purpose: We are making use of this bicep file as a module, to create our sql server resource instances.
*/

//Parameters

//data type: string 

param sMinimalTLSVersion string
param sPublicNetworkAccessEnabled string 
param sLocation string 
param sIsIPv6Enabled string
param sName string
param sAdministratorLoginUserName string 
@secure()
param sAdministratorLoginPassword string

 

resource deploysqlserver 'Microsoft.Sql/servers@2024-11-01-preview' = {
  location: sLocation
  name: sName
  properties: {
    administratorLogin: sAdministratorLoginUserName
    administratorLoginPassword: sAdministratorLoginPassword
    minimalTlsVersion: sMinimalTLSVersion
    publicNetworkAccess: sPublicNetworkAccessEnabled
    isIPv6Enabled: sIsIPv6Enabled
  }
}

/*
More info: https://learn.microsoft.com/en-us/azure/azure-sql/database/single-database-create-bicep-quickstart?view=azuresql&tabs=CLI
*/
