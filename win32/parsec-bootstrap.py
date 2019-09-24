# Parsec Cloud (https://parsec.cloud) Copyright (c) AGPLv3 2019 Scille SAS

import os
import sys
import traceback


def parsec():
    os.environ["SENTRY_URL"] = "https://863e60bbef39406896d2b7a5dbd491bb@sentry.io/1212848"
    os.environ["FUSE_LIBRARY_PATH"] = "%programfiles(x86)%\\WinFsp\bin\\winfsp-x64.dll"
    os.makedirs(os.path.expandvars("%APPDATA%\\parsec"), exist_ok=True)
    log_file = os.path.expandvars("%APPDATA%\\parsec\\parsec-core.log")

    sys.path.append('lib/site-packages')
    from parsec.cli import cli
    cli(["core", "gui", "--log-level", "INFO", "--log-file", log_file])


if __name__ == "__main__":
    parsec()
