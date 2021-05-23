
;--------------------------------
;General constants
!define PRODUCT_NAME "Principia"
!define PRODUCT_VERSION "1.5.2 Build 0"

;--------------------------------
;Include Modern UI

!include "MUI2.nsh"

;--------------------------------
;General

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${PRODUCT_NAME}_${PRODUCT_VERSION}_Setup.exe"
Unicode True

BrandingText "Principia!"

InstallDir "$PROGRAMFILES\Principia"

InstallDirRegKey HKCU "Software\Bithack\Principia" ""

RequestExecutionLevel user

;--------------------------------
;Interface Settings

!define MUI_ABORTWARNING

!define MUI_WELCOMEPAGE_TEXT "Setup will guide you through the installation of ${PRODUCT_NAME} ${PRODUCT_VERSION}.$\r$\n$\r$\nPrincipia 1.5.2 is an unofficial update to Principia, which contains various fixes and improvements over 1.5.1."

!define MUI_FINISHPAGE_TEXT "${PRODUCT_NAME} ${PRODUCT_VERSION} has been successfully installed.$\r$\n$\r$\nClick Finish to close Setup and run Principia."

!define MUI_WELCOMEFINISHPAGE_BITMAP "welcome.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "welcome.bmp"

!define MUI_COMPONENTSPAGE_CHECKBITMAP "checks.bmp"

!define MUI_ICON "icon.ico"

!define MUI_FINISHPAGE_RUN "$INSTDIR/principia.exe"
!define MUI_FINISHPAGE_RUN_TEXT "Run Principia"

!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR/changelog.txt"
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Show the changelog"
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED true

;--------------------------------
;Pages

!insertmacro MUI_PAGE_WELCOME
;!insertmacro MUI_PAGE_LICENSE "license.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

!insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Section "Principia (Required)" SecCore
	SectionIn RO
	SetOutPath "$INSTDIR"

	File /r "files/*"

	WriteRegStr HKCU "Software\Bithack\Principia" "" $INSTDIR

	WriteUninstaller "$INSTDIR\uninst-principia.exe"
SectionEnd

;--------------------------------
;Descriptions

LangString DESC_SecCore ${LANG_ENGLISH} "Principia."

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SecCore} $(DESC_SecCore)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section "Uninstall"
	;ADD YOUR OWN FILES HERE...

	Delete "$INSTDIR\Uninstall.exe"

	RMDir "$INSTDIR"

	DeleteRegKey /ifempty HKCU "Software\Bithack\Principia"
SectionEnd
