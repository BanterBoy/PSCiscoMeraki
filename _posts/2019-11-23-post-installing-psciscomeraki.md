---
title: "Post: Installing the PSCiscoMeraki PowerShell Module"
date: 2019-11-23T05:07:30
layout: posts
author_profile: true
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

## Installing PSCiscoMeraki

The link below will take you to the module listing in the PowerShell Gallery.

[PSCiscoMeraki](https://www.powershellgallery.com/packages/PSCiscoMeraki/1.0.0)

Make sure you are running Powershell 5.0 (WMF 5.0).

You can install the module by entering the following commands into an Elevated PowerShell session. Please open PowerShell as an Administrator and either paste or type the commands below.

    # Install PSCiscoMeraki from the Powershell Gallery
    Find-Module PSCiscoMeraki | Install-Module

    # Import Module
    Import-Module PSCiscoMeraki
