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
            }
            catch {
                $SNMPProperties = @{
                    v2cEnabled = $Settings.v2cEnabled
                    v3Enabled  = $Settings.v3Enabled
                    v3AuthMode = $Settings.v3AuthMode
                    v3PrivMode = $Settings.v3PrivMode
                    peerIps    = $Settings.peerIps
                    hostname   = $Settings.hostname
                    port       = $Settings.port
                }
            }
            finally {
                $obj = New-Object -TypeName PSObject -Property $SNMPProperties
                Write-Output $obj
            }
        }
    }

    END { }
}