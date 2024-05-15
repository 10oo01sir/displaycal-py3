@echo off

echo REM Make sure __version__.py is current
python setup.py

for /F usebackq %%a in (`python -c "import sys;print(sys.version[:4])"`) do (
    set python_version=%%a
)

for /F usebackq %%a in (`python -c "from DisplayCAL import meta;print(meta.version)"`) do (
    set version=%%a
)

REM for /F usebackq %%a in (`python -c "from meta import version_tuple;print('.'.join(str(n) for n in version_tuple[:2] + (str(version_tuple[2]) + str(version_tuple[3]), )))"`) do (
REM     set msi_version=%%a
REM )

REM echo REM Source tarball
REM if not exist dist\DisplayCAL-%version%.tar.gz if not exist dist\%version%\DisplayCAL-%version%.tar.gz (
REM     python setup.py sdist --format=gztar --use-distutils 2>&1 | tee DisplayCAL-%version%.sdist.log
REM )

REM Create openSUSE build service control files and update 0install feeds
REM python setup.py buildservice 0install --stability=stable
REM echo python setup.py buildservice --stability=stable
REM python setup.py buildservice --stability=stable

echo REM Standalone executable
if not exist dist\py2exe.win32-py%python_version%\DisplayCAL-%version% (
    python setup.py bdist_standalone inno 2>&1 | tee DisplayCAL-%version%.bdist_standalone-py%python_version%.log
    if exist codesigning\sign.cmd (
        call codesigning\sign.cmd dist\py2exe.win32-py%python_version%\DisplayCAL-%version%\*.exe
        call codesigning\sign.cmd dist\py2exe.win32-py%python_version%\DisplayCAL-%version%\lib\DisplayCAL.lib*.python*.RealDisplaySizeMM.pyd
    )
)

echo REM Standalone executable - Setup
if not exist dist\DisplayCAL-%version%-Setup.exe if not exist dist\%version%\DisplayCAL-%version%-Setup.exe (
    "C:\Program Files (x86)\Inno Setup 6\Compil32.exe" /cc dist/DisplayCAL-Setup-py2exe.win32-py%python_version%.iss
)

REM Standalone executable - ZIP
REM if not exist dist\DisplayCAL-%version%-win32.zip if not exist dist\%version%\DisplayCAL-%version%-win32.zip (
REM     pushd dist\py2exe.win32-py%python_version%
REM     zip -9 -r ..\DisplayCAL-%version%-win32.zip DisplayCAL-%version%
REM     popd
REM )

REM if "%~1"=="bdist_msi" (
REM     REM Python 2.6 MSI
REM     if not exist dist\DisplayCAL-%msi_version%.win32-py2.6.msi if not exist dist\%version%\DisplayCAL-%msi_version%.win32-py2.6.msi (
REM         C:\Python26\python.exe setup.py bdist_msi --use-distutils 2>&1 | tee DisplayCAL-%msi_version%.msi-py2.6.log
REM         C:\Python26\python.exe setup.py finalize_msi 2>&1 | tee -a DisplayCAL-%msi_version%.msi-py2.6.log
REM     )
REM
REM     REM Python 2.7 MSI
REM     if not exist dist\DisplayCAL-%msi_version%.win32-py2.7.msi if not exist dist\%version%\DisplayCAL-%msi_version%.win32-py2.7.msi (
REM         C:\Users\DBA\.conda\envs\Conda311\python.exe setup.py bdist_msi --use-distutils 2>&1 | tee DisplayCAL-%msi_version%.msi-py2.7.log
REM         C:\Users\DBA\.conda\envs\Conda311\python.exe setup.py finalize_msi 2>&1 | tee -a DisplayCAL-%msi_version%.msi-py2.7.log
REM     )
REM )

echo REM Python 3.11 Installer
if "%~1"=="bdist_wininst" (
    REM Python 2.6 Installer
    REM if not exist dist\DisplayCAL-%version%.win32-py2.6.exe if not exist dist\%version%\DisplayCAL-%version%.win32-py2.6.exe (
    REM     C:\Python26\python.exe setup.py bdist_wininst --user-access-control=auto --use-distutils 2>&1 | tee DisplayCAL-%version%.wininst-py2.6.log
    REM )

    REM Python 2.7 Installer
    REM if not exist dist\DisplayCAL-%version%.win32-py2.7.exe if not exist dist\%version%\DisplayCAL-%version%.win32-py2.7.exe (
    REM     C:\Users\DBA\.conda\envs\Conda311\python.exe setup.py bdist_wininst --user-access-control=auto --use-distutils 2>&1 | tee DisplayCAL-%version%.wininst-py2.7.log
    REM )

    REM Python 3.11 Installer
    if not exist dist\DisplayCAL-%version%.win32-py3.11.exe if not exist dist\%version%\DisplayCAL-%version%.win32-py3.11.exe (
        C:\Users\DBA\.conda\envs\Conda311\python.exe setup.py bdist_wininst --user-access-control=auto --use-distutils 2>&1 | tee DisplayCAL-%version%.wininst-py3.11.log
    )
)

REM Cleanup
python util\tidy_dist.py
