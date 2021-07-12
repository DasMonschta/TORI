@echo off

rem Encoding
chcp 1252 >nul

rem Get latest Version and safe
curl.exe -s --output latest.txt --url http://161.97.117.51/tori/latest.txt 
set /p latest=<latest.txt 
del latest.txt

rem Variables
set current=2.7.2
set msg_wrongInstallation=Du hast die Datei nicht im Among Us Installationsordner ausgeführt! Kopiere die TORI_v%current%.bat in deinen Among Us Installationsordner und probiere es erneut.
set msg_newInstaller=Der neue TORI Installer wurde herunter geladen. Starte nun TORI_v%latest%.bat
set msg_deleteSuccess=Die Mod wurde erfolgreich gelöscht!
set msg_deleteFailed=Mod wurde in den Hauptordner installiert oder existiert nicht. Wenn du die Mod aus deinem Hauptornder löschen willst, musst du das komplette Spiel deinstallieren und neu installieren.
set msg_installationSuccess=Die Installation war erfolgreich!

rem Check if installed correctly
if not exist "Among Us.exe" (
	echo msgbox"%msg_wrongInstallation%",vbInformation , "INFO" > msg.vbs 
	msg.vbs
	goto End
) 

rem Check if current version is the latest
if not %latest% == %current% (	
	curl.exe -s --output TORI_v%latest%.bat --url http://161.97.117.51/tori/TORI_v%latest%.bat
	echo msgbox"%msg_newInstaller%",vbInformation , "INFO" > msg.vbs 
	msg.vbs
	rem deletes itself
	(goto) 2>nul & del "%~f0"
) 


echo ----------------------------------------------------------------------
echo ----------------------------------------------------------------------	 
echo.
echo.                      The Other Roles Installer
echo.
echo.                           von DasMonschta
echo.
echo.                          für Version %current%
echo.
echo ----------------------------------------------------------------------	 
echo ----------------------------------------------------------------------	 
echo.
echo.                               MENÜ
echo.
echo ----------------------------------------------------------------------
echo 1. Mod in einen extra Ordner installieren/updaten
echo.   INFO: Das originale Spiel bleibt hierbei unberührt.
echo 2. Mod in den Hauptordner installieren/updaten
echo.   INFO: So kann die Mod bequem über Steam, EpicGames usw. gestartet werden.
echo 3. Aktuelle bzw. alte Mod löschen
echo.   INFO: Funktioniert nur wenn die Mod nicht im Hauptordner installiert wurde.
echo 4. Programm beenden
echo.   INFO: Beendet dieses Meisterwerk der Programmierkunst.
echo ----------------------------------------------------------------------
echo.
choice /C 1234 /M "Wähle einen Menüpunkt:"

if errorlevel 4 goto End
if errorlevel 3 goto Delete
if errorlevel 2 goto Internal
if errorlevel 1 goto External

:Delete
rem Deletes the whole THE_OTHER_ROLES folder
if exist THE_OTHER_ROLES\ (
	@RD /S /Q THE_OTHER_ROLES
	echo msgbox"%msg_deleteSuccess%",vbInformation , "INFO"> msg.vbs 	
) else (
	echo msgbox"%msg_deleteFailed%",vbInformation , "INFO"> msg.vbs 
)
msg.vbs 
goto End

:Internal
rem Unzips Mod in the main installation path
curl.exe -s --output download.zip --url https://github.com/Eisbison/TheOtherRoles/releases/download/v2.7.2/TheOtherRoles.2.7.2-Pre.zip -O -J -L
tar -xf .\download.zip -C .\
del download.zip
echo msgbox"%msg_installationSuccess%",vbInformation , "INFO"> msg.vbs 
msg.vbs 
goto End

:External
rem Creates a copy of the main installation and unzips the mod
if exist THE_OTHER_ROLES\ (
  @RD /S /Q THE_OTHER_ROLES
)
mkdir THE_OTHER_ROLES
robocopy .\ .\THE_OTHER_ROLES *.* /XF TORI_v2.7.2.bat /XD THE_OTHER_ROLES /S /NFL /NDL /NJH /NJS /NC /NS /NP >nul
curl.exe -s --output THE_OTHER_ROLES\download.zip --url https://github.com/Eisbison/TheOtherRoles/releases/download/v2.7.2/TheOtherRoles.2.7.2-Pre.zip -O -J -L
tar -xf .\THE_OTHER_ROLES\download.zip -C .\THE_OTHER_ROLES\ 
del .\THE_OTHER_ROLES\download.zip

echo.
echo ----------------------------------------------------------------------
echo Soll eine Verknüpfung auf dem Desktop erstellt werden?
echo 1. Ja
echo 2. Nein
echo ----------------------------------------------------------------------
echo.
choice /C 12 /M "Wähle einen Menüpunkt:"

if errorlevel 2 goto SkipLink
if errorlevel 1 goto CreateLink

:CreateLink
rem Create link to Desktop
set "destination=%userprofile%\Desktop"
set "progtitel=The Other Roles"
set "progdir=%~dp0"
set "progexe=Among Us.exe"
set "description=Startet Among Us mit The Other Roles"
echo Set objShell=WScript.CreateObject("Wscript.Shell")>%temp%\MakeShortCut.vbs
echo Set objShortcut=objShell.CreateShortcut("%destination%\%progtitel%.lnk")>>%temp%\MakeShortCut.vbs
echo objShortcut.TargetPath="%progdir%THE_OTHER_ROLES\%progexe%">>%temp%\MakeShortCut.vbs
echo objShortcut.Description="%description%">>%temp%\MakeShortCut.vbs
echo objShortcut.WorkingDirectory="%progdir%THE_OTHER_ROLES\">>%temp%\MakeShortCut.vbs
echo objShortcut.Save>>%temp%\MakeShortCut.vbs
cscript //nologo %temp%\MakeShortCut.vbs
del %temp%\MakeShortCut.vbs

:SkipLink
echo msgbox"%msg_installationSuccess%",vbInformation , "INFO"> msg.vbs 
msg.vbs 
goto End

:End
del msg.vbs