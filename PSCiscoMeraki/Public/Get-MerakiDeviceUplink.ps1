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
            }
            catch {
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
            }
            finally {
                $obj = New-Object -TypeName PSObject -Property $DeviceProperties
                Write-Output $obj
            }
        }
    }

    END { }
}
