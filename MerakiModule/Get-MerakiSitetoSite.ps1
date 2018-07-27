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
    [string[]]$ApiKey,

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        HelpMessage = "Enter your Network ID.")]
    [Alias('NetID')]
    [string[]]$NetworkID

)

BEGIN {}

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
        }
        catch {
            $siteToSiteVpnProperties = @{
                mode    = $Settings.mode
                hubs    = $Settings.hubs
                subnets = $Settings.subnets
            }
        }
        finally {
            $obj = New-Object -TypeName PSObject -Property $siteToSiteVpnProperties
            Write-Output $obj
        }
    }
}

END {}