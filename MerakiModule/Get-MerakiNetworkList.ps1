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
            }
            catch {
                $networksProperties = @{
                    id             = $Settings.id
                    organizationId = $Settings.organizationId
                    name           = $Settings.name
                    timeZone       = $Settings.timeZone
                    tags           = $Settings.tags
                    type           = $Settings.type
                }
            }
            finally {
                $obj = New-Object -TypeName PSObject -Property $networksProperties
                Write-Output $obj
            }
        }
    }

    END { }
}