
;--------------------------------
;General constants
!define PRODUCT_NAME "Principia"
!define PRODUCT_VERSION "1.5.2 Build 1"

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

InstallDirRegKey HKCU "Software\Principia" ""

RequestExecutionLevel admin

;--------------------------------
;Interface Settings

!define MUI_ABORTWARNING
!define MUI_UNABORTWARNING

!define MUI_WELCOMEPAGE_TEXT "Setup will guide you through the installation of ${PRODUCT_NAME} ${PRODUCT_VERSION}.$\r$\n$\r$\nPrincipia 1.5.2 is an unofficial update to Principia, which contains various fixes and improvements over 1.5.1."

!define MUI_FINISHPAGE_TEXT "${PRODUCT_NAME} ${PRODUCT_VERSION} has been successfully installed.$\r$\n$\r$\nClick Finish to close Setup and run Principia."

!define MUI_WELCOMEFINISHPAGE_BITMAP "welcome.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "unwelcome.bmp"

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
;Uninstall old version if it exists

Function .onInit
	ReadRegStr $R0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "UninstallString"
	StrCmp $R0 "" done

	MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION \
	"A previous version of Principia has been installed. $\n$\nClick `OK` to remove the previous version or `Cancel` to cancel this upgrade." \
	IDOK uninst
	Abort

;Run the uninstaller
uninst:
	ClearErrors
	ExecWait '$R0 _?=$INSTDIR' ;Do not copy the uninstaller to a temp file

	IfErrors no_remove_uninstaller done

	no_remove_uninstaller:
		Abort
done:

FunctionEnd

;--------------------------------
;Installer Sections

Section "Principia (Required)" SecCore
	SectionIn RO

	; add in all the files!
	SetOutPath "$INSTDIR"
	File /r "files/*"

	CreateDirectory "$SMPROGRAMS\Principia"
	CreateShortCut "$SMPROGRAMS\Principia\Principia.lnk" "$INSTDIR\principia.exe"
	CreateShortCut "$SMPROGRAMS\Principia\Uninstall.lnk" "$INSTDIR\uninst-principia.exe"

	; Registry keys for principia:// protocol
	WriteRegStr HKCR "principia" "" URL:Principia
	WriteRegStr HKCR "principia" "URL Protocol" ""
	WriteRegStr HKCR "principia" DefaultIcon ""
	WriteRegStr HKCR "principia\shell\open\command" "" "$\"$INSTDIR\principia.exe$\" %1"

	WriteRegStr HKCU "Software\Principia" "" "$INSTDIR"
	WriteRegDWORD HKCU "Software\Principia" VersionMajor 1
	WriteRegDWORD HKCU "Software\Principia" VersionMinor 5
	WriteRegDWORD HKCU "Software\Principia" VersionBuild 2
	WriteRegDWORD HKCU "Software\Principia" VersionRevision 1

	WriteRegExpandStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Principia" "UninstallString" "$\"$INSTDIR\uninst-principia.exe$\""
	WriteRegExpandStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Principia" "InstallLocation" "$INSTDIR"

	WriteUninstaller "$INSTDIR\uninst-principia.exe"
SectionEnd

;--------------------------------
;Uninstaller Section

Section "Uninstall"
	RMDir /r "$INSTDIR"

	RMDir /r "$SMPROGRAMS\Principia"

	DeleteRegKey HKCR "principia"
	DeleteRegKey HKCU "Software\Principia"
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Principia"
SectionEnd
