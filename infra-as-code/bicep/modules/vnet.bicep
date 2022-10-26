/*
------------------------------------------------
Parameters
------------------------------------------------
*/

@description('Vnet Name')
param parVnetName string
@description('Vnet Location')
param parLocation string
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
@description('Network Security Group ID')
param parNsgAppGwId string
@description('Network Security Group ID')
param parNsgWebId string

/*
------------------------------------------------
Create VNET
------------------------------------------------
*/

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: parVnetName
  location: parLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        parVnetAddressPrefixes
      ]
    }
    subnets: [
      {
        name: parSubnetName0
        properties: {
          addressPrefix: parSubnet0AddressPrefix
          networkSecurityGroup:{
            id: parNsgAppGwId
          }
          serviceEndpoints: [
            {
              service: parSubnet0ServiceEndpoint
            }
          ]
        }
      }
      {
        name: parSubnetName1
        properties: {
          addressPrefix: parSubnet1AddressPrefix
          networkSecurityGroup: {
            id: parNsgWebId
          }
        }
      }
    ]
  }
}

output outSnetAppGwID string = resourceId('Microsoft.Network/virtualNetworks/subnets', parVnetName, parSubnetName0 )
output outSnetWebID string = resourceId('Microsoft.Network/virtualNetworks/subnets', parVnetName, parSubnetName1 )
output outVnet string = vnet.name



