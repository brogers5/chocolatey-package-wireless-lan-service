$ErrorActionPreference = 'Stop'

$optionalFeatureName = 'WirelessNetworking'
if (Get-IsWinServer) {
  Write-Output "Windows Server operating system detected."

  $majorVersion = [Environment]::OSVersion.Version.Major
  if ($majorVersion -lt '6') {
    throw 'The feature is not supported on this operating system!'
  }

  $logPath = "$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).Install.log"

  if (Get-IsWinServer2008) {
    #Since PowerShell is not available for Server Core installations,
    #this assumes we are running in a Desktop Experience installation.
    $legacyFeatureName = 'Wireless-Networking'
    $enableArgs = @{
      exeToRun       = "$env:windir\System32\ServerManagerCmd.exe"
      statements     = @(
        '-install',
        $legacyFeatureName,
        '-logPath',
        $logPath
      )
      elevated       = $true
      validExitCodes = @(0, 1003, 3010)
    }

    Write-Output "Enabling the $legacyFeatureName feature..."
    $exitCode = Start-ChocolateyProcessAsAdmin @enableArgs
    Set-PowerShellExitCode -ExitCode $exitCode
  }
  elseif (Get-IsWinServer2008R2) {
    #The feature may not be available if it's a Server Core installation.
    #Ensure the feature is actually available for use before proceeding.
    $queryArgs = @{
      exeToRun       = "$env:windir\System32\Dism.exe"
      statements     = @(
        '/Online',
        '/Get-FeatureInfo',
        "/FeatureName:$optionalFeatureName",
        "/LogPath:$logPath"
      )
      elevated       = $true
      validExitCodes = @(0)
    }

    Write-Output "Confirming the $optionalFeatureName feature is available for this installation..."
    Start-ChocolateyProcessAsAdmin @queryArgs | Write-Debug

    $enableArgs = @{
      exeToRun       = "$env:windir\System32\Dism.exe"
      statements     = @(
        '/Online',
        '/Enable-Feature',
        "/FeatureName:$optionalFeatureName",
        "/LogPath:$logPath",
        '/NoRestart'
      )
      elevated       = $true
      validExitCodes = @(0, 3010)
    }

    Write-Output "Enabling the $optionalFeatureName feature..."
    $exitCode = Start-ChocolateyProcessAsAdmin @enableArgs
    Set-PowerShellExitCode -ExitCode $exitCode
  }
  else {
    #The feature may not be available if it's a Server Core installation.
    #Ensure the feature is actually available for use before proceeding.
    Write-Output "Confirming the $optionalFeatureName feature is available for this installation..."
    $feature = Get-WindowsOptionalFeature -Online -FeatureName $optionalFeatureName

    if ($null -eq $feature) {
      throw "The $optionalFeatureName feature is not available!"
    }
    elseif ($feature.State -eq 'Enabled') {
      Write-Output "$optionalFeatureName has already been enabled by other means."
    }
    else {
      Write-Output "Enabling the $optionalFeatureName feature..."
      $imageObject = Enable-WindowsOptionalFeature -Online -FeatureName $optionalFeatureName -LogPath $logPath -NoRestart
      if ($imageObject.RestartNeeded) {
        Set-PowerShellExitCode -ExitCode 3010
      }
    }
  }
}
else {
  Write-Output "Skipping installation - the $optionalFeatureName feature is not applicable for this operating system."
}
