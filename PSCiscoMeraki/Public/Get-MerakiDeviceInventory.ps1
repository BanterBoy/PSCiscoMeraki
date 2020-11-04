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