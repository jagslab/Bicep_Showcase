/*
------------------------------------------------
Parameters
------------------------------------------------
*/

@description('NSG Name')
param parNsgSnetAppGwName string
@description('NSG Name')
param parNsgSnetwebName string
@description('NSG Location')
param parLocation string
@description('NSG Tags')
param parTags object
@description('NSG Security Rules Array')
param parNsgSecurityRules array

/*
------------------------------------------------
Create Network Security Group
------------------------------------------------
*/

resource nsgSnetAppGw 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: parNsgSnetAppGwName
  location: parLocation
  tags: parTags
  properties: {
    securityRules: [for parNsgSecurityRule in parNsgSecurityRules: { 
      
        name: parNsgSecurityRule.name
        properties: {
          description:parNsgSecurityRule.properties.description
          priority: parNsgSecurityRule.properties.priority
          sourceAddressPrefix: parNsgSecurityRule.properties.sourceAddressPrefix
          protocol: parNsgSecurityRule.properties.protocol
          destinationPortRange: parNsgSecurityRule.properties.destinationPortRange
          access: parNsgSecurityRule.properties.access
          direction: parNsgSecurityRule.properties.direction
          sourcePortRange: parNsgSecurityRule.properties.sourcePortRange
          destinationAddressPrefix: parNsgSecurityRule.properties.destinationAddressPrefix
        }
      }]
  }
}

resource nsgSnetWeb 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: parNsgSnetwebName
  location: parLocation
  tags: parTags
}

output nsgSnetAppGw string = nsgSnetAppGw.id
output nsgSnetWeb string = nsgSnetWeb.id

