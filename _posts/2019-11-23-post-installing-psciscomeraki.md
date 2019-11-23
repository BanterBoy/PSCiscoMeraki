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
  - blog
tags:
  - PSCiscoMeraki
  - Installation
  - PowerShell
  - Module
---

## Installing PSCiscoMeraki

[PSCiscoMeraki](https://www.powershellgallery.com/packages/PSCiscoMeraki/1.0.0)

Make sure you are running Powershell 5.0 (WMF 5.0).

    # Install PSCiscoMeraki from the Powershell Gallery
    Find-Module PSCiscoMeraki | Install-Module

    # Import Module
    Import-Module PSCiscoMeraki
