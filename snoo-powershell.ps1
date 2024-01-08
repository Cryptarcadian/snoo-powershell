# PowerShell interface for SNOO data APIs
# Author: Stephen Mok <me@stephen.is>

# This tool is not affiliated with or endorsed by Happiest Baby
# SNOO is a "smart bassinet" for babies: https://www.happiestbaby.com/products/snoo-smart-bassinet

function Set-SnooToken {
	# Save into $PSDefaultParameterValues for the session
	# which will then be used for each Get-SnooData call
	[CmdletBinding()]
	param([Parameter(Mandatory=$true)] [SecureString] $Token)
	$PSDefaultParameterValues["Get-SnooData:Token"] = $Token
}

function Request-SnooToken {
	# Switch -Save automatically calls Set-SnooToken after
	# or returns it for you to store and manage manually
	param([Switch]$Save)
	$RequestParams = @{
		UserAgent = 'SNOO/351 CFNetwork/1121.2 Darwin/19.2.0'
		Method = 'POST'
		Headers = @{
			'Accept' = 'application/json'
			'Content-Type' = 'application/json;charset=UTF-8'
		}
		SessionVariable = 'Session'
		Uri = 'https://snoo-api.happiestbaby.com/us/login'
	}
	$RequestCredentials = Get-Credential -Title 'Access the Snoo API with your Happiest Baby account'
	$RequestCredentialsJson = @{
		'username' = $RequestCredentials.UserName
		'password' = ($RequestCredentials.Password | ConvertFrom-SecureString -AsPlainText)
	} | ConvertTo-Json
	$Response = Invoke-RestMethod @RequestParams -Body $RequestCredentialsJson
	if ($Response -and $Response.access_token) {
		if ($Save) {
			Set-SnooToken ($Response.access_token | ConvertTo-SecureString -AsPlainText)
		} else {
			$Response.access_token
		}
	}
}

function Get-SnooData {
	[CmdletBinding()]
	param([SecureString]$Token, [Uri]$Endpoint, [Switch]$AsJson, $Query)
	if (!$Token) {
		$Token = (Request-SnooToken | ConvertTo-SecureString -AsPlainText)
	}
	if (!$Endpoint) {
		$Endpoint = 'analytics/sessions/last'
	}
	$RequestParams = @{
		UserAgent = 'SNOO/351 CFNetwork/1121.2 Darwin/19.2.0'
		Method = 'GET'
		Authentication = 'Bearer'
		SessionVariable = 'Session'
		Token = $Token
		Uri = 'https://snoo-api.happiestbaby.com/' + $Endpoint
		Body = $Query
	}
	$Response = Invoke-RestMethod @RequestParams
	if ($AsJson) {
		$Response | ConvertTo-Json -Depth 100
	} else {
		$Response
	}
}

function Get-SnooDevice {
	[CmdletBinding()]
	param([Switch]$AsJson)
	Get-SnooData -Endpoint 'me/devices' -AsJson:$AsJson
}

function Get-SnooAccount {
	[CmdletBinding()]
	param([Switch]$AsJson)
	Get-SnooData -Endpoint 'us/me' -AsJson:$AsJson
}

function Get-SnooBaby {
	[CmdletBinding()]
	param([Switch]$AsJson)
	Get-SnooData -Endpoint 'us/v3/me/baby' -AsJson:$AsJson
}

function Get-SnooDeviceConfig {
	[CmdletBinding()]
	param([Switch]$AsJson)
	Get-SnooData -Endpoint ('ds/devices/' + (Get-SnooDevice).serialNumber  + '/configs') -AsJson:$AsJson
}

function Get-SnooSessionsDaily {
	[CmdletBinding()]
	param([Switch]$AsJson, $Start)
	$Query = @{
		'levels' = 'true'
		'detailedLevels' = 'true'
		'startTime' = (Get-Date $Start -Format 'O')
		# No timezone conversion -- assumes you are requesting from the same timezone the SNOO was used in
		# It would be a good idea to specify the same start time (e.g. 10:00) that you have set as the 'SNOO Log Start Time' in the app
	}
	Get-SnooData -EndPoint ('ss/v2/babies/' + (Get-SnooBaby)."_id" + '/sessions/aggregated/daily') -Query $Query -AsJson:$AsJson
}