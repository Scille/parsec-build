# Greatly inspired by Deluge NSIS installer
# https://github.com/deluge-torrent/deluge/blob/develop/packaging/win32/Win32%20README.txt

!addplugindir nsis_plugins
!addincludedir nsis_plugins
!include "nsProcess.nsh"

# Script version; displayed when running the installer
!define PARSEC_INSTALLER_VERSION "1.0"

# Parsec program information
!define PROGRAM_NAME "Parsec"
!define PROGRAM_WEB_SITE "http://parsec.cloud"

# Detect version from file
!define BUILD_DIR "build"
!searchparse /file ${BUILD_DIR}/BUILD.tmp `target = "` PARSEC_FREEZE_BUILD_DIR `"`
!ifndef PARSEC_FREEZE_BUILD_DIR
   !error "Cannot find freeze build directory"
!endif
!searchparse /file ${BUILD_DIR}/BUILD.tmp `parsec_version = "` PROGRAM_VERSION `"`
!ifndef PROGRAM_VERSION
   !error "Program Version Undefined"
!endif
!searchparse /file ${BUILD_DIR}/BUILD.tmp `platform = "` PROGRAM_PLATFORM `"`
!ifndef PROGRAM_PLATFORM
   !error "Program Platform Undefined"
!endif

# Python files generated
!define LICENSE_FILEPATH "${PARSEC_FREEZE_BUILD_DIR}\LICENSE.txt"
!define INSTALLER_FILENAME "parsec-${PROGRAM_VERSION}-${PROGRAM_PLATFORM}-setup.exe"

!define WINFSP_INSTALLER "winfsp-1.4.19049.msi"

# Set default compressor
SetCompressor /FINAL /SOLID lzma
SetCompressorDictSize 64

# --- Interface settings ---
# Modern User Interface 2
!include MUI2.nsh
# Installer
!define MUI_ICON "parsec.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "installer-top.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "installer-side.bmp"
!define MUI_COMPONENTSPAGE_SMALLDESC
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_ABORTWARNING
# Start Menu Folder Page Configuration
!define MUI_STARTMENUPAGE_DEFAULTFOLDER ${PROGRAM_NAME}
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCR"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\Parsec"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
# Uninstaller
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!define MUI_HEADERIMAGE_UNBITMAP "installer-top.bmp"
!define MUI_WELCOMEFINISHPAGE_UNBITMAP "installer-side.bmp"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE

!define MUI_FINISHPAGE_SHOWREADME ""
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Create Desktop Shortcut"
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION finishpageaction

# --- Start of Modern User Interface ---
Var StartMenuFolder
# Welcome, License & Components pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE ${LICENSE_FILEPATH}
!insertmacro MUI_PAGE_COMPONENTS
# Let the user select the installation directory
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder
# Run installation
!insertmacro MUI_PAGE_INSTFILES
# Popup Message if VC Redist missing
# Page Custom VCRedistMessage
# Display 'finished' page
!insertmacro MUI_PAGE_FINISH
# Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES
# Language files
!insertmacro MUI_LANGUAGE "English"


# --- Functions ---

# Check for running Parsec instance.
Function .onInit

  ${nsProcess::FindProcess} "parsec.exe" $R0
  IntCmp $R0 1 0 0 notRunning
    MessageBox MB_OK|MB_ICONEXCLAMATION "Parsec is running. Please close it first!" /SD IDOK
    Abort

  notRunning: 
    ReadRegStr $R0 HKLM \
    "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROGRAM_NAME}" \
    "UninstallString"
    StrCmp $R0 "" done
 
    MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION \
    "${PROGRAM_NAME} is already installed. $\n$\nClick `OK` to remove the \
    previous version or `Cancel` to cancel this upgrade." \
    /SD IDOK IDOK uninst
    Abort

    ;Run the uninstaller
    uninst:
      ClearErrors
      IfSilent +3
      Exec $R0
      Goto +2
      Exec "$R0 /S"
    done:

FunctionEnd

Function un.onUninstSuccess
    HideWindow
    MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer." /SD IDOK
FunctionEnd

Function un.onInit
    MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Do you want to completely remove $(^Name)?" /SD IDYES IDYES +2
    Abort
FunctionEnd

Function finishpageaction
    CreateShortCut "$DESKTOP\Parsec.lnk" "$INSTDIR\parsec.exe"
FunctionEnd

# # Test if Visual Studio Redistributables 2008 SP1 installed and returns -1 if none installed
# Function CheckVCRedist2008
#     Push $R0
#     ClearErrors
#     ReadRegDword $R0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{FF66E9F6-83E7-3A3E-AF14-8DE9A809A6A4}" "Version"
#     IfErrors 0 +2
#         StrCpy $R0 "-1"
# 
#     Push $R1
#     ClearErrors
#     ReadRegDword $R1 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{9BE518E6-ECC6-35A9-88E4-87755C07200F}" "Version"
#     IfErrors 0 VSRedistInstalled
#         StrCpy $R1 "-1"
# 
#     StrCmp $R0 "-1" +3 0
#         Exch $R0
#         Goto VSRedistInstalled
#     StrCmp $R1 "-1" +3 0
#         Exch $R1
#         Goto VSRedistInstalled
#     # else
#         Push "-1"
#     VSRedistInstalled:
# FunctionEnd
# 
# Function VCRedistMessage
#     Call CheckVCRedist2008
#     Pop $R0
#     StrCmp $R0 "-1" 0 end
#     MessageBox MB_YESNO|MB_ICONEXCLAMATION "Parsec requires an MSVC package to run \
#     but the recommended package does not appear to be installed:$\r$\n$\r$\n\
#     Microsoft Visual C++ 2008 SP1 Redistributable Package (x86)$\r$\n$\r$\n\
#     Would you like to download it now?" /SD IDNO IDYES clickyes
#     Goto end
#     clickyes:
#         ExecShell open "https://www.microsoft.com/en-us/download/details.aspx?id=26368"
#     end:
# FunctionEnd

# --- Installation sections ---
!define PROGRAM_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROGRAM_NAME}"
!define PROGRAM_UNINST_ROOT_KEY "HKLM"
!define PROGRAM_UNINST_FILENAME "$INSTDIR\parsec-uninst.exe"

BrandingText "${PROGRAM_NAME} Windows Installer v${PARSEC_INSTALLER_VERSION}"
Name "${PROGRAM_NAME} ${PROGRAM_VERSION}"
OutFile "${BUILD_DIR}\${INSTALLER_FILENAME}"
InstallDir "$PROGRAMFILES\Parsec"

ShowInstDetails show
ShowUnInstDetails show

# Install main application
Section "Parsec Secure Cloud Sharing" Section1
    SectionIn RO
    !include "${BUILD_DIR}\install_files.nsh"

    SetOverwrite ifnewer
    SetOutPath "$INSTDIR"
    WriteIniStr "$INSTDIR\homepage.url" "InternetShortcut" "URL" "${PROGRAM_WEB_SITE}"

    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
        SetShellVarContext all
        CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
        CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Parsec.lnk" "$INSTDIR\parsec.exe"
        CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Website.lnk" "$INSTDIR\homepage.url"
        CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Uninstall Parsec.lnk" ${PROGRAM_UNINST_FILENAME}
    !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section "WinFSP" Section2
    SetOutPath "$TEMP"
    File ${WINFSP_INSTALLER}
    ExecWait "msiexec /i ${WINFSP_INSTALLER}"
    Delete ${WINFSP_INSTALLER}
SectionEnd

# Create parsec:// uri association.
Section "Associate parsec:// URI links with Parsec" Section3
    DeleteRegKey HKCR "Parsec"
    WriteRegStr HKCR "Parsec" "" "URL:Parsec Protocol"
    WriteRegStr HKCR "Parsec" "URL Protocol" ""
    WriteRegStr HKCR "Parsec\shell\open\command" "" '"$INSTDIR\parsec.exe" "%1"'
SectionEnd

LangString DESC_Section1 ${LANG_ENGLISH} "Install Parsec."
LangString DESC_Section2 ${LANG_ENGLISH} "Install WinFSP."
LangString DESC_Section3 ${LANG_ENGLISH} "Let Parsec handle parsec:// URI links from the web-browser."

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${Section1} $(DESC_Section1)
    !insertmacro MUI_DESCRIPTION_TEXT ${Section2} $(DESC_Section2)
    !insertmacro MUI_DESCRIPTION_TEXT ${Section3} $(DESC_Section3)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

# Create uninstaller.
Section -Uninstaller
    WriteUninstaller ${PROGRAM_UNINST_FILENAME}
    WriteRegStr ${PROGRAM_UNINST_ROOT_KEY} "${PROGRAM_UNINST_KEY}" "DisplayName" "$(^Name)"
    WriteRegStr ${PROGRAM_UNINST_ROOT_KEY} "${PROGRAM_UNINST_KEY}" "UninstallString" ${PROGRAM_UNINST_FILENAME}
SectionEnd

# --- Uninstallation section ---
Section Uninstall
    # Delete Parsec files.
    Delete "$INSTDIR\homepage.url"
    Delete ${PROGRAM_UNINST_FILENAME}
    !include "${BUILD_DIR}\uninstall_files.nsh"
    RmDir "$INSTDIR"

    # Delete Start Menu items.
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder
        SetShellVarContext all
        Delete "$SMPROGRAMS\$StartMenuFolder\Parsec.lnk"
        Delete "$SMPROGRAMS\$StartMenuFolder\Uninstall Parsec.lnk"
        Delete "$SMPROGRAMS\$StartMenuFolder\Parsec Website.lnk"
        RmDir "$SMPROGRAMS\$StartMenuFolder"
        DeleteRegKey /ifempty HKCR "Software\Parsec"

    Delete "$DESKTOP\Parsec.lnk"

    # Delete registry keys.
    DeleteRegKey ${PROGRAM_UNINST_ROOT_KEY} "${PROGRAM_UNINST_KEY}"
    # This key is only used by Parsec, so we should always delete it
    DeleteRegKey HKCR "Parsec"
SectionEnd

# Add version info to installer properties.
VIProductVersion "${PARSEC_INSTALLER_VERSION}.0.0"
VIAddVersionKey ProductName ${PROGRAM_NAME}
VIAddVersionKey Comments "Parsec secure cloud sharing"
VIAddVersionKey CompanyName "Scille SAS"
VIAddVersionKey LegalCopyright "Scille SAS"
VIAddVersionKey FileDescription "${PROGRAM_NAME} Application Installer"
VIAddVersionKey FileVersion "${PARSEC_INSTALLER_VERSION}.0.0"
VIAddVersionKey ProductVersion "${PROGRAM_VERSION}.0"
VIAddVersionKey OriginalFilename ${INSTALLER_FILENAME}
