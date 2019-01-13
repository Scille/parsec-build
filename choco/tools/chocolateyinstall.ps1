$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/Scille/parsec-build/releases/download/v0.9.0/parsec-v0.9.0-amd64.exe'
$url64      = 'https://github.com/Scille/parsec-build/releases/download/v0.9.0/parsec-v0.9.0-amd64.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url
  url64bit      = $url64

  softwareName  = 'parsec*'

  checksum      = 'CHECKSUM'
  checksumType  = 'sha256'
  checksum64    = 'CHECKSUM'
  checksumType64= 'sha256'

  silentArgs    = "/S `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs

