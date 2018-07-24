<#
    .SYNOPSIS
    Short function to list organizations the user has access to which will be needed to use with other commands within this module.
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
    Export your companies ID, Name and SAML Url's by piping in your Api Key
    $key = "YourApiKeyGoesHere"
    Get-MerakiOrganisation.ps1 -ApiKey $key

    .EXAMPLE
    Export your company information (ID, Name and SAML Url's) by piping in your Api Key and specifying the Comapny ID
    $key = "YourApiKeyGoesHere"
    $CompanyID = "YourCompanyIDGoesHere"
    Get-MerakiOrganisation.ps1 -ApiKey $key -OrganisationID $CompanyID

    .EXAMPLE
    Export selected items from your Meraki by piping in your Api Key
    $key = "YourApiKeyGoesHere"
    Get-MerakiOrganisation.ps1 -ApiKey $key |
    Format-List -Property Name,ID

    .EXAMPLE
    Export your company information (ID, Name and SAML Url's) by piping in your Api Key and specifying the Comapny ID
    $key = "YourApiKeyGoesHere"
    $CompanyID = "YourCompanyIDGoesHere"
    Get-MerakiOrganisation.ps1 -ApiKey $key -OrganisationID $CompanyID |
    Format-List -Property *

    .INPUTS
    Accepts Api Key as piped input.

    .OUTPUTS
    The output from the API is sent as JSON and captured in a custom object.
    {
    "id": 549236,
    "name": "Meraki Live Sandbox",
    "samlConsumerUrl": "https://n149.meraki.com/saml/login/-t35Mb/TvUzhbJtIRna",
    "samlConsumerUrls": ["https://n149.meraki.com/saml/login/-t35Mb/TvUzhbJtIRna"]
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
    [Parameter(Mandatory=$True,
                ValueFromPipeline=$True,
                HelpMessage="Enter your API Key.")]
    [Alias('API')]
    [string[]]$ApiKey,

    [Parameter(Mandatory=$True,
                ValueFromPipeline=$True,
                HelpMessage="Enter your Organisation ID.")]
    [Alias('OrgID')]
    [string[]]$OrganisationID

)

BEGIN {}

    PROCESS {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $Uri = @{
        "endPoint" = 'https://api.meraki.com/api/v0/organizations'
        "licenseState" = "https://api.meraki.com/api/v0/organizations/$OrganisationID/licenseState"
    }

    $licenseStates = Invoke-RestMethod -Method GET -Uri $Uri.licenseState -Headers @{
        'OrganisationID' = "$OrganizationId"
        'X-Cisco-Meraki-API-Key' = "$ApiKey"
        'Content-Type' = 'application/json'
    }

    foreach( $licenseState in $licenseStates ) {
        $Lic = $licenseState | Select-Object -Property *

    try {
        $LicProperties = @{
        status = $Lic.status
        expirationDate = $Lic.expirationDate
        licensedDeviceCounts = $Lic.licensedDeviceCounts
        }
    }
    catch {
        $LicProperties = @{
        status = $Lic.status
        expirationDate = $Lic.expirationDate
        licensedDeviceCounts = $Lic.licensedDeviceCounts
        }
    }
    finally {
        $obj = New-Object -TypeName PSObject -Property $LicProperties
        Write-Output $obj
        }
    }
}

END {}
