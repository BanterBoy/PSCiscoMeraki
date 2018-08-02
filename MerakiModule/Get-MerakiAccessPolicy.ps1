<#
    .SYNOPSIS
    Short function to provide details for an access policy configured on a specific network ID. Only valid for MS networks.
    In order to use this Module you will need an API Key from your Dashboard.

    .DESCRIPTION
    Short function to provide details for an access policy configured on a specific network ID. Only valid for MS networks.

    This function queries the Cisco Meraki API service https://dashboard.meraki.com/api/v0 and will be needed for use with additional
    commands within the module.

    API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).

    In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your
    organisation under Organiation > Settings > Dashboard API access.

    After enabling the API, go to the my profile page to generate an API key. The API key is associated with a Dashboard administrator account.
    You can generate, revoke, and regenerate your API key on your profile.

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
        }
        catch {
            $accessPoliciesProperties = @{
                number        = $Settings.number
                name          = $Settings.name
                accessType    = $Settings.accessType
                guestVlan     = $Settings.guestVlan
                radiusServers = $Settings.radiusServers
            }
        }
        finally {
            $obj = New-Object -TypeName PSObject -Property $accessPoliciesProperties
            Write-Output $obj
        }
    }
}

END {}