function Get-MerakiAccessPolicy {
    <#
    .SYNOPSIS
    Short function to provide details for an access policy configured on a specific network ID. Only valid for MS networks.
    In order to use this Module you will need an API Key from your Dashboard.

    .DESCRIPTION
    Short function to provide details for an access policy configured on a specific network ID. Only valid for MS networks.

    This function queries the Cisco Meraki API service <https://dashboard.meraki.com/api/v0> and will be needed for use with additional commands within the module.

    API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).

    In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your organisation under Organiation > Settings > Dashboard API access.

    ![Enable API Access](https://raw.githubusercontent.com/BanterBoy/CiscoMeraki/master/assets/EnableAPIAccess.png)

    After enabling the API, go to the **my profile** page to generate an API key. The API key is associated with a Dashboard administrator account. You can generate, revoke, and regenerate your API key on your profile.

    ![Generate API Key](https://raw.githubusercontent.com/BanterBoy/CiscoMeraki/master/assets/GenerateKey.png)

    ****Note:*** Keep your API key safe as it provides authentication to all of your organizations with the API enabled. If your API key is shared, you can regenerate your API key at any time. This will revoke the existing API key.*

    ****Note*** that SAML dashboard administrators cannot view or generate API keys.*

    .EXAMPLE
    Get-MerakiNetworks -ApiKey APIKeyGoesHere -NetworkID NetIDGoesHere
    Only valid for MS networks.

    .INPUTS
    Accepts Api Key as piped input.
    Accepts Organisation ID as piped input.
    
    .OUTPUTS
    The output from the API is sent as JSON and captured in a custom object.
    [
        {
            "number": 1,
            "name": "My access policy",
            "accessType": "8021.x",
            "guestVlan": 3700,
            "radiusServers": [
                {
                    "ip": "1.2.3.4",
                    "port": 1337
                },
                {
                    "ip": "2.3.4.5",
                    "port": 1337
                }
            ]
        }
    ]
            
    You can then select the items that you want to display.
            
    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/CiscoMeraki/wiki
#>
            
    [CmdletBinding()]
            
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your API Key.")]
        [Alias('API')]
        [string]$ApiKey,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Network ID.")]
        [Alias('NetID')]
        [string]$NetworkID
    )

    BEGIN { }

    PROCESS {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $Uri = @{
            "accessPolicies" = "https://api.meraki.com/api/v0/networks/$NetworkID/accessPolicies"
        }
        
        $accessPolicies = Invoke-RestMethod -Method GET -Uri $Uri.accessPolicies -Headers @{
            'X-Cisco-Meraki-API-Key' = "$ApiKey"
            'Content-Type'           = 'application/json'
        }

        foreach ( $item in $accessPolicies ) {
            $Settings = $item | Select-Object -Property *
            try {
                $accessPoliciesProperties = @{
                    number        = $Settings.number
                    name          = $Settings.name
                    accessType    = $Settings.accessType
                    guestVlan     = $Settings.guestVlan
                    radiusServers = $Settings.radiusServers
                }
                
                $obj = New-Object -TypeName PSObject -Property $accessPoliciesProperties
                Write-Output $obj
            }
            catch {
                Write-Host "Failed with error: $_.Message" -ForegroundColor Red
            }
        }
    }

    END { }

}

function Get-MerakiAdminList {
    <#
    .SYNOPSIS
    Short function to list organizations admin users which will be needed to use with other commands within this module.
    In order to use this Module you will need an API Key from your Dashboard.

    .DESCRIPTION
    Short function to output your Meraki Organisation ID which you will need in order to use with other commands within this module.

    This function queries the Cisco Meraki API service https://dashboard.meraki.com/api/v0 and will be needed for use with additional
    commands within the module.

    API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).

    In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your
    organisation under Organiation > Settings > Dashboard API access.

    After enabling the API, go to the my profile page to generate an API key. The API key is associated with a Dashboard administrator account.
    You can generate, revoke, and regenerate your API key on your profile.

    .EXAMPLE
    Export your companies ID, Name and SAML Url's
    Get-MerakiOrganisation.ps1 -ApiKey "YourApiKeyGoesHere"

    .EXAMPLE
    $key = "YourApiKeyGoesHere"
    Get-MerakiOrganisation.ps1 -ApiKey $key

    This example will enable you to Export your companies ID, Name and SAML Url's by piping in your Api Key

    .EXAMPLE
    $key = "YourApiKeyGoesHere"
    $CompanyID = "YourCompanyIDGoesHere"
    Get-MerakiOrganisation.ps1 -ApiKey $key -OrganisationID $CompanyID

    Export your company information (ID, Name and SAML Url's) by piping in your Api Key and specifying the Comapny ID

    .EXAMPLE
    $key = "YourApiKeyGoesHere"
    $orgID = "515085"
    $Admins = .\MerakiModule\Get-MerakiAdminList.ps1 -ApiKey $key -OrganisationID $orgID
    $Admins | Sort-Object Name | Select-Object -Property * | Format-List

    Export alpabetised Admin User List from your Meraki by piping in your Api Key, Organisation ID

    .EXAMPLE
    $key = "YourApiKeyGoesHere"
    $CompanyID = "YourCompanyIDGoesHere"
    Get-MerakiOrganisation.ps1 -ApiKey $key -OrganisationID $CompanyID |
    Format-List -Property *

    Export your company information (ID, Name and SAML Url's) by piping in your Api Key and specifying the Comapny ID

    .INPUTS
    Accepts Api Key as piped input.
    Accepts Organisation ID as piped input.

    .OUTPUTS
    The output from the API is sent as JSON and captured in a custom object.
    [
        {
            "name": "Miles Meraki",
            "email": "miles+test@meraki.com",
            "id": "646829496481123357",
            "networks": [],
            "tags": [
                {
                    "tag": "Sandbox",
                    "access": "full"
                }
            ],
            "orgAccess": "read-only"
        },
        {
            "name": "adminstrator123",
            "email": "administrator123@ikarem.com",
            "id": "646829496481136255",
            "networks": [],
            "tags": [],
            "orgAccess": "read-only"
        }
    ]

    You can then select the items that you want to display.

    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/CiscoMeraki/wiki

#>

    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your API Key.")]
        [Alias('API')]
        [string]$ApiKey,

        [Parameter(Mandatory = $false,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Organisation ID.")]
        [Alias('OrgID')]
        [string]$OrganisationID
    )

    BEGIN { }

    PROCESS {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $Uri = @{
            "admins" = "https://api.meraki.com/api/v0/organizations/$OrganisationID/admins"
        }

        $admins = Invoke-RestMethod -Method GET -Uri $Uri.admins -Headers @{
            'X-Cisco-Meraki-API-Key' = "$ApiKey"
            'Content-Type'           = 'application/json'
        }

        foreach ( $item in $admins ) {
            $Settings = $item | Select-Object -Property *

            try {
                $adminProperties = @{
                    name      = $Settings.name
                    email     = $Settings.email
                    id        = $Settings.id
                    networks  = $Settings.networks
                    tags      = $Settings.tags
                    orgAccess = $Settings.orgAccess
                }
                
                $obj = New-Object -TypeName PSObject -Property $adminProperties
                Write-Output $obj
            }
            catch {
                Write-Host "Failed with error: $_.Message" -ForegroundColor Red
            }
        }
    }

    END { }
}

function Get-MerakiAirMarshall {
    <#
      .SYNOPSIS
      Short function to provide details for an access policy configured on a specific network ID.
      In order to use this Module you will need an API Key from your Dashboard.
  
      .DESCRIPTION
      Short function to provide details for an access policy configured on a specific network ID
  
      This function queries the Cisco Meraki API service https://dashboard.meraki.com/api/v0 and will be needed for use with additional
      commands within the module.
  
      API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).
  
      In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your
      organisation under Organiation > Settings > Dashboard API access.
  
      After enabling the API, go to the my profile page to generate an API key. The API key is associated with a Dashboard administrator account.
      You can generate, revoke, and regenerate your API key on your profile.
  
      .EXAMPLE
      Get-MerakiNetworks -ApiKey APIKeyGoesHere -NetworkID NetIDGoesHere
  
      .INPUTS
      Accepts Api Key as piped input.
      Accepts Organisation ID as piped input.
  
      .OUTPUTS
      The output from the API is sent as JSON and captured in a custom object.
      [
        {
          "ssid": "linksys",
          "bssids": [
            {
              "bssid": "00:11:22:33:44:55",
              "contained": false,
              "detectedBy": [
                {
                  "device": "Q234-ABCD-5678",
                  "rssi": 17
                }
              ]
            }
          ],
          "channels": [
            36,
            40
          ],
          "firstSeen": 1518365681,
          "lastSeen": 1526087474,
          "wiredMacs": [
            "00:11:22:33:44:55"
          ],
          "wiredVlans": [
            0,
            108
          ],
          "wiredLastSeen": 1526087474
        }
      ]
  
      You can then select the items that you want to display.
  
      .NOTES
      Author:     Luke Leigh
      Website:    https://blog.lukeleigh.com/
      LinkedIn:   https://www.linkedin.com/in/lukeleigh/
      GitHub:     https://github.com/BanterBoy/
      GitHubGist: https://gist.github.com/BanterBoy
  
      .LINK
      https://github.com/BanterBoy/CiscoMeraki/wiki
  
  #>
  
    [CmdletBinding()]
  
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your API Key.")]
        [Alias('API')]
        [string]$ApiKey,
  
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Network ID.")]
        [Alias('NetID')]
        [string]$NetworkID,
  
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your time span in seconds (e.g. 3600). Must be a maximum of one month in seconds.")]
        [Alias('TS')]
        [string]$TimeSpan
  
    )
  
    BEGIN { }
  
    PROCESS {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  
        $Uri = @{
            "timespan" = "https://api.meraki.com/api/v0/networks/$NetworkID/airMarshal?timespan=$TimeSpan"
        }
  
        $timespaned = Invoke-RestMethod -Method GET -Uri $Uri.timespan -Headers @{
            'X-Cisco-Meraki-API-Key' = "$ApiKey"
            'Content-Type'           = 'application/json'
        }
  
        foreach ( $item in $timespaned ) {
            $Settings = $item | Select-Object -Property *
            try {
                $timespanProperties = @{
                    ssid          = $Settings.ssid
                    bssids        = $Settings.bssids
                    channels      = $Settings.channels
                    firstSeen     = $Settings.firstSeen
                    lastSeen      = $Settings.lastSeen
                    wiredMacs     = $Settings.wiredMacs
                    wiredVlans    = $Settings.wiredVlans
                    wiredLastSeen = $Settings.wiredLastSeen
                }
          
                $obj = New-Object -TypeName PSObject -Property $timespanProperties
                Write-Output $obj
            }
            catch {
                Write-Host "Failed with error: $_.Message" -ForegroundColor Red
            }
        }
    }
  
    END { }
}

function Get-MerakiBluetooth {
    <#
    .SYNOPSIS
    Short function to provide details for Bluetooth settings configured on the Meraki Devices.
    In order to use this Module you will need an API Key from your Dashboard.

    .DESCRIPTION
    Short function to provide details for Bluetooth settings configured on the Meraki Devices.

    This function queries the Cisco Meraki API service https://dashboard.meraki.com/api/v0 and will be needed for use with additional
    commands within the module.

    API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).

    In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your
    organisation under Organiation > Settings > Dashboard API access.

    After enabling the API, go to the my profile page to generate an API key. The API key is associated with a Dashboard administrator account.
    You can generate, revoke, and regenerate your API key on your profile.

    .EXAMPLE
    Get-MerakiBluetooth -ApiKey APIKeyGoesHere -NetworkID NetIDGoesHere

    Description

    -----------

    This command connects to the Meraki API and performs a Get

    .INPUTS
    Accepts Api Key as piped input.
    Accepts Organisation ID as piped input.

    .OUTPUTS
    The output from the API is sent as JSON and captured in a custom object.
    {
        "scanningEnabled": true,
        "advertisingEnabled": true,
        "uuid": "95bba6e5-c32d-446b-fake-aebd4c62888d",
        "majorMinorAssignmentMode": "Non-unique",
        "major": 0,
        "minor": 0
    }

    You can then select the items that you want to display.

    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/CiscoMeraki/wiki

#>

    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your API Key.")]
        [Alias('API')]
        [string]$ApiKey,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Network ID.")]
        [Alias('NetID')]
        [string]$NetworkID

    )

    BEGIN { }

    PROCESS {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $Uri = @{
            "bluetoothSettings" = "https://api.meraki.com/api/v0/networks/$NetworkID/bluetoothSettings"
        }

        $bluetoothSettings = Invoke-RestMethod -Method GET -Uri $Uri.bluetoothSettings -Headers @{
            'X-Cisco-Meraki-API-Key' = "$ApiKey"
            'Content-Type'           = 'application/json'
        }

        foreach ( $item in $bluetoothSettings ) {
            $Settings = $item | Select-Object -Property *
            try {
                $bluetoothSettingsProperties = @{
                    scanningEnabled          = $Settings.scanningEnabled
                    advertisingEnabled       = $Settings.advertisingEnabled
                    uuid                     = $Settings.uuid
                    majorMinorAssignmentMode = $Settings.majorMinorAssignmentMode
                    major                    = $Settings.major
                    minor                    = $Settings.minor
                    type                     = $Settings.type
                }
                
                $obj = New-Object -TypeName PSObject -Property $bluetoothSettingsProperties
                Write-Output $obj
            }
            catch {
                Write-Host "Failed with error: $_.Message" -ForegroundColor Red
            }
        }
    }

    END { }
}

function Get-MerakiDeviceInventory {
    <#
    .SYNOPSIS
    Short function to provide an inventory of all Meraki Devices.
    In order to use this Module you will need an API Key from your Dashboard.

    .DESCRIPTION
    Short function to provide an inventory of all Meraki Devices.

    This function queries the Cisco Meraki API service https://dashboard.meraki.com/api/v0 and will be needed for use with additional
    commands within the module.

    API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).

    In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your
    organisation under Organiation > Settings > Dashboard API access.

    After enabling the API, go to the my profile page to generate an API key. The API key is associated with a Dashboard administrator account.
    You can generate, revoke, and regenerate your API key on your profile.

    .EXAMPLE


    .INPUTS
    Accepts Api Key as piped input.
    Accepts Organisation ID as piped input.

    .OUTPUTS
    The output from the API is sent as JSON and captured in a custom object.
    [
        {
            "mac": "00:18:0a:4e:78:0c",
            "serial": "Q2JN-QP7J-VW8J",
            "networkId": "L_694117292568478178",
            "model": "MX100",
            "claimedAt": "1476691740.28085",
            "publicIp": "194.74.170.115"
        },
        {
            "mac": "00:18:0a:6f:70:eb",
            "serial": "Q2GD-6M6C-QBMK",
            "networkId": "L_694117292568478178",
            "model": "MR18",
            "claimedAt": "1457009523.49881",
            "publicIp": "194.74.170.115"
        },
        {
            "mac": "0c:8d:db:5e:34:42",
            "serial": "Q2QD-PDZR-X93A",
            "networkId": "L_694117292568478178",
            "model": "MR74",
            "claimedAt": "1496310866.85687",
            "publicIp": "194.74.170.115"
        }
    ]

    You can then select the items that you want to display.

    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/CiscoMeraki/wiki

#>

    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your API Key.")]
        [Alias('API')]
        [string]$ApiKey,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Organisation ID.")]
        [Alias('OrgID')]
        [string]$OrganisationID

    )

    BEGIN { }

    PROCESS {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $Uri = @{
            "inventory" = "https://api.meraki.com/api/v0/organizations/$OrganisationID/inventory"
        }

        $inventory = Invoke-RestMethod -Method GET -Uri $Uri.inventory -Headers @{
            'X-Cisco-Meraki-API-Key' = "$ApiKey"
            'Content-Type'           = 'application/json'
        }

        foreach ( $item in $inventory ) {
            $Device = $item | Select-Object -Property *
            try {
                $DeviceProperties = @{
                    mac       = $Device.mac
                    serial    = $Device.serial
                    networkId = $Device.networkId
                    model     = $Device.model
                    claimedAt = $Device.claimedAt
                    publicIp  = $Device.publicIp
                }
                
                $obj = New-Object -TypeName PSObject -Property $DeviceProperties
                Write-Output $obj
            }
            catch {
                Write-Host "Failed with error: $_.Message" -ForegroundColor Red
            }
        }
    }

    END { }
}

function Get-MerakiDeviceStatus {
    <#
    .SYNOPSIS
    Short function to list Device Status.
    In order to use this Module you will need an API Key from your Dashboard.

    .DESCRIPTION
    Short function to list Device Status.

    This function queries the Cisco Meraki API service https://dashboard.meraki.com/api/v0 and will be needed for use with additional
    commands within the module.

    API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).

    In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your
    organisation under Organiation > Settings > Dashboard API access.

    After enabling the API, go to the my profile page to generate an API key. The API key is associated with a Dashboard administrator account.
    You can generate, revoke, and regenerate your API key on your profile.

    .EXAMPLE


    .INPUTS
    Accepts Api Key as piped input.
    Accepts Organisation ID as piped input.

    .OUTPUTS
    The output from the API is sent as JSON and captured in a custom object.
    [
        {
            "name": null,
            "serial": "Q2QN-WVV9-W4KK",
            "mac": "e0:55:3d:17:c6:87",
            "publicIp": "64.103.26.54",
            "networkId": "L_646829496481095933",
            "status": "offline",
            "usingCellularFailover": false,
            "wan1Ip": "10.10.20.70",
            "wan2Ip": null
        },
        {
            "name": "S23",
            "serial": "Q2HP-AJ22-UG72",
            "mac": "88:15:44:df:76:d1",
            "publicIp": "64.103.26.57",
            "networkId": "L_646829496481095933",
            "status": "offline",
            "lanIp": "10.0.10.2"
        }
    ]

    You can then select the items that you want to display.

    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/CiscoMeraki/wiki

#>

    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your API Key.")]
        [Alias('API')]
        [string]$ApiKey,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Organisation ID.")]
        [Alias('OrgID')]
        [string]$OrganisationID

    )

    BEGIN { }

    PROCESS {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $Uri = @{
            "deviceStatuses" = "https://api.meraki.com/api/v0/organizations/$OrganisationID/deviceStatuses"
        }

        $deviceStatuses = Invoke-RestMethod -Method GET -Uri $Uri.deviceStatuses -Headers @{
            'X-Cisco-Meraki-API-Key' = "$ApiKey"
            'Content-Type'           = 'application/json'
        }

        foreach ( $device in $deviceStatuses ) {
            $item = $device | Select-Object -Property *
            try {
                $DeviceProperties = @{
                    lanIp     = $item.lanIp
                    mac       = $item.mac
                    name      = $item.name
                    networkId = $item.networkId
                    publicIp  = $item.publicIp
                    serial    = $item.serial
                    status    = $item.status
                }

                $obj = New-Object -TypeName PSObject -Property $DeviceProperties
                Write-Output $obj
            }
            catch {
                Write-Host "Failed with error: $_.Message" -ForegroundColor Red
            }
        }
    }

    END { }
}

function Get-MerakiDeviceUplink {

    <#

    .SYNOPSIS
    Short function to list Uplinks.
    In order to use this Module you will need an API Key from your Dashboard.
	The code for this function was supplied by Darrell Porter.

    .DESCRIPTION
    Short function to list Device Status.

    This function queries the Cisco Meraki API service https://dashboard.meraki.com/api/v0 and will be needed for use with additional
    commands within the module.

    API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).

    In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your
    organisation under Organiation > Settings > Dashboard API access.

    After enabling the API, go to the my profile page to generate an API key. The API key is associated with a Dashboard administrator account.
    You can generate, revoke, and regenerate your API key on your profile.

    .EXAMPLE


    .INPUTS
    Accepts Api Key as piped input.
    Accepts Network ID as piped input.
    Accepts Device Serial Number as piped input.
	(All inputs are mandatory).

    .OUTPUTS
    The output from the API is received as JSON and captured in a custom object.

    [
        {
            "interface": "WAN 1",
            "status": "Active",
            "ip": "10.211.139.4",
            "gateway": "10.211.139.1",
            "publicIp": "82.193.120.22",
            "dns": "8.8.8.8, 8.8.4.4",
            "usingStaticIp": true
        },
        {
            "interface": "WAN 2",
            "status": "Ready",
            "ip": "192.168.101.10",
            "gateway": "192.168.101.1",
            "publicIp": "5.110.103.221",
            "dns": "8.8.8.8, 8.8.4.4",
            "usingStaticIp": true
        }
    ]

    You can then select the items that you want to display.

    .NOTES
    Author:     Darrell Porter (documentation Luke Leigh)
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/CiscoMeraki/wiki

    #>

    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your API Key.")]
        [Alias('API')]
        [string]$ApiKey,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Network ID.")]
        [Alias('NetworkID')]
        [string]$NetID,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter the device serial number.")]
        [Alias('Serial')]
        [string]$SerialNo

    )

    BEGIN { }

    PROCESS {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $Uri = @{
            "inventory" = "https://api.meraki.com/api/v0/networks/$netid/devices/$serialNo/uplink"
        }

        $inventory = Invoke-RestMethod -Method GET -Uri $Uri.inventory -Headers @{
            'X-Cisco-Meraki-API-Key' = "$ApiKey"
            'Content-Type'           = 'application/json'
        }

        foreach ( $item in $inventory ) {
            $Device = $item | Select-Object -Property *
            try {
                $DeviceProperties = @{
                    networkID     = $NetID
                    serial        = $serialNo
                    interface     = $Device.interface
                    status        = $Device.status
                    ip            = $Device.ip
                    gateway       = $Device.gateway
                    publicIp      = $Device.publicIp
                    dns           = $Device.dns
                    usingStaticIP = $Device.usingStaticIP
                }
                
                $obj = New-Object -TypeName PSObject -Property $DeviceProperties
                Write-Output $obj
            }
            catch {
                Write-Host "Failed with error: $_.Message" -ForegroundColor Red
            }
        }
    }

    END { }
}

function Get-MerakiLicenceState {
    <#
    .SYNOPSIS
    Short function to list organizations licences.
    In order to use this Module you will need an API Key from your Dashboard.

    .DESCRIPTION
    Short function to list organizations licences.

    This function queries the Cisco Meraki API service https://dashboard.meraki.com/api/v0 and will be needed for use with additional
    commands within the module.

    API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).

    In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your
    organisation under Organiation > Settings > Dashboard API access.

    After enabling the API, go to the my profile page to generate an API key. The API key is associated with a Dashboard administrator account.
    You can generate, revoke, and regenerate your API key on your profile.

    .EXAMPLE


    .INPUTS
    Accepts Api Key as piped input.
    Accepts Organisation ID as piped input.

    .OUTPUTS
    The output from the API is sent as JSON and captured in a custom object.
    {
        "status": "OK",
        "expirationDate": "Feb 3, 2018 UTC",
        "licensedDeviceCounts": {
            "MS220-8P": 30,
            "MX65W": 2,
            "SM": 100,
            "wireless": 95,
            "MX64W": 2,
            "MX65": 6,
            "MC": 7,
            "Z1": 1,
            "MX64": 1,
            "MV": 4
        }
    }

    You can then select the items that you want to display.

    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/CiscoMeraki/wiki

#>

    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your API Key.")]
        [Alias('API')]
        [string]$ApiKey,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Organisation ID.")]
        [Alias('OrgID')]
        [string]$OrganisationID

    )

    BEGIN { }

    PROCESS {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $Uri = @{
            "endPoint"     = 'https://api.meraki.com/api/v0/organizations'
            "licenseState" = "https://api.meraki.com/api/v0/organizations/$OrganisationID/licenseState"
        }

        $licenseStates = Invoke-RestMethod -Method GET -Uri $Uri.licenseState -Headers @{
            'OrganisationID'         = "$OrganizationId"
            'X-Cisco-Meraki-API-Key' = "$ApiKey"
            'Content-Type'           = 'application/json'
        }

        foreach ( $licenseState in $licenseStates ) {
            $Lic = $licenseState | Select-Object -Property *

            try {
                $LicProperties = @{
                    status               = $Lic.status
                    expirationDate       = $Lic.expirationDate
                    licensedDeviceCounts = $Lic.licensedDeviceCounts
                }
                
                $obj = New-Object -TypeName PSObject -Property $LicProperties
                Write-Output $obj
            }
            catch {
                Write-Host "Failed with error: $_.Message" -ForegroundColor Red
            }
        }
    }

    END { }
}

function Get-MerakiNetwork {
    <#
    .SYNOPSIS
    Short function to provide details for an individual network configured on the Meraki Devices.
    In order to use this Module you will need an API Key from your Dashboard.

    .DESCRIPTION
    Short function to provide details for an individual network configured on the Meraki Devices.

    This function queries the Cisco Meraki API service https://dashboard.meraki.com/api/v0 and will be needed for use with additional
    commands within the module.

    API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).

    In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your
    organisation under Organiation > Settings > Dashboard API access.

    After enabling the API, go to the my profile page to generate an API key. The API key is associated with a Dashboard administrator account.
    You can generate, revoke, and regenerate your API key on your profile.

    .EXAMPLE
    Get-MerakiNetworks -ApiKey APIKeyGoesHere -NetworkID NetIDGoesHere

    .INPUTS
    Accepts Api Key as piped input.
    Accepts Organisation ID as piped input.

    .OUTPUTS
    The output from the API is sent as JSON and captured in a custom object.
    {
        "id": "L_646829496481092083",
        "organizationId": "549236",
        "name": "Sandbox 3 - Kampala Uganda",
        "timeZone": "US/Mountain",
        "tags": " LearningLab Sandbox ",
        "type": "combined"
    }

    You can then select the items that you want to display.

    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/CiscoMeraki/wiki

#>

    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your API Key.")]
        [Alias('API')]
        [string]$ApiKey,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Network ID.")]
        [Alias('NetID')]
        [string]$NetworkID

    )

    BEGIN { }

    PROCESS {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $Uri = @{
            "networks" = "https://api.meraki.com/api/v0/networks/$NetworkID"
        }

        $networks = Invoke-RestMethod -Method GET -Uri $Uri.networks -Headers @{
            'X-Cisco-Meraki-API-Key' = "$ApiKey"
            'Content-Type'           = 'application/json'
        }

        foreach ( $item in $networks ) {
            $Settings = $item | Select-Object -Property *
            try {
                $networksProperties = @{
                    disableMyMerakiCom = $Settings.disableMyMerakiCom
                    id                 = $Settings.id
                    name               = $Settings.name
                    organizationId     = $Settings.organizationId
                    tags               = $Settings.tags
                    timeZone           = $Settings.timeZone
                    type               = $Settings.type
                }
                
                $obj = New-Object -TypeName PSObject -Property $networksProperties
                Write-Output $obj
            }
            catch {
                Write-Host "Failed with error: $_.Message" -ForegroundColor Red
            }
        }
    }

    END { }
}

function Get-MerakiNetworkList {
    <#
    .SYNOPSIS
    Short function to provide a list of networks configured on the Meraki Devices.
    In order to use this Module you will need an API Key from your Dashboard.

    .DESCRIPTION
    Short function to provide a list of networks configured on the Meraki Devices.

    This function queries the Cisco Meraki API service https://dashboard.meraki.com/api/v0 and will be needed for use with additional
    commands within the module.

    API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).

    In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your
    organisation under Organiation > Settings > Dashboard API access.

    After enabling the API, go to the my profile page to generate an API key. The API key is associated with a Dashboard administrator account.
    You can generate, revoke, and regenerate your API key on your profile.

    .EXAMPLE
    Get-MerakiNetworks -ApiKey APIKeyGoesHere -OrganisationID OrgIDGoesHere

    .INPUTS
    Accepts Api Key as piped input.
    Accepts Organisation ID as piped input.

    .OUTPUTS
    The output from the API is sent as JSON and captured in a custom object.
    [
        {
            "id": "L_646829496481092083",
            "organizationId": "549236",
            "name": "Sandbox 3 - Kampala Uganda",
            "timeZone": "US/Mountain",
            "tags": " LearningLab Sandbox ",
            "type": "combined"
        },
        {
            "id": "L_646829496481095584",
            "organizationId": "549236",
            "name": "Sandbox 1 - Galway Ireland",
            "timeZone": "America/Los_Angeles",
            "tags": " Global Sandbox ",
            "type": "combined"
        },
        {
            "id": "L_646829496481095933",
            "organizationId": "549236",
            "name": "Sandbox 2 - Las Vegas USA",
            "timeZone": "America/Los_Angeles",
            "tags": " Sandbox ",
            "type": "combined"
        }
    ]

    You can then select the items that you want to display.

    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/CiscoMeraki/wiki

#>

    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your API Key.")]
        [Alias('API')]
        [string]$ApiKey,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Organisation ID.")]
        [Alias('OrgID')]
        [string]$OrganisationID

    )

    BEGIN { }

    PROCESS {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $Uri = @{
            "networks" = "https://api.meraki.com/api/v0/organizations/$OrganisationID/networks"
        }

        $networks = Invoke-RestMethod -Method GET -Uri $Uri.networks -Headers @{
            'X-Cisco-Meraki-API-Key' = "$ApiKey"
            'Content-Type'           = 'application/json'
        }

        foreach ( $item in $networks ) {
            $Settings = $item | Select-Object -Property *
            try {
                $networksProperties = @{
                    id             = $Settings.id
                    organizationId = $Settings.organizationId
                    name           = $Settings.name
                    timeZone       = $Settings.timeZone
                    tags           = $Settings.tags
                    type           = $Settings.type
                }
                
                $obj = New-Object -TypeName PSObject -Property $networksProperties
                Write-Output $obj
            }
            catch {
                Write-Host "Failed with error: $_.Message" -ForegroundColor Red
            }
        }
    }

    END { }
}

function Get-MerakiOrganisation {
    <#
    .SYNOPSIS
    Short function to list organizations the user has access to which will be needed to use with other commands within this module.
    In order to use this Module you will need an API Key from your Dashboard.

    .DESCRIPTION
    Short function to output your Meraki Organisation ID which you will need in order to use with other commands within this module.

    This function queries the Cisco Meraki API service https://dashboard.meraki.com/api/v0 and will be needed for use with additional
    commands within the module.

    API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).

    In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your
    organisation under Organiation > Settings > Dashboard API access.

    After enabling the API, go to the my profile page to generate an API key. The API key is associated with a Dashboard administrator account.
    You can generate, revoke, and regenerate your API key on your profile.

    .EXAMPLE
    Export your companies ID, Name and SAML Url's
    Get-MerakiOrganisation.ps1 -ApiKey "YourApiKeyGoesHere"

    .EXAMPLE
    Export your companies ID, Name and SAML Url's by piping in your Api Key
    $key = "YourApiKeyGoesHere"
    Get-MerakiOrganisation.ps1 -ApiKey $key

    .EXAMPLE
    Export your company information (ID, Name and SAML Url's) by piping in your Api Key and specifying the Comapny ID
    $key = "YourApiKeyGoesHere"
    $CompanyID = "YourCompanyIDGoesHere"
    Get-MerakiOrganisation.ps1 -ApiKey $key -OrganisationID $CompanyID

    .EXAMPLE
    Export selected items from your Meraki by piping in your Api Key
    $key = "YourApiKeyGoesHere"
    Get-MerakiOrganisation.ps1 -ApiKey $key |
    Format-List -Property Name,ID

    .EXAMPLE
    Export your company information (ID, Name and SAML Url's) by piping in your Api Key and specifying the Comapny ID
    $key = "YourApiKeyGoesHere"
    $CompanyID = "YourCompanyIDGoesHere"
    Get-MerakiOrganisation.ps1 -ApiKey $key -OrganisationID $CompanyID |
    Format-List -Property *

    .INPUTS
    Accepts Api Key as piped input.
    Accepts Organisation ID as piped input.

    .OUTPUTS
    The output from the API is sent as JSON and captured in a custom object.
    {
        "id": 549236,
        "name": "Meraki Live Sandbox",
        "samlConsumerUrl": "https://n149.meraki.com/saml/login/-t35Mb/TvUzhbJtIRna",
        "samlConsumerUrls": ["https://n149.meraki.com/saml/login/-t35Mb/TvUzhbJtIRna"]
    }

    You can then select the items that you want to display.

    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/CiscoMeraki/wiki

#>

    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your API Key.")]
        [Alias('API')]
        [string]$ApiKey,

        [Parameter(Mandatory = $false,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Organisation ID.")]
        [Alias('OrgID')]
        [string]$OrganisationID
    )

    BEGIN { }

    PROCESS {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $Uri = @{
            "organisation" = 'https://api.meraki.com/api/v0/organizations'
        }

        $Organisations = Invoke-RestMethod -Method GET -Uri $Uri.organisation -Headers @{
            'X-Cisco-Meraki-API-Key' = "$ApiKey"
            'Content-Type'           = 'application/json'
        }

        foreach ( $Organisation in $Organisations ) {
            $Org = $Organisation | Select-Object -Property *

            try {
                $OrgProperties = @{
                    ID       = $Org.id
                    Name     = $Org.name
                    SAMLUrl  = $Org.samlConsumerUrl
                    SAMLUrls = $Org.samlConsumerUrls
                }
                
                $obj = New-Object -TypeName PSObject -Property $OrgProperties
                Write-Output $obj
            }
            catch {
                Write-Host "Failed with error: $_.Message" -ForegroundColor Red
            }
        }
    }

    END { }
}

function Get-MerakiSitetoSite {
    <#
    .SYNOPSIS
    Short function to provide details for site to site Vpn's configured on the Meraki Devices.
    In order to use this Module you will need an API Key from your Dashboard.

    .DESCRIPTION
    Short function to provide details for site to site Vpn's configured on the Meraki Devices.

    This function queries the Cisco Meraki API service https://dashboard.meraki.com/api/v0 and will be needed for use with additional
    commands within the module.

    API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).

    In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your
    organisation under Organiation > Settings > Dashboard API access.

    After enabling the API, go to the my profile page to generate an API key. The API key is associated with a Dashboard administrator account.
    You can generate, revoke, and regenerate your API key on your profile.

    .EXAMPLE
    Get-MerakiSitetoSite -ApiKey APIKeyGoesHere -NetworkID NetIDGoesHere

    .INPUTS
    Accepts Api Key as piped input.
    Accepts Organisation ID as piped input.

    .OUTPUTS
    The output from the API is sent as JSON and captured in a custom object.
    {
        "mode": "spoke",
        "hubs": [
            {
                "hubId": "N_4901849",
                "useDefaultRoute": true
            },
            {
                "hubId": "N_1892489",
                "useDefaultRoute": false
            }
        ],
        "subnets": [
            {
                "localSubnet": "192.168.1.0/24",
                "useVpn": true
            },
            {
                "localSubnet": "192.168.128.0/24",
                "useVpn": true
            }
        ]
    }

    You can then select the items that you want to display.

    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/CiscoMeraki/wiki

#>

    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your API Key.")]
        [Alias('API')]
        [string]$ApiKey,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Network ID.")]
        [Alias('NetID')]
        [string]$NetworkID

    )

    BEGIN { }

    PROCESS {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $Uri = @{
            "siteToSiteVpn" = "https://api.meraki.com/api/v0/networks/$NetworkID/siteToSiteVpn"
        }

        $siteToSiteVpn = Invoke-RestMethod -Method GET -Uri $Uri.siteToSiteVpn -Headers @{
            'X-Cisco-Meraki-API-Key' = "$ApiKey"
            'Content-Type'           = 'application/json'
        }

        foreach ( $item in $siteToSiteVpn ) {
            $Settings = $item | Select-Object -Property *
            try {
                $siteToSiteVpnProperties = @{
                    mode    = $Settings.mode
                    hubs    = $Settings.hubs
                    subnets = $Settings.subnets
                }
                
                $obj = New-Object -TypeName PSObject -Property $siteToSiteVpnProperties
                Write-Output $obj
            }
            catch {
                Write-Host "Failed with error: $_.Message" -ForegroundColor Red
            }
        }
    }

    END { }
}

function Get-MerakiSNMP {
    <#
    .SYNOPSIS
    Short function to provide SNMP Details.
    In order to use this Module you will need an API Key from your Dashboard.

    .DESCRIPTION
    Short function to provide SNMP Details.

    This function queries the Cisco Meraki API service https://dashboard.meraki.com/api/v0 and will be needed for use with additional
    commands within the module.

    API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).

    In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your
    organisation under Organiation > Settings > Dashboard API access.

    After enabling the API, go to the my profile page to generate an API key. The API key is associated with a Dashboard administrator account.
    You can generate, revoke, and regenerate your API key on your profile.

    .EXAMPLE


    .INPUTS
    Accepts Api Key as piped input.
    Accepts Organisation ID as piped input.

    .OUTPUTS
    The output from the API is sent as JSON and captured in a custom object.
    {
        "v2cEnabled": true,
        "v3Enabled": false,
        "v3AuthMode": null,
        "v3PrivMode": null,
        "peerIps": null,
        "v2CommunityString": "o/-t35Mb",
        "hostname": "n149.meraki.com",
        "port": 16100
    }

    You can then select the items that you want to display.

    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/CiscoMeraki/wiki

#>

    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your API Key.")]
        [Alias('API')]
        [string]$ApiKey,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Organisation ID.")]
        [Alias('OrgID')]
        [string]$OrganisationID

    )

    BEGIN { }

    PROCESS {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $Uri = @{
            "snmp" = "https://api.meraki.com/api/v0/organizations/$OrganisationID/snmp"
        }

        $SNMP = Invoke-RestMethod -Method GET -Uri $Uri.snmp -Headers @{
            'X-Cisco-Meraki-API-Key' = "$ApiKey"
            'Content-Type'           = 'application/json'
        }

        foreach ( $item in $SNMP ) {
            $Settings = $item | Select-Object -Property *
            try {
                $SNMPProperties = @{
                    v2cEnabled = $Settings.v2cEnabled
                    v3Enabled  = $Settings.v3Enabled
                    v3AuthMode = $Settings.v3AuthMode
                    v3PrivMode = $Settings.v3PrivMode
                    peerIps    = $Settings.peerIps
                    hostname   = $Settings.hostname
                    port       = $Settings.port
                }
                
                $obj = New-Object -TypeName PSObject -Property $SNMPProperties
                Write-Output $obj
            }
            catch {
                Write-Host "Failed with error: $_.Message" -ForegroundColor Red
            }
        }
    }

    END { }
}

function Get-MerakiTraffic {
    <#
    .SYNOPSIS
    Short function to provide details for site to site Vpn's configured on the Meraki Devices.
    In order to use this Module you will need an API Key from your Dashboard.

    .DESCRIPTION
    Short function to provide details for site to site Vpn's configured on the Meraki Devices.

    This function queries the Cisco Meraki API service https://dashboard.meraki.com/api/v0 and will be needed for use with additional
    commands within the module.

    API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).

    In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your
    organisation under Organiation > Settings > Dashboard API access.

    After enabling the API, go to the my profile page to generate an API key. The API key is associated with a Dashboard administrator account.
    You can generate, revoke, and regenerate your API key on your profile.

    .EXAMPLE
    Get-MerakiSitetoSite -ApiKey APIKeyGoesHere -NetworkID NetIDGoesHere

    .INPUTS
    Accepts Api Key as piped input.
    Accepts Organisation ID as piped input.

    .OUTPUTS
    The output from the API is sent as JSON and captured in a custom object.
    [
        {
            "application": "Miscellaneous web",
            "destination": "scripts.dailymail.co.uk",
            "protocol": "TCP",
            "port": 80,
            "recv": 375,
            "sent": 12,
            "flows": 2,
            "activeTime": 60,
            "numClients": 1
        },
        {
            "application": "Miscellaneous web",
            "destination": "www.metdaan.com",
            "protocol": "TCP",
            "port": 80,
            "recv": 4218,
            "sent": 144,
            "flows": 9,
            "activeTime": 240,
            "numClients": 1
        }
    ]

    You can then select the items that you want to display.

    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/CiscoMeraki/wiki

#>

    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your API Key.")]
        [Alias('API')]
        [string]$ApiKey,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Network ID.")]
        [Alias('NetID')]
        [string]$NetworkID,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your TimeSpan (duration in seconds between two hours and one month).")]
        [Alias('TS')]
        [string]$TimeSpan
    )

    BEGIN { }

    PROCESS {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $Uri = @{
            "traffic" = "https://api.meraki.com/api/v0/networks/$NetworkID/traffic?timespan=$TimeSpan"
        }

        $traffic = Invoke-RestMethod -Method GET -Uri $Uri.traffic -Headers @{
            'X-Cisco-Meraki-API-Key' = "$ApiKey"
            'Content-Type'           = 'application/json'
        }

        foreach ( $item in $traffic ) {
            $Settings = $item | Select-Object -Property *
            try {
                $trafficProperties = @{
                    application = $Settings.application
                    destination = $Settings.destination
                    protocol    = $Settings.protocol
                    port        = $Settings.port
                    sent        = $Settings.sent
                    recv        = $Settings.recv
                    numClients  = $Settings.numClients
                    activeTime  = $Settings.activeTime
                    flows       = $Settings.flows
                }
                
                $obj = New-Object -TypeName PSObject -Property $trafficProperties
                Write-Output $obj
            }
            catch {
                Write-Host "Failed with error: $_.Message" -ForegroundColor Red
            }
        }
    }

    END { }
}

function Get-MerakiVLAN {
    <#
    .SYNOPSIS
    Short function to provide details for VLANs configured on a specific network ID.
    In order to use this Module you will need an API Key from your Dashboard.

    .DESCRIPTION
    Short function to provide details for VLANs configured on a specific network ID.

    This function queries the Cisco Meraki API service https://dashboard.meraki.com/api/v0 and will be needed for use with additional
    commands within the module.

    API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).

    In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your
    organisation under Organiation > Settings > Dashboard API access.

    After enabling the API, go to the my profile page to generate an API key. The API key is associated with a Dashboard administrator account.
    You can generate, revoke, and regenerate your API key on your profile.

    .EXAMPLE
    Get-MerakiNetworks -ApiKey APIKeyGoesHere -NetworkID NetIDGoesHere -vlanID VlanIDGoesHere

    .INPUTS
    Accepts Api Key as piped input.
    Accepts Organisation ID as piped input.

    .OUTPUTS
    The output from the API is sent as JSON and captured in a custom object.
	{
        "id": "1234",
        "networkId": "N_24329156",
        "name": "My VLAN",
        "applianceIp": "1.2.3.4",
        "subnet": "192.168.1.0/24",
        "fixedIpAssignments": "{}",
        "reservedIpRanges": "",
        "dnsNameservers": "google_dns"
    }

    You can then select the items that you want to display.

    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/CiscoMeraki/wiki

#>

    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your API Key.")]
        [Alias('API')]
        [string]$ApiKey,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Network ID.")]
        [Alias('NetID')]
        [string]$NetworkID,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your VLAN ID.")]
        [Alias('vID')]
        [string]$vlanID

    )

    BEGIN { }

    PROCESS {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $Uri = @{
            "vlans" = "https://api.meraki.com/api/v0/networks/$NetworkID/vlans/$vlanID"
        }

        $vlans = Invoke-RestMethod -Method GET -Uri $Uri.vlans -Headers @{
            'X-Cisco-Meraki-API-Key' = "$ApiKey"
            'Content-Type'           = 'application/json'
        }

        foreach ( $item in $vlans ) {
            $Settings = $item | Select-Object -Property *
            try {
                $vlansProperties = @{
                    id                 = $Settings.id
                    networkId          = $Settings.networkId
                    name               = $Settings.name
                    applianceIp        = $Settings.applianceIp
                    subnet             = $Settings.subnet
                    fixedIpAssignments = $Settings.fixedIpAssignments
                    reservedIpRanges   = $Settings.reservedIpRanges
                    dnsNameservers     = $Settings.dnsNameservers
                }
                
                $obj = New-Object -TypeName PSObject -Property $vlansProperties
                Write-Output $obj
            }
            catch {
                Write-Host "Failed with error: $_.Message" -ForegroundColor Red
            }
        }
    }

    END { }
}

function Get-MerakiVLANList {
    <#
    .SYNOPSIS
    Short function to provide details for VLANs configured on a specific network ID.
    In order to use this Module you will need an API Key from your Dashboard.

    .DESCRIPTION
    Short function to provide details for VLANs configured on a specific network ID.

    This function queries the Cisco Meraki API service https://dashboard.meraki.com/api/v0 and will be needed for use with additional
    commands within the module.

    API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).

    In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your
    organisation under Organiation > Settings > Dashboard API access.

    After enabling the API, go to the my profile page to generate an API key. The API key is associated with a Dashboard administrator account.
    You can generate, revoke, and regenerate your API key on your profile.

    .EXAMPLE
    Get-MerakiNetworks -ApiKey APIKeyGoesHere -NetworkID NetIDGoesHere

    .INPUTS
    Accepts Api Key as piped input.
    Accepts Organisation ID as piped input.

    .OUTPUTS
    The output from the API is sent as JSON and captured in a custom object.
	[
	  {
		"id": "10",
		"networkId": "N_1234",
		"name": "VOIP",
		"applianceIp": "192.168.10.1",
		"subnet": "192.168.10.0/24"
	  }
    ]

    You can then select the items that you want to display.

    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/CiscoMeraki/wiki

#>

    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your API Key.")]
        [Alias('API')]
        [string]$ApiKey,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Network ID.")]
        [Alias('NetID')]
        [string]$NetworkID

    )

    BEGIN { }

    PROCESS {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $Uri = @{
            "vlans" = "https://api.meraki.com/api/v0/networks/$NetworkID/vlans"
        }

        $vlans = Invoke-RestMethod -Method GET -Uri $Uri.vlans -Headers @{
            'X-Cisco-Meraki-API-Key' = "$ApiKey"
            'Content-Type'           = 'application/json'
        }

        foreach ( $item in $vlans ) {
            $Settings = $item | Select-Object -Property *
            try {
                $vlansProperties = @{
                    id          = $Settings.id
                    networkId   = $Settings.networkId
                    name        = $Settings.name
                    applianceIp = $Settings.applianceIp
                    subnet      = $Settings.subnet
                }
                
                $obj = New-Object -TypeName PSObject -Property $vlansProperties
                Write-Output $obj
            }
            catch {
                Write-Host "Failed with error: $_.Message" -ForegroundColor Red
            }
        }
    }

    END { }
}

function Get-MerakiVPNPeers {
    <#
    .SYNOPSIS
    Short function to provide third Party VPN Peer Details.
    In order to use this Module you will need an API Key from your Dashboard.

    .DESCRIPTION
    Short function to provide third Party VPN Peer Details.

    This function queries the Cisco Meraki API service https://dashboard.meraki.com/api/v0 and will be needed for use with additional
    commands within the module.

    API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).

    In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your
    organisation under Organiation > Settings > Dashboard API access.

    After enabling the API, go to the my profile page to generate an API key. The API key is associated with a Dashboard administrator account.
    You can generate, revoke, and regenerate your API key on your profile.

    .EXAMPLE


    .INPUTS
    Accepts Api Key as piped input.
    Accepts Organisation ID as piped input.

    .OUTPUTS
    The output from the API is sent as JSON and captured in a custom object.
    [
        {
            "name":"Your peer",
            "publicIp":"192.168.0.1",
            "privateSubnets":[
                "172.168.0.0/16",
                "172.169.0.0/16"],
            "secret":"asdf1234"
        }
    ]

    You can then select the items that you want to display.

    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/CiscoMeraki/wiki

#>

    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your API Key.")]
        [Alias('API')]
        [string]$ApiKey,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Organisation ID.")]
        [Alias('OrgID')]
        [string]$OrganisationID

    )

    BEGIN { }

    PROCESS {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $Uri = @{
            "thirdPartyVPNPeers" = "https://api.meraki.com/api/v0/organizations/$OrganisationID/thirdPartyVPNPeers"
        }

        $thirdPartyVPNPeers = Invoke-RestMethod -Method GET -Uri $Uri.thirdPartyVPNPeers -Headers @{
            'X-Cisco-Meraki-API-Key' = "$ApiKey"
            'Content-Type'           = 'application/json'
        }

        foreach ( $item in $thirdPartyVPNPeers ) {
            $Settings = $item | Select-Object -Property *
            try {
                $thirdPartyVPNPeersProperties = @{
                    name           = $Settings.name
                    publicIp       = $Settings.publicIp
                    privateSubnets = $Settings.privateSubnets
                    secret         = $Settings.secret
                }
                
                $obj = New-Object -TypeName PSObject -Property $thirdPartyVPNPeersProperties
                Write-Output $obj
            }
            catch {
                Write-Host "Failed with error: $_.Message" -ForegroundColor Red
            }
        }
    }

    END { }
}

Export-ModuleMember -Function '*' -Alias '*' -Cmdlet '*'
