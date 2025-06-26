@echo off
setlocal enabledelayedexpansion

title SPT_Switch
set "FILENAME=Fika.Core.dll"

if exist SavedData.txt (
    echo Local data detected in SavedData.txt
    timeout /t 1 >nul
    cls
    set "SPT_PATH="
    set "STATUS="

    set lineNum=0
    for /f "delims=" %%A in (SavedData.txt) do (
        set /a lineNum+=1
        if !lineNum! equ 1 set "SPT_PATH=%%A"
        if !lineNum! equ 2 set "STATUS=%%A"
    	)
) else (
	echo No local data detected
	timeout /t 1 >nul
	cls
	echo Enter the location of your SPT folder
	echo The path should look something like : "C:\SPT" unless you manually changed it during the installation
	set /p SPT_PATH=
	cls
)

if "%STATUS%"=="FAIL" (
    echo Last operation was unsuccessful, please enter the location of your SPT folder again
	echo The path should look something like : "C:\SPT" unless you manually changed it during the installation
	set /p SPT_PATH=
	cls
)

set "SPT_SUBPATH=\BepInEx\plugins"
set "FILE_MAIN=%SPT_PATH%\%FILENAME%"
set "FILE_SUB=%SPT_PATH%%SPT_SUBPATH%\%FILENAME%"

if exist "%FILE_MAIN%" (
	echo Found Fika.Core.dll in %SPT_PATH%
	echo SPT is in OFFLINE mode
	set "GAMESTATE=OFFLINE"
	echo[
	) else (
	if exist "%FILE_SUB%" (
		echo Found Fika.Core.dll in %SPT_PATH%%SPT_SUBPATH%
		echo SPT is in ONLINE mode
		set "GAMESTATE=ONLINE"
		echo[
	)
)

if not defined GAMESTATE (
	cls
	color 04
	> SavedData.txt (
	echo %SPT_PATH%
	echo FAIL
	)
	echo Could not find %FILENAME% in either %SPT_PATH% or %SPT_PATH%%SPT_SUBPATH%
	echo Check paths and try again.
	echo Your game path : %SPT_PATH%
	echo Closing...
	timeout /t 8 >nul
	exit
)

if "%GAMESTATE%"=="ONLINE" (
	echo Switch to OFFLINE mode? [y/n] Case sensitive
	set /p ANSWER=
	) else (
	echo Switch to ONLINE mode? [y/n] Case sensitive
	set /p ANSWER=
)

if "%GAMESTATE%"=="ONLINE" (
	if "%ANSWER%"=="y" (
		move "%FILE_SUB%" "%SPT_PATH%" >nul
		if %errorlevel%==0 (
			cls
			> SavedData.txt (
				echo %SPT_PATH%
				echo SUCCESS
			)
			echo SPT is now OFFLINE
			echo Closing...
		) else (
			cls
			color 04
			> SavedData.txt (
				echo %SPT_PATH%
				echo FAIL
			)	
			echo File transfer unsuccessful, check paths and try again.
			echo Your game path : %SPT_PATH%
			echo Closing...
			timeout /t 4 >nul
			exit
		)
	) else if "%ANSWER%"=="n" (
		cls
		echo Answer is NO. Closing...
		timeout /t 1 >nul
		exit
	) else (
		cls
		color 04
		echo %ANSWER% is not recognized as a correct asnwer. Closing...
		timeout /t 2 >nul
		exit
	)
) else (
	if "%ANSWER%"=="y" (
		move "%FILE_MAIN%" "%FILE_SUB%" >nul
		if %errorlevel%==0 (
			cls
			> SavedData.txt (
				echo %SPT_PATH%
				echo SUCCESS
			)
			echo SPT is now ONLINE
			echo Closing...
		) else (
			cls
			color 04
			> SavedData.txt (
			echo %SPT_PATH%
			echo FAIL
			)	
			echo File transfer unsuccessful, check paths and try again.
			echo Your game path : %SPT_PATH%
			echo Closing...
			timeout /t 4 >nul
			exit
		)
	) else if "%ANSWER%"=="n" (
		cls
		echo Answer is NO. Closing...
		timeout /t 1 >nul
		exit
	) else (
		cls
		color 04
		echo %ANSWER% is not recognized as a correct asnwer. Closing...
		timeout /t 2 >nul
		exit
	)
)
timeout /t 1 >nul
exit