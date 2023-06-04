$ErrorActionPreference = 'Stop'

$optionalFeatureName = 'WirelessNetworking'
$logPath = "$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).Uninstall.log"

if (Get-IsWinServer2008) {
    $legacyFeatureName = 'Wireless-Networking'
    $disableArgs = @{
        exeToRun       = "$env:windir\System32\ServerManagerCmd.exe"
        statements     = @(
            '-remove',
            $legacyFeatureName,
            '-logPath',
            $logPath
        )
        elevated       = $true
        validExitCodes = @(0, 1003, 3010)
    }

    Write-Output "Disabling the $legacyFeatureName feature..."
    $exitCode = Start-ChocolateyProcessAsAdmin @disableArgs
    Set-PowerShellExitCode -ExitCode $exitCode
}
elseif (Get-IsWinServer2008R2) {
    $disableArgs = @{
        exeToRun       = "$env:windir\System32\Dism.exe"
        statements     = @(
            '/Online',
            '/Disable-Feature',
            "/FeatureName:$optionalFeatureName",
            "/LogPath:$logPath",
            '/NoRestart'
        )
        elevated       = $true
        validExitCodes = @(0, 3010)
    }

    Write-Output "Disabling the $optionalFeatureName feature..."
    $exitCode = Start-ChocolateyProcessAsAdmin @disableArgs
    Set-PowerShellExitCode -ExitCode $exitCode
}
else {
    $feature = Get-WindowsOptionalFeature -Online -FeatureName $optionalFeatureName

    if ($null -eq $feature) {
        Write-Output "The $optionalFeatureName feature is not available - no changes are necessary."
    }
    elseif ($feature.State -eq 'Disabled') {
        Write-Warning "$optionalFeatureName has already been disabled by other means."
    }
    else {
        Write-Output "Disabling the $optionalFeatureName feature..."
        $imageObject = Disable-WindowsOptionalFeature -Online -FeatureName $optionalFeatureName -LogPath $logPath -NoRestart
        if ($imageObject.RestartNeeded) {
            Set-PowerShellExitCode -ExitCode 3010
        }
    }
}
