## SYNOPSIS

Short function to list organizations admin users which will be needed to use with other commands within this module.
In order to use this Module you will need an API Key from your Dashboard.

## DESCRIPTION

Short function to output your Meraki Organisation ID which you will need in order to use with other commands within this module.

This function queries the Cisco Meraki API service <https://dashboard.meraki.com/api/v0> and will be needed for use with additional
commands within the module.

API Access is free but Rate Controlled and is limited to 5 calls per second (per organisation).

In order to use this Module you will need an API Key from your Dashboard. For access to the API, first enable the API for your
organisation under Organiation > Settings > Dashboard API access.

![Enable API Access](https://raw.githubusercontent.com/BanterBoy/CiscoMeraki/master/assets/EnableAPIAccess.png)

After enabling the API, go to the **my profile** page to generate an API key. The API key is associated with a Dashboard administrator account. You can generate, revoke, and regenerate your API key on your profile.

![Generate API Key](https://raw.githubusercontent.com/BanterBoy/CiscoMeraki/master/assets/GenerateKey.png)

****Note:*** Keep your API key safe as it provides authentication to all of your organizations with the API enabled. If your API key is shared, you can regenerate your API key at any time. This will revoke the existing API key.*

****Note*** that SAML dashboard administrators cannot view or generate API keys.*

### EXAMPLE 1

    Export your companies ID, Name and SAML Url's
    Get-MerakiAdminList -ApiKey "YourApiKeyGoesHere"


## INPUTS

Accepts Api Key as piped input.
Accepts Organisation ID as piped input.

## OUTPUTS

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

## NOTES

    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

## LINK

    https://github.com/BanterBoy/CiscoMeraki/wiki
