---
name: README.md
about: Generic details regarding this project.
---

# CiscoMeraki

Powershell module to access the Cisco Meraki API to configure your Meraki's

This project is currently on hold as I no longer have access to a Meraki Cloud network and sadly Cisco Dev environment is naff.

## Common Variables

* X-Cisco-Meraki-API-Key
* organizationId
* networkId
* baseUrl

## CmdLets

Currently includes the following Cmdlets

```powershell
Get-MerakiAccessPolicy.ps1
Get-MerakiAirMarshall.ps1
Get-MerakiBluetooth.ps1
Get-MerakiDeviceInventory.ps1
Get-MerakiDeviceStatus.ps1
Get-MerakiLicenceState.ps1
Get-MerakiNetwork.ps1
Get-MerakiNetworkList.ps1
Get-MerakiOrganisation.ps1
Get-MerakiSitetoSite.ps1
Get-MerakiSNMP.ps1
Get-MerakiTraffic.ps1
Get-MerakiVLAN.ps1
Get-MerakiVLANList.ps1
Get-MerakiVPNPeers.ps1
```

This is "a work in progress" as I am working through the options that have been exposed via the API.

### API documentation

[<http://meraki.io/]>
[<https://dashboard.meraki.com/api_docs]>

### API Postman Collection

[<http://postman.meraki.com/]>

### API Endpoint

[<https://api.meraki.com/api/v0]>

[License](/LICENSE)
