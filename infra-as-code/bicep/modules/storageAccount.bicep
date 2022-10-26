/*
------------------------------------------------
Parameters
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
Storage Account
------------------------------------------------
*/

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: parStorageAccountName
  location: parLocation
  tags: parTags
  sku: {
    name: parSku
  }
  kind: parKind
    
  identity: {
    type: parIdentity
  }
  properties: {
    accessTier: parAccessTier
    allowBlobPublicAccess: parAllowBlobPublicAccess
    allowCrossTenantReplication: parAllowCrossTenantReplication
    allowedCopyScope: parAllowedCopyScope
    allowSharedKeyAccess: parAllowSharedKeyAccess 
  }
}

output outBlobAddress string = storageAccount.properties.primaryEndpoints.blob
output outStorageID string = storageAccount.id
