NSIS installer for parsec
=========================

Inspired by (Deluge NSIS installer)[https://github.com/deluge-torrent/deluge/blob/3f9ae337932da550f2623daa6dedd9c3e0e5cfb3/packaging/win32/Win32%20README.txt]


Build steps
-----------


### 1 - Build the application

Run the `freeze_parsec.py` Python script, this will generate a `build/parsce-<version>-<platform>`
directory containing  a standalone Python interpreter along with Parsec and it depedencies.


### 2 - Package the application

Run the NSIS script with `%nsis%\makensis.exe installer.nsi`, this will generate
a `build\parsec-<version>-<platform>-setup.exe` installer.


### 3 - Sign the application

<TODO>
