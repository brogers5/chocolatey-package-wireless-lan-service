# Chocolatey Package: [Wireless LAN Service](https://community.chocolatey.org/packages/wireless-lan-service)

[![Chocolatey package version](https://img.shields.io/chocolatey/v/wireless-lan-service.svg)](https://community.chocolatey.org/packages/wireless-lan-service)
[![Chocolatey package download count](https://img.shields.io/chocolatey/dt/wireless-lan-service.svg)](https://community.chocolatey.org/packages/wireless-lan-service)

## Install

[Install Chocolatey](https://chocolatey.org/install), and run the following command to install the latest approved stable version from the Chocolatey Community Repository:

```shell
choco install wireless-lan-service --source="'https://community.chocolatey.org/api/v2'"
```

Alternatively, the packages as published on the Chocolatey Community Repository will also be mirrored on this repository's [Releases page](https://github.com/brogers5/chocolatey-package-wireless-lan-service/releases). The `nupkg` can be installed from the current directory (with dependencies sourced from the Community Repository) as follows:

```shell
choco install wireless-lan-service --source="'.;https://community.chocolatey.org/api/v2/'"
```

## Build

[Install Chocolatey](https://chocolatey.org/install), clone this repository, and run the following command in the cloned repository:

```shell
choco pack
```

A successful build will create `wireless-lan-service.x.y.z.nupkg`, where `x.y.z` should be the Nuspec's `version` value at build time.

Note that Chocolatey package builds are non-deterministic. Consequently, an independently built package will fail a checksum validation against officially published packages.

## Notes

This package is intended to be a stopgap solution for Chocolatey packages requiring the Wireless LAN Service feature until [support for declaring package dependencies from the `WindowsFeatures` source](https://github.com/chocolatey/choco/issues/879) is implemented in Chocolatey CLI. Assuming the implementation behaves similarly, the package will likely be deprecated in favor of this approach once released.

This package is manually maintained because it does not consume any external software, and only serves as an abstraction of a long-standing optional feature in Windows Server. Therefore, significant package updates outside the scope of bug fixes and compatibility enhancements for future versions of Windows are unlikely.
