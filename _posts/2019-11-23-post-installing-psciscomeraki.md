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

Make sure you are running Powershell 5.0 (WMF 5.0). I don't know that it is a hard requirement at the moment but I plan on using 5.0 features.

    # Install PSCiscoMeraki from the Powershell Gallery
    Find-Module PSCiscoMeraki | Install-Module

    # Import Module
    Import-Module PSCiscoMeraki
