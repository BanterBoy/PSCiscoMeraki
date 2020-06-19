---
title: "Post: Installing the PSCiscoMeraki PowerShell Module"
date: 2019-11-23T05:07:30
last_modified_at: 2019-11-23T05:07:30
layout: posts
read_time: true
comments: true
share: true
related: true
categories:
  - Blog
  - PSCiscoMeraki
  - Installation
  - PowerShell
  - Module
tags:
  - Blog
  - PSCiscoMeraki
  - Installation
  - PowerShell
  - Module
---

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

This is "a work in progress" as I am working through the options that have been exposed via the API. Apologies for the state of the help, this module is not yet finished.

The link below will take you to the module listing in the PowerShell Gallery.

[PSCiscoMeraki](https://www.powershellgallery.com/packages/PSCiscoMeraki)

Make sure you are running Powershell 5.0 (WMF 5.0).

You can install the module by entering the following commands into an Elevated PowerShell session. Please open PowerShell as an Administrator and either paste or type the
