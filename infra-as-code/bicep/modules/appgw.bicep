/*
------------------------------------------------
Parameters
------------------------------------------------
*/

@description('User ID Name for Existing Resource')
param parUserIDName string
@description('User or System Assigned Identity')
param parAppGwIdentity string
@description('Min Capactiy for AppGw Scaling')
param parMinCapacity int
@description('Max Capactiy for AppGw Scaling')
param parMaxCapacity int
@description('Public IP Name')
param parPipID string
param parfrontendIPConfigurationName string
@description('Name of Appplication Gateway')
param parAppGwName string
@description('Location')
param parLocation string
@description('Tags to be applied')
param parTags object
@description('Id of subnet to be used for AppGW')
param parSnetAppGwID string
@description('RG Name for shared resources like Managed ID and KeyVault')
param parSharedRgName string
@description('Name of the IP configuration that is unique within an Application Gateway')
param parGatewayIPConfigurationsName string
@description('SKU of the application gateway resource')
param parAppGwSkuName string
@description('SKU of the application gateway resource')
param parAppGwSkuTier string
@description('Web application firewall mode.')
param parAppGwFirewallMode string
@description('The type of the web application firewall rule set. Possible values are: OWASP')
param parAppGwRuleTypeSet string
@description('Ruleset enabled or disabled')
param parAppGwRuleSetEnabled bool
@description('The version of the rule set type.')
param parAppGwRuleSetVersion string
@description('Name of the frontend IP configuration that is unique within an Application Gateway.')
param parFrontEndPortName string
@description('Front end port number')
param parFrontEndPortNumber int
@description('Name of the HTTP listener that is unique within an Application Gateway.')
param parHttpListenerName string
@description('Protocol of the HTTP listener.')
param parHttpListenerProtocol string
@description('Applicable only if protocol is https. Enables SNI for multi-hosting.')
param parRequireServerNameIndication bool
@description('Backendend address pool name.')
param parBackendAddressPoolName string
@description('Fully qualified domain name (FQDN).')
param parBackendAdressFqdn string
@description('Backend http settings of the application gateway resource. For default limits, see Application Gateway limits.')
param parBackendHttpSettingsCollectionName string
@description('Cookie based affinity.')
param parBackendHttpSettingsCollectionCookieBasedAffinity string
@description('Port number to be used for Http Settings Colletion')
param parBackendHttpSettingsCollectionPortNumber int
@description('Request routing rules of the application gateway resource.')
param parRequestRoutingRulesName string
@description('Routing Rule Type Basic or PathbasedRouting')
param parparRequestRoutingRuleType string
@description('SSL Certificate anme to be used by AppGW')
param parSslCertificateName string

/*
------------------------------------------------
Variables
------------------------------------------------
*/

@description('Applciaiton Gateway Resource ID')
var varAppGwId = resourceId('Microsoft.Network/applicationGateways',parAppGwName)
@description('SSL Certificate Location on AppGw')
var varSslCertificatetId = '${varAppGwId}/sslCertificates/${parSslCertificateName}'
@description('KeyvaultName')
var varKeyvaultName ='kv-jagslab-shared-neu-01'
@description('KeyVault environmetn suffix https://learn.microsoft.com/en-us/azure/key-vault/general/about-keys-secrets-certificates')
var varKeyVaultURL = environment().suffixes.keyvaultDns
@description('Keyvault URI')
var varKeyvaultId ='https://${varKeyvaultName}${varKeyVaultURL}/secrets/wildcard-jagslab-net/'

/*
------------------------------------------------
UserID Instance (Existing Resource)
------------------------------------------------
*/

resource userId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: parUserIDName
  scope: resourceGroup(parSharedRgName)

}

output outUserIdResource string = userId.properties.principalId

/*
------------------------------------------------
Application Gateway
------------------------------------------------
*/

resource appgw 'Microsoft.Network/applicationGateways@2021-05-01' ={
  name: parAppGwName
  location: parLocation
  tags: parTags
  identity: {
    type: parAppGwIdentity
    userAssignedIdentities: {
      '${userId.id}' : {}
    }
  }
  properties: {
    autoscaleConfiguration: {
      minCapacity: parMinCapacity
      maxCapacity: parMaxCapacity
    }
    frontendIPConfigurations: [
      {
        name: parfrontendIPConfigurationName
        properties:{
           publicIPAddress: {
             id: parPipID
           }
        } 
      }
    ]
gatewayIPConfigurations: [
  {
    name: parGatewayIPConfigurationsName
    properties: {
      subnet: {
        id: parSnetAppGwID
      }
    }
  }
]

    sku: {
      name: parAppGwSkuName
      tier: parAppGwSkuTier
    }
    webApplicationFirewallConfiguration: {
      firewallMode: parAppGwFirewallMode
      ruleSetType: parAppGwRuleTypeSet
      enabled: parAppGwRuleSetEnabled
      ruleSetVersion: parAppGwRuleSetVersion
    }
    frontendPorts: [
      {
        name: parFrontEndPortName
        properties: {
          port: parFrontEndPortNumber
        }
      }
    ]
    httpListeners: [
      {
        name: parHttpListenerName
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', parAppGwName, parfrontendIPConfigurationName)
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', parAppGwName, parFrontEndPortName)
          }
          protocol: parHttpListenerProtocol
          requireServerNameIndication: parRequireServerNameIndication
          sslCertificate: {
            id: varSslCertificatetId 
          }
          
        }
      }
    ]
    backendAddressPools: [
      {
        name: parBackendAddressPoolName
        properties: {
          backendAddresses: [
            {
              fqdn: parBackendAdressFqdn
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: parBackendHttpSettingsCollectionName
        properties: {
          cookieBasedAffinity: parBackendHttpSettingsCollectionCookieBasedAffinity
          port: parBackendHttpSettingsCollectionPortNumber
        }
      }
    ]
    requestRoutingRules: [
      {
        name: parRequestRoutingRulesName
        properties: {
          ruleType: parparRequestRoutingRuleType
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', parAppGwName, parHttpListenerName)
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', parAppGwName, parBackendAddressPoolName)
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', parAppGwName, parBackendHttpSettingsCollectionName)
          }
        }
      }
    ]
  
    sslCertificates: [
      {
        name: parSslCertificateName
        properties: {
          keyVaultSecretId: varKeyvaultId
        }
      }
    ]
  }
}
