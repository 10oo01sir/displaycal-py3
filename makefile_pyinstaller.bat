@echo off

@REM D:
@REM cd D:\project\Github\displaycal-py3
@REM conda activate Conda311

set input_value=%1
echo %input_value%
if /i "%input_value%" equ "build" (
call:buid_displaycal
exit /b 0
)

pause

:buid_displaycal
echo =======build displaycal=======
rd /S /Q build\
rd /S /Q temp\
if not exist build\ mkdir build\
if not exist temp\ mkdir temp\
robocopy DisplayCAL\lang temp\lang /E /njh /njs /ndl /nc /ns /MIR /XN
robocopy DisplayCAL\lib64 temp\lib64 /E /njh /njs /ndl /nc /ns /MIR /XN
robocopy DisplayCAL\presets temp\presets /E /njh /njs /ndl /nc /ns /MIR /XN
robocopy DisplayCAL\ref temp\ref /E /njh /njs /ndl /nc /ns /MIR /XN
robocopy DisplayCAL\report temp\report /E /njh /njs /ndl /nc /ns /MIR /XN
robocopy DisplayCAL\theme temp\theme /E /njh /njs /ndl /nc /ns /MIR /XN
robocopy DisplayCAL\ti1 temp\ti1 /E /njh /njs /ndl /nc /ns /MIR /XN
robocopy DisplayCAL\x3d-viewer temp\x3d-viewer /E /njh /njs /ndl /nc /ns /MIR /XN
robocopy DisplayCAL\xrc temp\xrc /E /njh /njs /ndl /nc /ns /MIR /XN

robocopy scripts\ temp\scripts /E /njh /njs /ndl /nc /ns /MIR /XN
robocopy screenshots\ temp\screenshots /E /njh /njs /ndl /nc /ns /MIR /XN
robocopy tests\ temp\tests /E /njh /njs /ndl /nc /ns /MIR /XN

xcopy DisplayCAL\*.wav temp\ /y
xcopy DisplayCAL\*.pem temp\ /y
xcopy DisplayCAL\*.fx temp\ /y
xcopy DisplayCAL\*.cal temp\ /y
xcopy DisplayCAL\*.ids temp\ /y

xcopy README*.html temp\ /y
xcopy LICENSE.txt temp\ /y
xcopy *.icns temp\ /y
xcopy CHANGES.html temp\ /y

@REM pyinstaller -Fw --clean --noconfirm --uac-admin -i DisplayCAL\theme\icons\DisplayCAL.ico run_as_admin_win.py --add-data ./temp:DisplayCAL -n DisplayCAL
pyinstaller -D --clean --noconfirm --uac-admin -i DisplayCAL\theme\icons\DisplayCAL.ico run_as_admin_win.py --add-data ./temp:DisplayCAL --add-data ./venv/Scripts:python -n DisplayCAL

rd /S /Q temp\

goto:eof
