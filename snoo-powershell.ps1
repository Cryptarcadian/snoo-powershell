# PowerShell interface for SNOO data APIs
# Author: Stephen Mok <me@stephen.is>

# This tool is not affiliated with or endorsed by Happiest Baby
# SNOO is a "smart bassinet" for babies: https://www.happiestbaby.com/products/snoo-smart-bassinet

function Set-SnooToken {
	[CmdletBinding()]
	param([Parameter(Mandatory=$true)] [SecureString] $Token)
	$PSDefaultParameterValues["*-Snoo*:Token"] = $Token
}

function Request-SnooToken {
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
	$RequestCredentials = Get-Credential -Title 'Log in with your Happiest Baby account to access the SNOO API'
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