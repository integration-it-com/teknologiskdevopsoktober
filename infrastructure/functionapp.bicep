targetScope = 'resourceGroup'

param location string = 'swedencentral'
param skuTier string = 'Dynamic'
param skuName string = 'Y1'

param storageAccountSku string = 'Standard_LRS'
param storageAccountKind string = 'StorageV2'
param storageAccountKeyAccess bool = true

param capacity int = 1
param appName string
param env string

var planName = '${appName}-${env}-plan'



resource monitor 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: '${appName}-${env}-log'
  location: location
}

var appilicationInsightsKind = 'web'
resource appInsight 'Microsoft.Insights/components@2020-02-02' = {
  name: '${appName}-${env}-appi'
  location: location
  kind: appilicationInsightsKind
  properties: {
    Application_Type: appilicationInsightsKind
    WorkspaceResourceId: monitor.id
  }
}

resource plan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: planName
  location: location
  sku: {
    name: skuName
    tier: skuTier
    capacity: capacity
  }
  
}


resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: '${appName}${env}st'
  location: location
  sku: {
    name: storageAccountSku
  }
  kind: storageAccountKind
  properties: {
    allowSharedKeyAccess: storageAccountKeyAccess
  }
}


var storageAccountConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'



param netFrameworkVersion string = 'v8.0'
param use32BitWorkerProcess bool = false


var version = '~4'
var runtime  = 'dotnet-isolated'


resource functionApp 'Microsoft.Web/sites@2021-02-01' = {
  name: '${appName}-function-app-${env}-func'
  location: location
  kind: 'functionapp'
  
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: storageAccountConnectionString
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsight.properties.InstrumentationKey
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: runtime
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: version
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: storageAccountConnectionString
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: 'contentshare'
        }
     
      ]
    }
  }
}


resource netconfig 'Microsoft.Web/sites/config@2022-09-01' = {
  parent: functionApp
  name: 'web'
  properties: {
    vnetRouteAllEnabled: true
    netFrameworkVersion: netFrameworkVersion
    use32BitWorkerProcess: use32BitWorkerProcess
  }
}

