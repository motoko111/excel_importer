@echo off
cd /d %~dp0
rem バッチパス
set BATCH_PATH=%cd%
cd /d ../
rem Pythonソース本体のパス
set EXCEL2CSV_BATCH_PATH=%cd%\excel2csv\excel2csv.bat
cd /d ../../
rem プロジェクトのルートパス
set PROJECT_ROOT_PATH=%cd%
rem リソースのルートパス
set PROJECT_RESOURCE_PATH=%PROJECT_ROOT_PATH%_resource
set INPUT_PATH=%PROJECT_RESOURCE_PATH%\input
set OUTPUT_PATH=%PROJECT_RESOURCE_PATH%\output

if "%~1"=="" (
	echo default_INPUT_PATH=%INPUT_PATH%
) else (
	set INPUT_PATH=%1
)

if "%~2"=="" (
	echo default_OUTPUT_PATH=%OUTPUT_PATH%
) else (
	set OUTPUT_PATH=%2
)

echo INPUT_PATH=%INPUT_PATH%
echo OUTPUT_PATH=%OUTPUT_PATH%
call %EXCEL2CSV_BATCH_PATH% %INPUT_PATH% %OUTPUT_PATH%
