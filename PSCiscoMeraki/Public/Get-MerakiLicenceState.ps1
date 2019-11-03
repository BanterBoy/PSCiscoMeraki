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
            }
            catch {
                $LicProperties = @{
                    status               = $Lic.status
                    expirationDate       = $Lic.expirationDate
                    licensedDeviceCounts = $Lic.licensedDeviceCounts
                }
            }
            finally {
                $obj = New-Object -TypeName PSObject -Property $LicProperties
                Write-Output $obj
            }
        }
    }

    END { }
}