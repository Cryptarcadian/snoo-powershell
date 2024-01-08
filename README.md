snoo-powershell
===============

PowerShell interface for the data APIs of the [SNOO baby bassinet](https://www.happiestbaby.com/products/snoo-smart-bassinet)

Not affiliated with or endorsed by Happiest Baby


Usage
-----

* Start with `Request-SnooToken` to get a bearer token
	* Use `-Save` to store it for the session via PowerShell's `$PSDefaultParameters` automatic variable)
* Retrieve data using one of:
	* `Get-SnooAccount`
	* `Get-SnooDevice` 
	* `Get-SnooDeviceConfig`
	* `Get-SnooStatus`
	* `Get-SnooBaby`
		* Use `-Save` to store the baby ID via `$PSDefaultParameters` to speed up subsequent session requests
	* `Get-SnooSessions`
		* Gets daily stats with all level details by default
		* Use `-Weekly` or `-Monthly` to get aggregated stats
	* `Get-SnooData -Endpoint <PATH>` for other endpoints
	* PowerShell objects are returned, or you can request `-AsJson`