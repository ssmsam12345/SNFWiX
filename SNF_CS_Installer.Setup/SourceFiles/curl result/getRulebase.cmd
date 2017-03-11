@ECHO OFF
SETLOCAL 


REM ----- Edit This Section --------

SET SNIFFER_PATH=D:\SNFNEW~1
SET AUTHENTICATION=setuptestingonly
SET LICENSE_ID=testmode

REM --------------------------------

CD /d %SNIFFER_PATH%

echo Running SNF getRulebase.cmd > getRulebase.txt

if not exist UpdateReady.txt echo No UpdateReady.txt >> getRulebase.txt
if not exist UpdateReady.txt goto DONE

REM The next line may cause trouble if your system stops while this
REM script is running. It is not needed when this script is run
REM from SNF's <update-script/> feature since only one copy will run
REM at a time. However, if you are going to run a version of this
REM script as a scheduled task you will want to uncomment the next
REM line to make sure only one copy runs at a time-- just be sure to
REM clean out any stale .lck files after a restart.

REM if exist UpdateReady.lck echo getRulebase.cmd locked/running >> getRulebase.txt
REM if exist UpdateReady.lck goto DONE

:DOWNLOAD
 
copy UpdateReady.txt UpdateReady.lck > nul

if exist %LICENSE_ID%.new del %LICENSE_ID%.new

echo.

curl -v "http://www.sortmonster.net/Sniffer/Updates/%LICENSE_ID%.snf" -o %LICENSE_ID%.new -S -R -z %LICENSE_ID%.snf -H "Accept-Encoding:gzip" --compressed -u sniffer:ki11sp8m 2>> getRulebase.txt

if %ERRORLEVEL% NEQ 0 del %LICENSE_ID%.new 2> nul
if not exist %LICENSE_ID%.new echo New rulebase file NOT downloaded >> getRulebase.txt
if not exist %LICENSE_ID%.new goto CLEANUP

snf2check.exe %LICENSE_ID%.new %AUTHENTICATION% 2>> getRulebase.txt

if errorlevel 1 goto CLEANUP

echo New rulebase file tested OK >> getRulebase.txt

if exist %LICENSE_ID%.old del %LICENSE_ID%.old
if exist %LICENSE_ID%.snf rename %LICENSE_ID%.snf %LICENSE_ID%.old
rename %LICENSE_ID%.new %LICENSE_ID%.snf

if exist UpdateReady.txt del UpdateReady.txt
if exist UpdateReady.lck del UpdateReady.lck

:CLEANUP

if exist %LICENSE_ID%.new del %LICENSE_ID%.new
if exist UpdateReady.lck del UpdateReady.lck 

:DONE

echo Done >> getRulebase.txt

REM This is a good place to add a line that will email getrulebase.txt to
REM yourself so that you know what just happened.

ENDLOCAL
