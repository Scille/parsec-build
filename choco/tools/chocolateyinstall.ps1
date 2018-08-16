
$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'http://localhost:8000/parsec-v0.8.2-amd64.exe'
$url64      = 'http://localhost:8000/parsec-v0.8.2-amd64.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url
  url64bit      = $url64

  softwareName  = 'parsec*'

  checksum      = 'DF8CB494524E146B0182D50EA25F3109961244F15E2BF5424701DBF86FA4B7BD'
  checksumType  = 'sha256'
  checksum64    = 'DF8CB494524E146B0182D50EA25F3109961244F15E2BF5424701DBF86FA4B7BD'
  checksumType64= 'sha256'

  silentArgs    = "/S `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs

