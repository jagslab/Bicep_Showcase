/*
------------------------------------------------
Parameters
------------------------------------------------
*/
@description('Location of Pulbic IP')
param parLocation string
@description('Name of Pulbic IP')
param parPipName string
@description('Pulbic IP Resoruce Tags')
param parTags object
@description('Pulbic IP Sku Name')
param parSkuName string
@description('Pulbic IP Sku Tier')
param parSkuTier string
@description('Pulbic IP Dynamic of Static IP')
param parPublicIPAllocationMethod string

/*
------------------------------------------------
Public IP
------------------------------------------------
*/
resource pip 'Microsoft.Network/publicIPAddresses@2021-05-01'={
  name: parPipName
  location: parLocation
  tags: parTags
  sku: {
    tier: parSkuTier
    name: parSkuName
    }
  properties: {
    publicIPAllocationMethod: parPublicIPAllocationMethod
  }
}
  output outPublicIp string = pip.id
