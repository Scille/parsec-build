# Parsec Cloud (https://parsec.cloud) Copyright (c) AGPLv3 2019 Scille SAS

import os
from parsec.cli import cli


def parsec():
    os.environ["SENTRY_URL"] = "https://863e60bbef39406896d2b7a5dbd491bb@sentry.io/1212848"
    os.environ["FUSE_LIBRARY_PATH"] = "%programfiles(x86)%\\WinFsp\bin\\winfsp-x64.dll"
    os.makedirs(os.path.expandvars("%APPDATA%\\parsec"), exist_ok=True)
    with open(os.path.expandvars("%APPDATA%\\parsec\\parsec-core.log"), "a") as file:
        file.write("Starting parsec core")

    cli(["core", "gui", "--log-level", "INFO", "--log-file", "%APPDATA%\\parsec\\parsec-core.log"])


if __name__ == "__main__":
    parsec()
