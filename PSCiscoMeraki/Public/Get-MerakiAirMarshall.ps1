function Get-MerakiAirMarshall {
  <#
    .SYNOPSIS
    Short function to provide details for an access policy configured on a specific network ID.
    In order to use this Module you will need an API Key from your Dashboard.

    .DESCRIPTION
    Short function to provide details for an access policy configured on a specific network ID

    This function queries the Cisco Meraki API service https://dashboard.meraki.com/api/v0 and will be needed for use with additional
    commands within the module.

    API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).

    In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your
    organisation under Organiation > Settings > Dashboard API access.

    After enabling the API, go to the my profile page to generate an API key. The API key is associated with a Dashboard administrator account.
    You can generate, revoke, and regenerate your API key on your profile.

    .EXAMPLE
    Get-MerakiNetworks -ApiKey APIKeyGoesHere -NetworkID NetIDGoesHere

    .INPUTS
    Accepts Api Key as piped input.
    Accepts Organisation ID as piped input.

    .OUTPUTS
    The output from the API is sent as JSON and captured in a custom object.
    [
      {
        "ssid": "linksys",
        "bssids": [
          {
            "bssid": "00:11:22:33:44:55",
            "contained": false,
            "detectedBy": [
              {
                "device": "Q234-ABCD-5678",
                "rssi": 17
              }
            ]
          }
        ],
        "channels": [
          36,
          40
        ],
        "firstSeen": 1518365681,
        "lastSeen": 1526087474,
        "wiredMacs": [
          "00:11:22:33:44:55"
        ],
        "wiredVlans": [
          0,
          108
        ],
        "wiredLastSeen": 1526087474
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
      HelpMessage = "Enter your Network ID.")]
    [Alias('NetID')]
    [string]$NetworkID,

    [Parameter(Mandatory = $True,
      ValueFromPipeline = $True,
      HelpMessage = "Enter your time span in seconds (e.g. 3600). Must be a maximum of one month in seconds.")]
    [Alias('TS')]
    [string]$TimeSpan

  )

  BEGIN { }

  PROCESS {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $Uri = @{
      "timespan" = "https://api.meraki.com/api/v0/networks/$NetworkID/airMarshal?timespan=$TimeSpan"
    }

    $timespaned = Invoke-RestMethod -Method GET -Uri $Uri.timespan -Headers @{
      'X-Cisco-Meraki-API-Key' = "$ApiKey"
      'Content-Type'           = 'application/json'
    }

    foreach ( $item in $timespaned ) {
      $Settings = $item | Select-Object -Property *
      try {
        $timespanProperties = @{
          ssid          = $Settings.ssid
          bssids        = $Settings.bssids
          channels      = $Settings.channels
          firstSeen     = $Settings.firstSeen
          lastSeen      = $Settings.lastSeen
          wiredMacs     = $Settings.wiredMacs
          wiredVlans    = $Settings.wiredVlans
          wiredLastSeen = $Settings.wiredLastSeen
        }
      }
      catch {
        $timespanProperties = @{
          ssid          = $Settings.ssid
          bssids        = $Settings.bssids
          channels      = $Settings.channels
          firstSeen     = $Settings.firstSeen
          lastSeen      = $Settings.lastSeen
          wiredMacs     = $Settings.wiredMacs
          wiredVlans    = $Settings.wiredVlans
          wiredLastSeen = $Settings.wiredLastSeen
        }
      }
      finally {
        $obj = New-Object -TypeName PSObject -Property $timespanProperties
        Write-Output $obj
      }
    }
  }

  END { }
}