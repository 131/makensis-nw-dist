; Installer Source for NSIS 3.0 or higher

;Enable Unicode encoding
Unicode True

;Include Modern UI
!include "MUI2.nsh"

;General Settings
Name "$%PACKAGE_NAME_WITH_SYMBOL%"
Caption "$%PACKAGE_NAME_WITH_SYMBOL% v$%PACKAGE_VERSION%"
BrandingText "$%PACKAGE_NAME_WITH_SYMBOL% v$%PACKAGE_VERSION%"
VIAddVersionKey "ProductName" "$%PACKAGE_NAME_WITH_SYMBOL%"
VIAddVersionKey "ProductVersion" "$%PACKAGE_VERSION%"
VIAddVersionKey "FileDescription" "$%PACKAGE_NAME_WITH_SYMBOL% $%PACKAGE_VERSION% Installer"
VIAddVersionKey "FileVersion" "$%PACKAGE_VERSION%"
VIAddVersionKey "CompanyName" "$%COMPANY_NAME%"
VIAddVersionKey "LegalCopyright" "$%APP_URL%"
VIProductVersion "$%PACKAGE_VERSION_CLEAN%"
OutFile "$%OUTFILE%"
CRCCheck on
;SetCompressor /SOLID lzma

;Default installation folder
InstallDir "$LOCALAPPDATA\$%PACKAGE_NAME%"

;Request application privileges
RequestExecutionLevel user

;Define UI settings
!define MUI_ICON "$%MUI_ICON%"
!define MUI_UNICON "$%MUI_ICON%"
!define MUI_UI_HEADERIMAGE_RIGHT "$%MUI_UI_HEADERIMAGE_RIGHT%"
!define MUI_WELCOMEFINISHPAGE_BITMAP "$%MUI_WELCOMEFINISHPAGE_BITMAP%"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "$%MUI_WELCOMEFINISHPAGE_BITMAP%"
!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_LINK "$%APP_URL%"
!define MUI_FINISHPAGE_LINK_LOCATION "$%APP_URL%"
!define MUI_FINISHPAGE_RUN "$INSTDIR\nw.exe"
!define MUI_FINISHPAGE_RUN_PARAMETERS ""

;Define the pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "$%MUI_PAGE_LICENSE%"
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

;Define uninstall pages
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

Section ; Node Webkit Files

    ;Delete existing install
    RMDir /r "$INSTDIR\App"

    ;Set output path to InstallDir
    SetOutPath "$INSTDIR\App\node-webkit"


    File /nonfatal /r /x pdf.dll /x package.json "$%ROOT_PATH%\node-webkit\*"

SectionEnd

Section ; App Files

    ;Set output path to InstallDir
    SetOutPath "$INSTDIR\App\app"

    File /r /x *.git "$%ROOT_PATH%\app\*"
    File "/oname=app.ico" "$%MUI_ICON%"



SectionEnd

Section ; Others Files

    SetOutPath "$INSTDIR"

    File /r "$%ROOT_PATH%\overlay\*"

    ; use _config.json as default config if non present
    IfFileExists $INSTDIR\config.json +2 0
      Rename $INSTDIR\config.json.default $INSTDIR\config.json

    ;Create uninstaller
    WriteUninstaller "$INSTDIR\App\Uninstall.exe"

SectionEnd

Section ; Shortcuts

    CreateShortCut "$INSTDIR\$%PACKAGE_NAME%.lnk" "$INSTDIR\nw.exe" "" "$INSTDIR\App\app\app.ico" "" "" "" "$%PACKAGE_NAME%"

    ;Start Menu Shortcut
    RMDir /r "$SMPROGRAMS\$%PACKAGE_NAME%"
    CreateDirectory "$SMPROGRAMS\$%PACKAGE_NAME%"
    CreateShortCut "$SMPROGRAMS\$%PACKAGE_NAME%\$%PACKAGE_NAME%.lnk" "$INSTDIR\nw.exe" "" "$INSTDIR\App\app\app.ico" "" "" "" "$%PACKAGE_NAME%"
    CreateShortCut "$SMPROGRAMS\$%PACKAGE_NAME%\Uninstall $%PACKAGE_NAME%.lnk" "$INSTDIR\App\Uninstall.exe" "" "$INSTDIR\App\app\app.ico" "" "" "" "Uninstall $%PACKAGE_NAME%"

    ;Desktop Shortcut
    Delete "$DESKTOP\$%PACKAGE_NAME%.lnk"
    CreateShortCut "$DESKTOP\$%PACKAGE_NAME%.lnk" "$INSTDIR\nw.exe" "" "$INSTDIR\App\app\app.ico" "" "" "" "$%PACKAGE_NAME% $%PACKAGE_VERSION%"

SectionEnd

; Uninstaller
Section "uninstall"

    RMDir /r "$INSTDIR"
    RMDir /r "$SMPROGRAMS\$%PACKAGE_NAME%"
    Delete "$DESKTOP\$%PACKAGE_NAME%.lnk"

    NoUninstallData:

SectionEnd
