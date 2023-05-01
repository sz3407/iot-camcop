@echo off
SET DELAY_TIME_DEFAULT=5
SET FILENAME=pushover.json
SET _tab_=   
::launch
echo,
echo CamCop (Windows) now running on machine:user ^<^<%ComputerName%:%USERNAME%^>^>
echo,
::check for local key file
IF NOT EXIST %FILENAME% (
    echo Pushover Keys file ^<%FILENAME%^> not found.
    echo Please refer to setup instructions for creating this file.
    echo,
    echo Press anything to quit CamCop.
    pause >nul
    EXIT
)
echo %_tab_%Launch time: %TIME%
echo %_tab_%Scan delay: %DELAY_TIME_DEFAULT%
echo,
echo Scanning...
echo,

:SCANSTART
SET CAMEVENT="null"
SET INVOKE_EVENT="InvokeLicenseManagerRequired"
SET RUNDOWN_EVENT="ServicePackageRundownNotificationImpl"
FOR /F "tokens=* USEBACKQ" %%F IN (`wevtutil qe Microsoft-Windows-Store/Operational /f:text /q:"*[EventData/Data[@Name='Function']='%INVOKE_EVENT%'] and *[System[TimeCreated[timediff(@SystemTime) <= 4000]]] or *[EventData/Data[@Name='Function']='%RUNDOWN_EVENT%'] and *[System[TimeCreated[timediff(@SystemTime) <= 4000]]]" ^| find /i "Microsoft.WindowsCamera" ^| findstr /i "invoking ServiceBeginAcquireLicenseImpl"`) DO (
SET CAMEVENT="%%F"
)
IF NOT %CAMEVENT%=="null" GOTO EVENTFOUND
:POSTEVENT
PING -n %DELAY_TIME_DEFAULT% 127.0.0.1>nul
GOTO SCANSTART

:EVENTFOUND
echo *==========*==========*==========*==========*
echo %_tab_%Camera Event Occurred: %TIME%
echo,
echo %CAMEVENT%
python camevent.py
echo *==========*==========*==========*==========*
echo,
echo Scanning...
echo,
GOTO POSTEVENT