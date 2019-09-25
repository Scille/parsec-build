# -*- coding: utf-8 -*-

import sys
from cx_Freeze import setup, Executable
import pkgutil


base = None
if sys.platform == "win32":
    base = "Win32GUI"


options = {
    "build_exe": {
        "packages": [
            "sentry_sdk.integrations",
            "trio._core",
        ],
        "includes": "atexit",
        "include_msvcr": True,
        # See https://github.com/anthony-tuininga/cx_Freeze/issues/504
        "include_files": "python3.dll"
    }
}


executables = [
    Executable(
        "parsec-bootstrap.py",
        base=base,
        targetName="parsec.exe",
        icon="parsec.ico"
    )
]

setup(name="parsec",
      version="1.0.0",
      description="Parsec secure cloud sharing",
      options=options,
      executables=executables
      )
