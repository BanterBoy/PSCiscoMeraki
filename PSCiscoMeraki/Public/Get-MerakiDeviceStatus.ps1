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
            }
            catch {
                $DeviceProperties = @{
                    lanIp     = $item.lanIp
                    mac       = $item.mac
                    name      = $item.name
                    networkId = $item.networkId
                    publicIp  = $item.publicIp
                    serial    = $item.serial
                    status    = $item.status
                }
            }
            finally {
                $obj = New-Object -TypeName PSObject -Property $DeviceProperties
                Write-Output $obj
            }
        }
    }

    END { }
}
