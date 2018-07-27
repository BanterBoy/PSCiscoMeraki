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
    [string[]]$ApiKey,

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        HelpMessage = "Enter your Network ID.")]
    [Alias('NetID')]
    [string[]]$NetworkID,

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        HelpMessage = "Enter your TimeSpan (duration in seconds between two hours and one month).")]
    [Alias('TS')]
    [string[]]$TimeSpan
)

BEGIN {}

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
        }
        catch {
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
        }
        finally {
            $obj = New-Object -TypeName PSObject -Property $trafficProperties
            Write-Output $obj
        }
    }
}

END {}