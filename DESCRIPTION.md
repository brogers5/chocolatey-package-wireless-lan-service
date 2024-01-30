## Wireless LAN Service

Wireless LAN (WLAN) Service configures and starts the WLAN AutoConfig service, regardless of whether the computer has any wireless adapters. WLAN AutoConfig enumerates wireless adapters, and manages both wireless connections and the wireless profiles that contain the settings required to configure a wireless client to connect to a wireless network.

## Package Notes

This package does not directly download any software. It uses the recommended servicing implementation for different Windows Server versions to configure the relevant OS feature:

|Implementation|Version|Feature Name|
|-|-|-|
|[`ServerManagerCmd.exe`](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/servermanagercmd)|2008|`Wireless-Networking`|
|[`DISM.exe`](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/what-is-dism)|2008 R2|`WirelessNetworking`|
|[PowerShell's DISM module](https://learn.microsoft.com/en-us/powershell/module/dism)|2012+|`WirelessNetworking`|

This package is intended to be consumed as a dependency for any Chocolatey packages that require Windows components or other functionality exposed by the feature.

Note that the feature is [not available for Server Core installations](https://learn.microsoft.com/en-us/windows-server/administration/server-core/server-core-removed-roles). The package's installation should therefore fail in such environments.

The package's installation should do nothing if either of the following applies:

* The feature is already enabled
* The package is installed on a non-Server version of Windows
  * No action is necessary in this case, since the feature is a mandatory component of Windows.

The package's uninstallation should disable the feature if it is available, regardless of whether it was enabled prior to installation. If this behavior is undesired, be sure to use the `--skip-powershell` switch when uninstalling.
