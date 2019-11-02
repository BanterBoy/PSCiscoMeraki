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
            }
            catch {
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
            }
            finally {
                $obj = New-Object -TypeName PSObject -Property $vlansProperties
                Write-Output $obj
            }
        }
    }

    END { }
}