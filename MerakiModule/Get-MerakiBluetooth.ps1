<#
    .SYNOPSIS
    Short function to provide details for Bluetooth settings configured on the Meraki Devices.
    In order to use this Module you will need an API Key from your Dashboard.

    .DESCRIPTION
    Short function to provide details for Bluetooth settings configured on the Meraki Devices.

    This function queries the Cisco Meraki API service https://dashboard.meraki.com/api/v0 and will be needed for use with additional
    commands within the module.

    API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).

    In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your
    organisation under Organiation > Settings > Dashboard API access.

    After enabling the API, go to the my profile page to generate an API key. The API key is associated with a Dashboard administrator account.
    You can generate, revoke, and regenerate your API key on your profile.

    .EXAMPLE
    Get-MerakiBluetooth -ApiKey APIKeyGoesHere -NetworkID NetIDGoesHere

    Description

    -----------

    This command connects to the Meraki API and performs a Get

    .INPUTS
    Accepts Api Key as piped input.
    Accepts Organisation ID as piped input.

    .OUTPUTS
    The output from the API is sent as JSON and captured in a custom object.
    {
        "scanningEnabled": true,
        "advertisingEnabled": true,
        "uuid": "95bba6e5-c32d-446b-fake-aebd4c62888d",
        "majorMinorAssignmentMode": "Non-unique",
        "major": 0,
        "minor": 0
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
    [string[]]$ApiKey,

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        HelpMessage = "Enter your Network ID.")]
    [Alias('NetID')]
    [string[]]$NetworkID

)

BEGIN {}

PROCESS {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $Uri = @{
        "bluetoothSettings" = "https://api.meraki.com/api/v0/networks/$NetworkID/bluetoothSettings"
    }

    $bluetoothSettings = Invoke-RestMethod -Method GET -Uri $Uri.bluetoothSettings -Headers @{
        'X-Cisco-Meraki-API-Key' = "$ApiKey"
        'Content-Type'           = 'application/json'
    }

    foreach ( $item in $bluetoothSettings ) {
        $Settings = $item | Select-Object -Property *
        try {
            $bluetoothSettingsProperties = @{
                scanningEnabled          = $Settings.scanningEnabled
                advertisingEnabled       = $Settings.advertisingEnabled
                uuid                     = $Settings.uuid
                majorMinorAssignmentMode = $Settings.majorMinorAssignmentMode
                major                    = $Settings.major
                minor                    = $Settings.minor
                type                     = $Settings.type
            }
        }
        catch {
            $bluetoothSettingsProperties = @{
                scanningEnabled          = $Settings.scanningEnabled
                advertisingEnabled       = $Settings.advertisingEnabled
                uuid                     = $Settings.uuid
                majorMinorAssignmentMode = $Settings.majorMinorAssignmentMode
                major                    = $Settings.major
                minor                    = $Settings.minor
                type                     = $Settings.type
            }
        }
        finally {
            $obj = New-Object -TypeName PSObject -Property $bluetoothSettingsProperties
            Write-Output $obj
        }
    }
}

END {}