@echo off
chcp 1252 >nul 


set toriVersion=v1.0

title TORI %toriVersion% von DasMonschta 

set fileName=%~n0
set amongusDir=.
set "steamDir=C:\Program Files (x86)\Steam\steamapps\common\AmongUs"
set "epicgamesDir=C:\Program Files\Epic Games\AmongUs"


:Start	
	:CheckUpdate
		if exist tori_temp (
		  @RD /S /Q tori_temp 
		)
		mkdir tori_temp
		curl.exe -s --output tori_temp\latest.txt --url https://raw.githubusercontent.com/DasMonschta/tori/main/latest.txt
		for /f "tokens=1*delims=:" %%G in ('findstr /n "^" tori_temp\latest.txt') do if %%G equ 1 set newToriVersion=%%H
		for /f "tokens=1*delims=:" %%G in ('findstr /n "^" tori_temp\latest.txt') do if %%G equ 2 set newToriDownload=%%H
		for /f "tokens=1*delims=:" %%G in ('findstr /n "^" tori_temp\latest.txt') do if %%G equ 3 set newToriName=%%H
		@RD /S /Q tori_temp 
		
		if not %newToriVersion% == %toriVersion% (
			echo %newToriDownload%
			curl.exe -sLOJ --url %newToriDownload%
			%newToriName%
			(goto) 2>nul & del "%~f0"
		)
	echo --------------------------------------------------------------------------------
	echo --------------------------------------------------------------------------------	 
	echo.
	echo.                         The Other Roles Installer %toriVersion%
	echo.                                von DasMonschta
	echo.
	echo -------------------------------------------------------------------------------- 
	echo -------------------------------------------------------------------------------- 
	echo.
	echo.     Wetten du schaffst es nicht 3 Salzstangen in der Zeit zu essen, die dieses
	echo.     Programm braucht um die Mod bequem für dich zu installieren? Also...
	echo.     Bist du bereit?
	echo.
	echo.  1. Ja
	echo.  2. Nein
	echo.
	choice /C 12 /M "Wähle einen Menüpunkt:"
	echo.
	if errorlevel 2 goto StartDeclined
	if errorlevel 1 goto StartAccepted

:StartDeclined
	echo -------------------------------------------------------------------------------- 
	echo.
	echo.     Manno. Ich dachte wir haben ein kleines Duell.
	echo.     Naja, vielleicht beim nächsten Mal! :)
	echo.
	pause
	goto End

:StartAccepted
	for /f "tokens=2*" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Valve\Steam" /v InstallPath 2^>^&1^|find "REG_"') do @set steam=%%b
	if exist "Among Us.exe" (
		goto MainMenü
    ) else (
		if exist "%steamDir%" (
			set launcher=Steam
			set "amongusDir=%steamDir%"
			goto InstallationFound
		) else (
			if exist "%steam%\steamapps\common\AmongUs" (
				set launcher=Steam
				set "amongusDir=%steam%\steamapps\common\AmongUs"
				goto InstallationFound
			) else (
				if exist "%epicgamesDir%" (
					set launcher=EpicGames
					set "amongusDir=%epicgamesDir%"
					goto InstallationFound
				) else (
					goto NothingFound
				)				
			)
		)
	)	
	
	:InstallationFound
		echo -------------------------------------------------------------------------------- 
		echo.
		echo.     Yay, es wurde eine Among Us Installation von %launcher% gefunden.
		echo.     Pfad: %amongusDir%
		echo.
		echo.     Soll The Other Roles für diese Among Us Version installiert bzw.
		echo.     gelöscht werden?
		echo.
		echo.  1. Ja
		echo.  2. Nein
		echo.
		choice /C 12 /M "Wähle einen Menüpunkt:"
		echo.
		if errorlevel 2 goto DifferentFolder
		if errorlevel 1 goto MainMenü

	:DifferentFolder
		echo -------------------------------------------------------------------------------- 
		echo.
		echo.     Du hast Among Us an einem besondern Ort installiert?
		goto CopyInfo
		
	:NothingFound
		echo -------------------------------------------------------------------------------- 
		echo.
		echo.     Oh no, es wurde leider keine Among Us Installation auf deinem PC gefunden.
		echo.     Hast du Among Us vielleicht an einem besondern Ort installiert?
		goto CopyInfo
		
	:CopyInfo
		echo.
		echo.     Kopiere diese Datei (%fileName%.bat) einfach in den Among Us
		echo.     Installations Ordner wo auch die "Among Us.exe" ist und starte diese Datei
		echo.     von dort aus nochmal. Dann wird es klappen! 
		echo.
		pause
		goto End

	:MainMenü
		if exist tori_temp (
		  @RD /S /Q tori_temp 
		)
		mkdir tori_temp

		echo -------------------------------------------------------------------------------- 
		echo.
		echo.                                 HAUPTMENÜ
		echo.
		echo.  1. The Other Roles installieren/updaten
		echo.
		echo.  2. Aktuelle bzw. alte Mod löschen
		echo.     INFO: Funktioniert nur wenn die Mod nicht im Hauptordner installiert wurde.
		echo.
		echo.  3. Discord beitreten
		echo.     INFO: Bei Fragen oder Problemen bin ich hier schnell erreichbar.
		echo.
		echo.  4. Github Projekt aufrufen
		echo.
		echo.  5. Programm beenden
		echo.     INFO: Beendet dieses Meisterwerk der Programmierkunst.
		echo.
		choice /C 12345 /M "Wähle einen Menüpunkt:"
		echo.
		if errorlevel 5 goto End
		if errorlevel 4 goto Github
		if errorlevel 3 goto Discord
		if errorlevel 2 goto Delete
		if errorlevel 1 goto ChooseDownload	
				
	:ChooseDownload
		echo.     Suche nach den neusten Versionen...
		echo.
		rem Get main json
		curl.exe -s --output tori_temp\github.json --url https://api.github.com/repos/eisbison/theotherroles/releases
		rem Get Assets List Links for every release and safe to releases.txt
		Powershell -Nop -C "(Get-Content tori_temp\github.json|ConvertFrom-Json).assets.browser_download_url" >tori_temp\releases.txt
		Powershell -Nop -C "(Get-Content tori_temp\github.json|ConvertFrom-Json).tag_name" >tori_temp\tags.txt

		findstr /V .dll tori_temp\releases.txt  > tori_temp\outfile.txt
		
		echo ----------------------------------------------------------------------
		echo.
		echo.     Welche Version soll installiert werden?
		echo.
		setlocal enableextensions enabledelayedexpansion
		set /a x=1
		for /f "tokens=*" %%A in (tori_temp\tags.txt) do (
			if !x!==1 (echo.  !x!. %%A - Neuste Version) else echo.  !x!. %%A
			set /a x+=1
			if !x!==10 goto Bla
		)
		endlocal
		:Bla
		echo.
		choice /C 123456789 /M "Wähle einen Menüpunkt:"
		
		for /f "tokens=1*delims=:" %%G in ('findstr /n "^" tori_temp\outfile.txt') do if %%G equ %errorlevel% set download=%%H
		for /f "tokens=1*delims=:" %%G in ('findstr /n "^" tori_temp\tags.txt') do if %%G equ %errorlevel% set version=%%H

		echo -------------------------------------------------------------------------------- 
		echo.
		echo.                               INSTALLATIONSMENÜ
		echo.
		echo.     Du wirst jetzt Version %version% installieren.
		echo.
		echo.     Achtung!
		echo.     Solltest du Among Us über EpicGames installiert haben, so funktioniert die 
		echo.     Installation nur mit Punkt 1 aus dem Menü unter diesem Text.
		echo.
		echo.  1. Mod in den Hauptordner installieren/updaten
		echo.     (persönlich Empfehlung)
		echo.     INFO: So kann die Mod bequem über Steam, EpicGames usw. gestartet werden.
		echo.
		echo.  2. Mod in einen extra Ordner installieren/updaten
		echo.     INFO: Das originale Spiel bleibt hierbei unberührt.
		echo.
		echo.  3. Abbrechen
		echo.
		choice /C 123 /M "Wähle einen Menüpunkt:"
		echo.
		if errorlevel 3 goto End
		if errorlevel 2 goto External
		if errorlevel 1 goto Internal		
	
	:Internal	
		echo.     Lade Mod herunter...
		echo.
		rem Unzips Mod in the main installation path
		curl.exe -s --output tori_temp\mod.zip --url %download% -O -J -L
		echo.     Installiere Mod...
		echo.
		tar -xf tori_temp\mod.zip -C "%amongusDir%\ "
		goto InstallationFinished	
		
	:External
		rem Creates a copy of the main installation and unzips the mod
		if exist "%amongusDir%\THE_OTHER_ROLES" (
		  @RD /S /Q "%amongusDir%\THE_OTHER_ROLES"  
		)
		mkdir "%amongusDir%\THE_OTHER_ROLES"
		echo.     Kopiere Among Us...
		echo.
		robocopy "%amongusDir%\ " "%amongusDir%\THE_OTHER_ROLES\ " *.* /XF %fileName%.bat /XD THE_OTHER_ROLES tori_temp "The Other Roles" /S /NFL /NDL /NJH /NJS /NC /NS /NP >nul
		echo.     Lade Mod herunter...
		echo.		
		curl.exe -s --output tori_temp\mod.zip --url %download% -O -J -L
		echo.     Installiere Mod...
		echo.
		tar -xf tori_temp\mod.zip -C "%amongusDir%\THE_OTHER_ROLES\ "

		echo ----------------------------------------------------------------------
		echo.
		echo.     Soll eine Verknüpfung auf dem Desktop erstellt werden?
		echo.
		echo.  1. Ja
		echo.  2. Nein
		echo.
		choice /C 12 /M "Wähle einen Menüpunkt:"
		echo.
		if errorlevel 2 goto SkipLink
		if errorlevel 1 goto CreateLink

		:CreateLink
			rem Create link to Desktop
			set "linkTitle=The Other Roles"
			set "progdir=%~dp0"
			
			echo %progdir%
			
			if not "%amongusDir%" == "." (
				set "progdir=%amongusDir%\"				
			)
			
			set "progexe=Among Us.exe"
			set "description=Startet Among Us mit The Other Roles"
			echo Set objShell=WScript.CreateObject("Wscript.Shell")>tori_temp\link.vbs
			echo Set objShortcut=objShell.CreateShortcut("%userprofile%\Desktop\%linkTitle%.lnk")>>tori_temp\link.vbs
			echo objShortcut.TargetPath="%progdir%THE_OTHER_ROLES\%progexe%">>tori_temp\link.vbs
			echo objShortcut.Description="%description%">>tori_temp\link.vbs
			echo objShortcut.WorkingDirectory="%progdir%THE_OTHER_ROLES\">>tori_temp\link.vbs
			echo objShortcut.Save>>tori_temp\link.vbs
			cscript //nologo tori_temp\link.vbs

		:SkipLink
			goto InstallationFinished	

	:Delete
		echo -------------------------------------------------------------------------------- 
		echo.
		if exist "%amongusDir%\THE_OTHER_ROLES" (
		  @RD /S /Q "%amongusDir%\THE_OTHER_ROLES"  
			echo.     The Other Roles wurde erfolgreich gelöscht!
		) else (
			echo.     Mod wurde in den Hauptordner installiert oder existiert nicht. 
			echo.
			echo.     Wenn du The Other Roles aus deinem Hauptordner löschen willst, musst 
			echo.     du das komplette Spiel deinstallieren und neu installieren.
		)
		echo.
		pause
		goto End

	:Discord
		start "" https://discord.com/invite/WyftjVMsT3
		goto End
	:Github
		start "" https://github.com/DasMonschta/tori
		goto End

	:InstallationFinished
		echo -------------------------------------------------------------------------------- 
		echo.
		echo.     Jabadabaduuuuuuuuuuuu! (Stell dir hier ein virtuelles Feuerwerk vor)
		echo.
		echo.     Die Installation von The Other Roles war bombastisch erfolgreich!
		echo.
		pause
	
:End
	@RD /S /Q tori_temp