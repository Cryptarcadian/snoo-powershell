snoo-powershell
===============
 
A PowerShell client/wrapper for the (read-only) data API of the [SNOO Smart Bassinet](https://www.happiestbaby.com/products/snoo-smart-bassinet) for babies.

The aim is to retrieve the complete raw data provided by the API for archiving or further use. Requires the cross-platform PowerShell 7 or newer (formerly Windows PowerShell).

This tool is not affiliated with or endorsed by Happiest Baby.


Usage
-----

* Start with `Request-SnooToken` to get a bearer token
	* Use `-Save` to store it for the session via PowerShell's `$PSDefaultParameters` automatic variable
* Retrieve data using one of:
	* `Get-SnooAccount`
	* `Get-SnooDevice` 
	* `Get-SnooDeviceConfig`
	* `Get-SnooStatus`
	* `Get-SnooBaby`
		* Use `-Save` to store the baby ID via `$PSDefaultParameters` to speed up subsequent session requests
	* `Get-SnooSessions <DATETIME>`
		* Gets daily stats with all level details by default
		* Use `-Weekly` or `-Monthly` to get aggregated stats
		* Recommendation: use the same start time as your 'SNOO Log Start Time' preference in the SNOO app, e.g. `Get-SnooSessions '2024-01-01 10:00'` (assumes you are requesting data from the same timezone as your SNOO)
	* `Get-SnooData -Endpoint <PATH>` for other endpoints
	* PowerShell objects are returned for each request, or you can specify `-AsJson`


Acknowledgements
----------------

Inspired by similar projects in Python:

* https://github.com/sanghviharshit/pysnooapi
* https://github.com/maebert/snoo