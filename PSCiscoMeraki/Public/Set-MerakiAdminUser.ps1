<#
    .SYNOPSIS
    Short function to list organizations admin users which will be needed to use with other commands within this module.
    In order to use this Module you will need an API Key from your Dashboard.

    .DESCRIPTION
    Short function to output your Meraki Organisation ID which you will need in order to use with other commands within this module.

    This function queries the Cisco Meraki API service https://dashboard.meraki.com/api/v0 and will be needed for use with additional
    commands within the module.

    API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).

    In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your
    organisation under Organiation > Settings > Dashboard API access.

    After enabling the API, go to the my profile page to generate an API key. The API key is associated with a Dashboard administrator account.
    You can generate, revoke, and regenerate your API key on your profile.

    .EXAMPLE
    Export your companies ID, Name and SAML Url's
    Get-MerakiOrganisation.ps1 -ApiKey "YourApiKeyGoesHere"

    .EXAMPLE
    $key = "YourApiKeyGoesHere"
    Get-MerakiOrganisation.ps1 -ApiKey $key

    This example will enable you to Export your companies ID, Name and SAML Url's by piping in your Api Key

    .EXAMPLE
    $key = "YourApiKeyGoesHere"
    $CompanyID = "YourCompanyIDGoesHere"
    Get-MerakiOrganisation.ps1 -ApiKey $key -OrganisationID $CompanyID

    Export your company information (ID, Name and SAML Url's) by piping in your Api Key and specifying the Comapny ID

    .EXAMPLE
    $key = "YourApiKeyGoesHere"
    $orgID = "515085"
    $Admins = .\MerakiModule\Get-MerakiAdminList.ps1 -ApiKey $key -OrganisationID $orgID
    $Admins | Sort-Object Name | Select-Object -Property * | Format-List

    Export alpabetised Admin User List from your Meraki by piping in your Api Key, Organisation ID

    .EXAMPLE
    $key = "YourApiKeyGoesHere"
    $CompanyID = "YourCompanyIDGoesHere"
    Get-MerakiOrganisation.ps1 -ApiKey $key -OrganisationID $CompanyID |
    Format-List -Property *

    Export your company information (ID, Name and SAML Url's) by piping in your Api Key and specifying the Comapny ID

    .INPUTS
    Accepts Api Key as piped input.
    Accepts Organisation ID as piped input.

    .OUTPUTS
    The output from the API is sent as JSON and captured in a custom object.
    [
        {
            "name": "Miles Meraki",
            "email": "miles+test@meraki.com",
            "id": "646829496481123357",
            "networks": [],
            "tags": [
                {
                    "tag": "Sandbox",
                    "access": "full"
                }
            ],
            "orgAccess": "read-only"
        },
        {
            "name": "adminstrator123",
            "email": "administrator123@ikarem.com",
            "id": "646829496481136255",
            "networks": [],
            "tags": [],
            "orgAccess": "read-only"
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

    [Parameter(Mandatory = $false,
        ValueFromPipeline = $True,
        HelpMessage = "Enter your Organisation ID.")]
    [Alias('OrgID')]
    [string[]]$OrganisationID,

    [Parameter(Mandatory = $false,
        ValueFromPipeline = $True,
        HelpMessage = "Enter your Admin ID.")]
    [Alias('aID')]
    [string[]]$adminID
)

BEGIN {}

PROCESS {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $Uri = @{
        "admins" = "https://api.meraki.com/api/v0/organizations/$OrganisationID/admins/$adminID"
    }

    $admins = Invoke-RestMethod -Method Put -Uri $Uri.admins -Headers @{
        'X-Cisco-Meraki-API-Key' = "$ApiKey"
        'Content-Type'           = 'application/json'
    }

    # foreach ( $item in $admins ) {
    #     $Settings = $item | Select-Object -Property *

    #     try {
    #         $adminProperties = @{
    #             name      = $Settings.name
    #             email     = $Settings.email
    #             id        = $Settings.id
    #             networks  = $Settings.networks
    #             tags      = $Settings.tags
    #             orgAccess = $Settings.orgAccess
    #         }
    #
    #         $obj = New-Object -TypeName PSObject -Property $adminProperties
    #         Write-Output $obj
    #     }
    #     catch {
    #         Write-Host "Failed with error: $_.Message" -ForegroundColor Red
    #     }
    # }

}

END {}
