# ParSec Build

[![Build Status](https://travis-ci.org/Scille/parsec-build.svg?branch=master)](https://travis-ci.org/Scille/parsec-build)

[![Build status](https://ci.appveyor.com/api/projects/status/dc0pbcocq03bluml/branch/master?svg=true)](https://ci.appveyor.com/project/touilleMan/parsec-build/branch/master)

Secure cloud framework

* Free software: AGPL v3
* Documentation: https://parsec-cloud.readthedocs.org.

## AppVeyor and Travis automatic builds

Change the version in [version](https://raw.githubusercontent.com/Scille/parsec-build/master/version) file.  
Version can be a commit or a tag name of [parsec-cloud](https://github.com/Scille/parsec-cloud) repository.  
Commit the [Travis](https://travis-ci.org/Scille/parsec-build/builds) and [AppVeyor](https://ci.appveyor.com/project/touilleman/parsec-build/history) builds will be trigerred.  
The snap and Windows installer will be pushed on Github parsec-build [releases](https://github.com/Scille/parsec-build/releases).  
The [snap](https://snapcraft.io/parsec) and [choco](https://chocolatey.org/packages/parsec-cloud/) packages will be also pushed on their respective stores.

## Local builds

### Linux Snap package

Export the `GITHUB_API_TOKEN` and `PARSEC_VERSION` (optional, otherwise the version is read on the version file).  
Run `local_build.sh` and the resulting snap will be pushed in the parsec-build Github parsec-build [releases](https://github.com/Scille/parsec-build/releases).

### Windows installer
Not yet available.

## Windows installer sign tool
Download the installer once AppVeyor has pushed the release on Github [releases](https://github.com/Scille/parsec-build/releases).  
Plug the Certum card.  
Run `parsec_sign_tool.bat <parsec_installer_absolute_file_path>` to sign it!
