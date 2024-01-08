snoo-powershell
===============

Basic PowerShell interface for the data APIs of the [SNOO baby bassinet](https://www.happiestbaby.com/products/snoo-smart-bassinet)

Not affiliated with or endorsed by Happiest Baby


Usage
-----

* Start with `Request-SnooToken` to get a bearer token
	* Use `-Save` to store it for the session via PowerShell's `$PSDefaultParameters` automatic variable)
* Retrieve data using one of:
	* `Get-SnooAccount`
	* `Get-SnooDevice` 
	* `Get-SnooDeviceConfig`
	* `Get-SnooBaby`
	* `Get-SnooSessions -Daily`
	* `Get-SnooSessions -Weekly`
	* `Get-SnooData -Endpoint <PATH>` for other endpoints
	* PowerShell objects are returned, or you can request `-AsJson`