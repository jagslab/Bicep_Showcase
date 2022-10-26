/*
------------------------------------------------
Parameters for Storage Account
------------------------------------------------
*/

@description('Name of Storage Account')
param parStorageAccountName string
@description('Location of Storage Account')
param parLocation string
@description('Tags to be applied')
param parTags object
@description('Gets or sets the SKU name')
param parSku string
@description('Indicates the type of storage account')
param parKind string
@description('The identity of the resource')
param parIdentity string
@description('The access tier is used for billing. The Premium access tier is the default value for premium block blobs storage account type and it cannot be changed for the premium block blobs storage account type')
param parAccessTier string
@description('Allow or disallow public access to all blobs or containers in the storage account. The default interpretation is true for this property.')
param parAllowBlobPublicAccess bool
@description('Allow or disallow cross AAD tenant object replication. The default interpretation is true for this property.')
param parAllowCrossTenantReplication bool
@description('Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet.')
param parAllowedCopyScope string
@description('Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is null, which is equivalent to true')
param parAllowSharedKeyAccess bool

/*
------------------------------------------------
Parameters for SQL Server & Database
------------------------------------------------
*/

@description('SqlServer Name')
param parSqlServerName string
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
Parameters for Public IP
------------------------------------------------
*/
@description('Name of Pulbic IP')
param parPipName string
@description('Pulbic IP Sku Name')
param parSkuName string
@description('Pulbic IP Sku Tier')
param parSkuTier string
@description('Pulbic IP Dynamic of Static IP')
param parPublicIPAllocationMethod string

/*
------------------------------------------------
Parameters for NSG
------------------------------------------------
*/
@description('NSG Name')
param parNsgSnetAppGwName string
@description('NSG Name')
param parNsgSnetwebName string
@description('NSG Security Rules Array')
param parNsgSecurityRules array

/*
------------------------------------------------
Parameters for Vnet
------------------------------------------------
*/

@description('Vnet Name')
param parVnetName string
@description('Vnet Adress Space')
param parVnetAddressPrefixes string
@description('Vnet Subnet ID 0 Name')
param parSubnetName0 string
@description('Vnet Subnet ID 0 Adress Space')
param parSubnet0AddressPrefix string
@description('Vnet Subnet ID 0 Azure Service Endpoints to be used')
param parSubnet0ServiceEndpoint string
@description('Vnet Subnet ID 1 Name')
param parSubnetName1 string
@description('Vnet Subnet ID 1 Adress Space')
param parSubnet1AddressPrefix string

/*
------------------------------------------------
Parameters for Application Gateway
------------------------------------------------
*/
param parUserIDName string
param parAppGwIdentity string
param parMinCapacity int
param parMaxCapacity int
param parfrontendIPConfigurationName string
@description('Name of Appplication Gateway')
param parAppGwName string
@description('Location of Storage Account')
param parSharedRgName string
param parAppGwSkuName string
param parAppGwSkuTier string
param parAppGwFirewallMode string
param parAppGwRuleTypeSet string
param parAppGwRuleSetEnabled bool
param parAppGwRuleSetVersion string
param parFrontEndPortName string
param parFrontEndPortNumber int
param parHttpListenerName string
param parHttpListenerProtocol string
param parRequireServerNameIndication bool
param parBackendAddressPoolName string
param parBackendAdressFqdn string
param parBackendHttpSettingsCollectionName string
param parBackendHttpSettingsCollectionCookieBasedAffinity string
param parBackendHttpSettingsCollectionPortNumber int
param parRequestRoutingRulesName string
param parparRequestRoutingRuleType string
param parSslCertificateName string
param parGatewayIPConfigurationsName string

/*
------------------------------------------------
Storage Account Module
------------------------------------------------
*/

module storageAccount 'storageAccount.bicep' = {
  name: 'deployStorageAccount'
  params: {
    parAccessTier: parAccessTier
    parAllowBlobPublicAccess: parAllowBlobPublicAccess
    parAllowCrossTenantReplication: parAllowCrossTenantReplication
    parAllowSharedKeyAccess: parAllowSharedKeyAccess
    parAllowedCopyScope: parAllowedCopyScope
    parIdentity: parIdentity
    parKind: parKind
    parLocation: parLocation
    parSku: parSku
    parStorageAccountName: parStorageAccountName
    parTags: parTags
  }
}

/*
------------------------------------------------
SQL Server and DB Module
------------------------------------------------
*/

module sqlServer 'sqlServer.bicep' = {
  name: 'deploySqlServerAndDb'
  params: {
    parAdministratorLogin: parAdministratorLogin
    parAdministratorPassword: parAdministratorPassword
    parAdministratorType: parAdministratorType
    parAzureADLogin: parAzureADLogin
    parAzureADLoginPrincipalType: parAzureADLoginPrincipalType
    parAzureADOnlyAuthentication: parAzureADOnlyAuthentication
    parAzureADSid: parAzureADSid
    parIdentityType: parIdentityType
    parLocation: parLocation
    parMinimalTlsVersion: parMinimalTlsVersion
    parPublicNetworkAccess: parPublicNetworkAccess
    parSQLVersion: parSQLVersion
    parSqlServerName: parSqlServerName
    parTags: parTags
    parTenantId: parTenantId
    parSqlDbName: parSqlDbName
    parSqlDbSkuCapacity: parSqlDbSkuCapacity
    parSqlDbSkuName: parSqlDbSkuName
    parSqlDbSkuTier: parSqlDbSkuTier
    parSqlDbCatalogCollation: parSqlDbCatalogCollation
    parSqlDbCollation: parSqlDbCollation
    parSqlDbMaxSizeBytes: parSqlDbMaxSizeBytes
    parSqlDbrequestedBackupStorageRedundancy: parSqlDbrequestedBackupStorageRedundancy
    parSqlDbZoneRedundant: parSqlDbZoneRedundant
    parSqlServerEndIpAddress: parSqlServerEndIpAddress
    parSqlServerFirewallRule: parSqlServerFirewallRule
    parSqlServerStartIpAddress: parSqlServerStartIpAddress
  }
}

/*
------------------------------------------------
Public IP Address Module
------------------------------------------------
*/

module pip 'pip.bicep' = {
  name: 'deployPublicIp'
  params: {
    parLocation:parLocation
    parPipName: parPipName
    parPublicIPAllocationMethod: parPublicIPAllocationMethod
    parSkuName: parSkuName
    parSkuTier: parSkuTier
    parTags: parTags
  }
}

/*
------------------------------------------------
NSG Module
------------------------------------------------
*/

module nsg 'nsg.bicep' = {
  name: 'deployNSGs'
  params: {
    parLocation: parLocation
    parNsgSnetAppGwName: parNsgSnetAppGwName
    parTags: parTags
    parNsgSnetwebName: parNsgSnetwebName
    parNsgSecurityRules: parNsgSecurityRules
  }
}

/*
------------------------------------------------
Vnet Module
------------------------------------------------
*/

module vnet 'vnet.bicep' = {
  name: 'deployVnet'
  params: {
    parLocation: parLocation
    parSubnet0AddressPrefix: parSubnet0AddressPrefix
    parSubnet0ServiceEndpoint: parSubnet0ServiceEndpoint
    parSubnet1AddressPrefix: parSubnet1AddressPrefix
    parSubnetName0: parSubnetName0
    parSubnetName1: parSubnetName1
    parVnetAddressPrefixes: parVnetAddressPrefixes
    parVnetName: parVnetName
    parNsgAppGwId: nsg.outputs.nsgSnetAppGw
    parNsgWebId: nsg.outputs.nsgSnetWeb
  }
}

/*
------------------------------------------------
Application Gateway Module
------------------------------------------------
*/
module appgw 'appgw.bicep' = {
  name: 'deployAppGw'
  params: {
    parAppGwName: parAppGwName
    parAppGwIdentity: parAppGwIdentity
    parLocation: parLocation
    parMaxCapacity: parMaxCapacity
    parMinCapacity: parMinCapacity
    parPipID: pip.outputs.outPublicIp
    parSnetAppGwID: vnet.outputs.outSnetAppGwID
    parTags: parTags
    parUserIDName: parUserIDName
    parfrontendIPConfigurationName: parfrontendIPConfigurationName
    parSharedRgName: parSharedRgName
    parAppGwFirewallMode: parAppGwFirewallMode
    parAppGwRuleSetEnabled: parAppGwRuleSetEnabled
    parAppGwRuleSetVersion: parAppGwRuleSetVersion
    parAppGwRuleTypeSet: parAppGwRuleTypeSet
    parAppGwSkuName: parAppGwSkuName
    parAppGwSkuTier: parAppGwSkuTier
    parBackendAddressPoolName: parBackendAddressPoolName
    parBackendAdressFqdn: parBackendAdressFqdn
    parBackendHttpSettingsCollectionCookieBasedAffinity: parBackendHttpSettingsCollectionCookieBasedAffinity
    parBackendHttpSettingsCollectionName: parBackendHttpSettingsCollectionName
    parBackendHttpSettingsCollectionPortNumber: parBackendHttpSettingsCollectionPortNumber
    parFrontEndPortName: parFrontEndPortName
    parFrontEndPortNumber: parFrontEndPortNumber
    parGatewayIPConfigurationsName: parGatewayIPConfigurationsName
    parHttpListenerName: parHttpListenerName
    parHttpListenerProtocol: parHttpListenerProtocol
    parparRequestRoutingRuleType: parparRequestRoutingRuleType
    parRequestRoutingRulesName: parRequestRoutingRulesName
    parRequireServerNameIndication: parRequireServerNameIndication
    parSslCertificateName: parSslCertificateName
  }
}
