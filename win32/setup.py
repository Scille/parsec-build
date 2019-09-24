# -*- coding: utf-8 -*-

import sys
from cx_Freeze import setup, Executable
import pkgutil


base = None
if sys.platform == 'win32':
    base = 'Win32GUI'


options = {
    'build_exe': {
        "packages": [
            # "asyncio",
            # "parsec.core.gui.ui",
            # "idna",
            "sentry_sdk.integrations",
            "trio._core",
            # "nacl._sodium",
            # "html.parser",
            # "pkg_resources._vendor",
            # "swiftclient",
            # "setuptools.msvc",
            # "unittest.mock",
        ],
        # # nacl store it cffi shared lib in a very strange place...
        # "include_files": _extract_libs_cffi_backend(),

        # 'packages': ','.join(x.name for x in pkgutil.iter_modules())
        # 'includes': ','.join([x.name for x in pkgutil.walk_packages()])
        'includes': 'atexit',
        "include_msvcr": True
    }
}


executables = [
    Executable(
        'parsec-bootstrap.py',
        base=base,
        targetName="parsec.exe",
        icon='parsec.ico'
    )
]

setup(name='parsec',
      version='1.0.0',
      description='Parsec secure cloud sharing',
      options=options,
      executables=executables
      )
