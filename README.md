# CiscoMeraki

|name:| README.md |
|-----|--|
|  about:   | Generic details regarding this project. |

This Powershell module can be used to access the Cisco Meraki Rest API and request information related to the configuration. The ultimate goal is to create the final components that will enable you to configure your Meraki Network.

At present this project is on hold, due to time constraints with my present job....I simply do not have time in between work projects. I will however pick this up again when I have more free time. I have started using the Cisco Dev environment but there has been no further progress.

The module can currently be used to extract your current configuration but will require you to have an API key.

## Overview of Cisco Meraki API

The Meraki Dashboard API is an interface for software to interact directly with the Meraki cloud platform and Meraki managed devices. The API contains a set of tools known as endpoints for building software and applications that communicate with the Meraki Dashboard for use cases such as provisioning, bulk configuration changes, monitoring, and role-based access controls. The Dashboard API is a modern, RESTful API using HTTPS requests to a URL and JSON as a human-readable format. The Dashboard API is an open-ended tool can be used for many purposes, and here are some examples of how it is used today by Meraki customers:

* Add new organizations, admins, networks, devices, VLANs, SSIDs
* Provision thousands of new sites in minutes with an automation script
* Automatically onboard and off-board new employees' teleworker device
* Build your own dashboard for store managers, field techs, or unique use cases

## Enable API access

For access to the API, first enable the API for your organization under Organization > Settings > Dashboard API access.

![Enable API Access](https://raw.githubusercontent.com/BanterBoy/CiscoMeraki/master/assets/EnableAPIAccess.png)

After enabling the API, go to the **my profile** page to generate an API key. The API key is associated with a Dashboard administrator account. You can generate, revoke, and regenerate your API key on your profile.

![Generate API Key](https://raw.githubusercontent.com/BanterBoy/CiscoMeraki/master/assets/GenerateKey.png)

****Note:*** Keep your API key safe as it provides authentication to all of your organizations with the API enabled. If your API key is shared, you can regenerate your API key at any time. This will revoke the existing API key.*

****Note*** that SAML dashboard administrators cannot view or generate API keys.*

## Module Installation Instructions

The module has been made available for installation from the PowerShell Gallery and can be installed by Copying and Pasting the following commands :-

```powershell
Install-Module -Name PSCiscoMeraki

Import-Module -Name PSCiscoMeraki
```

Currently includes the following Cmdlets

```powershell
Get-MerakiAccessPolicy
Get-MerakiAirMarshall
Get-MerakiBluetooth
Get-MerakiDeviceInventory
Get-MerakiDeviceStatus
Get-MerakiLicenceState
Get-MerakiNetwork
Get-MerakiNetworkList
Get-MerakiOrganisation
Get-MerakiSitetoSite
Get-MerakiSNMP
Get-MerakiTraffic
Get-MerakiVLAN
Get-MerakiVLANList
Get-MerakiVPNPeers
```

This is "a work in progress" as I am working through the options that have been exposed via the API.

[License](/LICENSE)
