@echo off

REM Executes stored procedure [SO].[sp_validate_SO_D_table], which validates the data in the SO_D table for the given survey year.
REM The ps1 script is expected to be in the same directory as this batch file.
REM We need to capture the ps return value.
REM The ps script should probably log something.

SET WORKINGDIR=c:\dev\projects\SEAN_Sea-Otters\deliverables\SO_D\import_export_scripts
CD %WORKINGDIR%
SET LOGFILE=%WORKINGDIR%\validate_SO_D_table-%date%-%time%.log

REM ps %WORKINGDIR%\validate_SO_D_table.ps1 -server inpglbafs03 -database SEAN_Staging_2017 -survey_year 2022 >>%LOGFILE%

IF %ERRORLEVEL% NEQ 0 (
	set msg = "Error occurred during validation process."
	echo %msg%
)

echo Error code = %ERRORLEVEL%
PAUSE
EXIT %ERRORLEVEL%
