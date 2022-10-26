/*
------------------------------------------------
Parameters
------------------------------------------------
*/

@description('SqlServer Name')
param parSqlServerName string
@description('SqlServer Location')
param parLocation string
@description('Tags to be applied')
param parTags object
@description('Managed Identity for SQL Server Type, System or User Assigned')
param parIdentityType string
@description('SQL Server version')
param parSQLVersion string
@description('SQL Server Public Network Access')
param parPublicNetworkAccess string
@description('Minimal TLS Vesrion To Be Used')
param parMinimalTlsVersion string
@description('SQL Server Administrator Login')
@secure()
param parAdministratorLogin string
@description('SQL Server Administrator Password')
@secure()
param parAdministratorPassword string
@description('SQL Server Admin Type i.e. Local or AzureAD')
param parAdministratorType string
@description('SQL Server Accepted Authentication Types')
param parAzureADOnlyAuthentication bool
@description('SQL Server Azure AD Login To Be Used')
param parAzureADLogin string
@description('SQL Server Azuer AD Group, User or Principal ID To Be Used')
param parAzureADLoginPrincipalType string
@description('SQL Server Azure AD Login ObjectID')
@secure()
param parAzureADSid string
@description('Azure AD Tenant ID')
@secure()
param parTenantId string
@description('SQL Database Name')
param parSqlDbName string
@description('The name of the Database SKU, typically, a letter + Number code, e.g. P3.')
param parSqlDbSkuName string
@description('SQL Database Tier Name')
param parSqlDbSkuTier string
@description('SQL Database Capacity of the particular SKU')
param parSqlDbSkuCapacity int
@description('The collation of the database')
param parSqlDbCollation string
@description('The max size of the database expressed in bytes')
param parSqlDbMaxSizeBytes int
@description('Collation of the metadata catalog')
param parSqlDbCatalogCollation string
@description('Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones')
param parSqlDbZoneRedundant bool
@description('The storage account type to be used to store backups for this database.')
param parSqlDbrequestedBackupStorageRedundancy string
@description('Name of SQL Server Firewall Rule')
param parSqlServerFirewallRule string
@description('Start of IP Adress range for SQL Server Firewall Rule')
param parSqlServerStartIpAddress string
@description('End of IP Adress range for SQL Server Firewall Rule')
param parSqlServerEndIpAddress string

/*
------------------------------------------------
SQL Server
------------------------------------------------
*/

resource sqlServer 'Microsoft.Sql/servers@2021-05-01-preview' = {
 name: parSqlServerName
 location: parLocation  
 tags: parTags
  identity: {
   type: parIdentityType
 }
 properties: {  
   version: parSQLVersion
   publicNetworkAccess: parPublicNetworkAccess
   minimalTlsVersion: parMinimalTlsVersion    
   administratorLogin: parAdministratorLogin
   administratorLoginPassword:parAdministratorPassword
   administrators: {
      administratorType: parAdministratorType
      azureADOnlyAuthentication: parAzureADOnlyAuthentication
      login: parAzureADLogin
      principalType: parAzureADLoginPrincipalType
      sid: parAzureADSid
      tenantId: parTenantId
   }
 }
}
output outsqlServerName string = sqlServer.name
output outsqlServerNameFQDN string = sqlServer.properties.fullyQualifiedDomainName
output outsqlServerIdentity string = sqlServer.identity.principalId

/*
------------------------------------------------
SQL DB
------------------------------------------------
*/

resource sqlDb 'Microsoft.Sql/servers/databases@2021-05-01-preview' = {
  parent: sqlServer
  name: parSqlDbName
  location: parLocation
  tags: parTags
  sku: {
    name: parSqlDbSkuName
    tier: parSqlDbSkuTier
    capacity: parSqlDbSkuCapacity
  }  
  properties: {    
    collation: parSqlDbCollation
    maxSizeBytes: parSqlDbMaxSizeBytes
    catalogCollation: parSqlDbCatalogCollation
    zoneRedundant: parSqlDbZoneRedundant
    requestedBackupStorageRedundancy: parSqlDbrequestedBackupStorageRedundancy
  }
  
 }
 output osqlServerDbName string = sqlDb.name
 
 resource sqlFirewallRule 'Microsoft.Sql/servers/firewallrules@2020-11-01-preview' = {
  parent: sqlServer
  name: parSqlServerFirewallRule
  properties: {
    startIpAddress: parSqlServerStartIpAddress
    endIpAddress: parSqlServerEndIpAddress
  }
 }
