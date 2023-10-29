param location string = resourceGroup().location
param name string = 'vmss-${uniqueString(resourceGroup().id)}'
param tags object = {}
param vmSkuSize string = 'Standard_DS4_v5'
param planName string = 'planName'
param planProduct string = 'planProduct'
param planPublisher string = 'planPublisher'
param planPromotionCode string = 'planPromotionCode'
param hibernationEnabled bool = false
param ultraSSDEnabled bool = false
param automaticRepairsPolicy_enabled bool = false
param automaticRepairsPolicy_gracePeriod string = 'PT90M'
@allowed([
  'Reimage'
  'Replace'
  'Restart'
])
param automaticRepairsPolicy_repairAction string = 'Reimage'
param constrainedMaximumCapacity bool = false
param doNotRunExtensionsOnOverprovisionedVMs bool = false
@allowed([
  'Flexible'
  'Uniform'
])
param orchestrationMode string = 'Flexible'
param overprovision bool = false
param platformFaultDomainCount int = 1
param priorityMixPolicy_baseRegularPriorityCount int = 0
param priorityMixPolicy_regularPriorityPercentageAboveBase int = 0
param singlePlacementGroup bool = true

param virtualNetworkName string = 'vnet-base'
param virtualNetworkSubnetName string = 'PublicSubnet'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-05-01' existing = {
  name: virtualNetworkName
}

output virtualNetwork string = virtualNetwork.id
output virtualNetworkSubnet string = '${virtualNetwork.id}/subnets/${virtualNetworkSubnetName}'

param username string = 'admin'
@secure()
param password string = newGuid()

@allowed([
  'Automatic'
  'Manual'
  'Rolling'
])
param upgradePolicy_mode string = 'Manual'
param automaticOSUpgradePolicy_disableAutomaticRollback bool = false
param automaticOSUpgradePolicy_enableAutomaticOSUpgrade bool = false
param automaticOSUpgradePolicy_useRollingUpgradePolicy bool = false
param rollingUpgradePolicy_enableCrossZoneUpgrade bool = false
param rollingUpgradePolicy_maxBatchInstancePercent int = 20
param rollingUpgradePolicy_maxSurge bool = false
param rollingUpgradePolicy_maxUnhealthyInstancePercent int = 20
param rollingUpgradePolicy_maxUnhealthyUpgradedInstancePercent int = 20
param rollingUpgradePolicy_pauseTimeBetweenBatches string = 'PT90M'
param rollingUpgradePolicy_prioritizeUnhealthyInstances bool = false
param rollingUpgradePolicy_rollbackFailedInstancesOnPolicyBreach bool = false
param diagnosticStorageAccountName string = 'diag${uniqueString(resourceGroup().id)}'
param bootDiagnosticsEnabled bool = false

resource symbolicname 'Microsoft.Compute/virtualMachineScaleSets@2023-03-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    capacity: 0
    name: vmSkuSize
    tier: 'Standard'
  }
  plan: {
    name: planName
    product: planProduct
    promotionCode: planPromotionCode
    publisher: planPublisher
  }
  properties: {
    additionalCapabilities: {
      hibernationEnabled: hibernationEnabled
      ultraSSDEnabled: ultraSSDEnabled
    }
    automaticRepairsPolicy: {
      enabled: automaticRepairsPolicy_enabled
      gracePeriod: automaticRepairsPolicy_gracePeriod
      repairAction: automaticRepairsPolicy_repairAction
    }
    constrainedMaximumCapacity: constrainedMaximumCapacity
    doNotRunExtensionsOnOverprovisionedVMs: doNotRunExtensionsOnOverprovisionedVMs
    orchestrationMode: orchestrationMode
    overprovision: overprovision
    platformFaultDomainCount: platformFaultDomainCount
    priorityMixPolicy: {
      baseRegularPriorityCount: priorityMixPolicy_baseRegularPriorityCount
      regularPriorityPercentageAboveBase: priorityMixPolicy_regularPriorityPercentageAboveBase
    }
    singlePlacementGroup: singlePlacementGroup
    upgradePolicy: {
      automaticOSUpgradePolicy: {
        disableAutomaticRollback: automaticOSUpgradePolicy_disableAutomaticRollback
        enableAutomaticOSUpgrade: automaticOSUpgradePolicy_enableAutomaticOSUpgrade
        useRollingUpgradePolicy: automaticOSUpgradePolicy_useRollingUpgradePolicy
      }
      mode: upgradePolicy_mode
      rollingUpgradePolicy: {
        enableCrossZoneUpgrade: rollingUpgradePolicy_enableCrossZoneUpgrade
        maxBatchInstancePercent: rollingUpgradePolicy_maxBatchInstancePercent
        maxSurge: rollingUpgradePolicy_maxSurge
        maxUnhealthyInstancePercent: rollingUpgradePolicy_maxUnhealthyInstancePercent
        maxUnhealthyUpgradedInstancePercent: rollingUpgradePolicy_maxUnhealthyUpgradedInstancePercent
        pauseTimeBetweenBatches: rollingUpgradePolicy_pauseTimeBetweenBatches
        prioritizeUnhealthyInstances: rollingUpgradePolicy_prioritizeUnhealthyInstances
        rollbackFailedInstancesOnPolicyBreach: rollingUpgradePolicy_rollbackFailedInstancesOnPolicyBreach
      }
    }
    virtualMachineProfile: {
      applicationProfile: {
        galleryApplications: [
          {
            configurationReference: 'string'
            enableAutomaticUpgrade: bool
            order: int
            packageReferenceId: 'string'
            tags: 'string'
            treatFailureAsDeploymentFailure: bool
          }
        ]
      }
      capacityReservation: {
        capacityReservationGroup: {
          id: 'string'
        }
      }
      diagnosticsProfile: {
        bootDiagnostics: {
          enabled: bootDiagnosticsEnabled
          storageUri: bootDiagnosticsEnabled == true ? diagnosticStorageAccountName : null
        }
      }
      evictionPolicy: 'string'
      }
      networkProfile: {
        networkApiVersion: '2020-11-01'
        networkInterfaceConfigurations: [
          {
            name: 'string'
            properties: {
              deleteOption: 'string'
              disableTcpStateTracking: bool
              dnsSettings: {
                dnsServers: [
                  'string'
                ]
              }
              enableAcceleratedNetworking: bool
              enableFpga: bool
              enableIPForwarding: bool
              ipConfigurations: [
                {
                  name: 'string'
                  properties: {
                    applicationGatewayBackendAddressPools: [
                      {
                        id: 'string'
                      }
                    ]
                    applicationSecurityGroups: [
                      {
                        id: 'string'
                      }
                    ]
                    loadBalancerBackendAddressPools: [
                      {
                        id: 'string'
                      }
                    ]
                    loadBalancerInboundNatPools: [
                      {
                        id: 'string'
                      }
                    ]
                    primary: bool
                    privateIPAddressVersion: 'string'
                    publicIPAddressConfiguration: {
                      name: 'string'
                      properties: {
                        deleteOption: 'string'
                        dnsSettings: {
                          domainNameLabel: 'string'
                        }
                        idleTimeoutInMinutes: int
                        ipTags: [
                          {
                            ipTagType: 'string'
                            tag: 'string'
                          }
                        ]
                        publicIPAddressVersion: 'string'
                        publicIPPrefix: {
                          id: 'string'
                        }
                      }
                      sku: {
                        name: 'string'
                        tier: 'string'
                      }
                    }
                    subnet: {
                      id: 'string'
                    }
                  }
                }
              ]
              networkSecurityGroup: {
                id: 'string'
              }
              primary: bool
            }
          }
        ]
      }
      osProfile: {
        adminPassword: username
        adminUsername: password
        allowExtensionOperations: bool
        computerNamePrefix: 'string'
        customData: 'string'
        linuxConfiguration: {
          disablePasswordAuthentication: bool
          enableVMAgentPlatformUpdates: bool
          patchSettings: {
            assessmentMode: 'string'
            automaticByPlatformSettings: {
              bypassPlatformSafetyChecksOnUserSchedule: bool
              rebootSetting: 'string'
            }
            patchMode: 'string'
          }
          provisionVMAgent: bool
          ssh: {
            publicKeys: [
              {
                keyData: 'string'
                path: 'string'
              }
            ]
          }
        }
        requireGuestProvisionSignal: bool
        secrets: [
          {
            sourceVault: {
              id: 'string'
            }
            vaultCertificates: [
              {
                certificateStore: 'string'
                certificateUrl: 'string'
              }
            ]
          }
        ]
        windowsConfiguration: {
          additionalUnattendContent: [
            {
              componentName: 'Microsoft-Windows-Shell-Setup'
              content: 'string'
              passName: 'OobeSystem'
              settingName: 'string'
            }
          ]
          enableAutomaticUpdates: bool
          enableVMAgentPlatformUpdates: bool
          patchSettings: {
            assessmentMode: 'string'
            automaticByPlatformSettings: {
              bypassPlatformSafetyChecksOnUserSchedule: bool
              rebootSetting: 'string'
            }
            enableHotpatching: bool
            patchMode: 'string'
          }
          provisionVMAgent: bool
          timeZone: 'string'
          winRM: {
            listeners: [
              {
                certificateUrl: 'string'
                protocol: 'string'
              }
            ]
          }
        }
      }
      priority: 'string'
      scheduledEventsProfile: {
        osImageNotificationProfile: {
          enable: bool
          notBeforeTimeout: 'string'
        }
        terminateNotificationProfile: {
          enable: bool
          notBeforeTimeout: 'string'
        }
      }
      securityPostureReference: {
        excludeExtensions: [
          {
            location: 'string'
            properties: {
              autoUpgradeMinorVersion: bool
              enableAutomaticUpgrade: bool
              forceUpdateTag: 'string'
              instanceView: {
                name: 'string'
                statuses: [
                  {
                    code: 'string'
                    displayStatus: 'string'
                    level: 'string'
                    message: 'string'
                    time: 'string'
                  }
                ]
                substatuses: [
                  {
                    code: 'string'
                    displayStatus: 'string'
                    level: 'string'
                    message: 'string'
                    time: 'string'
                  }
                ]
                type: 'string'
                typeHandlerVersion: 'string'
              }
              protectedSettings: any()
              protectedSettingsFromKeyVault: {
                secretUrl: 'string'
                sourceVault: {
                  id: 'string'
                }
              }
              provisionAfterExtensions: [
                'string'
              ]
              publisher: 'string'
              settings: any()
              suppressFailures: bool
              type: 'string'
              typeHandlerVersion: 'string'
            }
            tags: {}
          }
        ]
        id: 'string'
      }
      securityProfile: {
        encryptionAtHost: bool
        securityType: 'string'
        uefiSettings: {
          secureBootEnabled: bool
          vTpmEnabled: bool
        }
      }
      serviceArtifactReference: {
        id: 'string'
      }
      storageProfile: {
        dataDisks: [
          {
            caching: 'string'
            createOption: 'string'
            deleteOption: 'string'
            diskIOPSReadWrite: int
            diskMBpsReadWrite: int
            diskSizeGB: int
            lun: int
            managedDisk: {
              diskEncryptionSet: {
                id: 'string'
              }
              securityProfile: {
                diskEncryptionSet: {
                  id: 'string'
                }
                securityEncryptionType: 'string'
              }
              storageAccountType: 'string'
            }
            name: 'string'
            writeAcceleratorEnabled: bool
          }
        ]
        diskControllerType: 'string'
        imageReference: {
          communityGalleryImageId: 'string'
          id: 'string'
          offer: 'string'
          publisher: 'string'
          sharedGalleryImageId: 'string'
          sku: 'string'
          version: 'string'
        }
        osDisk: {
          caching: 'string'
          createOption: 'string'
          deleteOption: 'string'
          diffDiskSettings: {
            option: 'Local'
            placement: 'string'
          }
          diskSizeGB: int
          image: {
            uri: 'string'
          }
          managedDisk: {
            diskEncryptionSet: {
              id: 'string'
            }
            securityProfile: {
              diskEncryptionSet: {
                id: 'string'
              }
              securityEncryptionType: 'string'
            }
            storageAccountType: 'string'
          }
          name: 'string'
          osType: 'string'
          vhdContainers: [
            'string'
          ]
          writeAcceleratorEnabled: bool
        }
      }
      userData: 'string'
    }
    zoneBalance: bool
  }
}
