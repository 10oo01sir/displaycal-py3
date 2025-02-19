#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# 方案1
# import win32api
# import win32con
# import win32event
# import win32process
#
#
# def run_elevated(script):
#     shell_flags = win32process.STARTF_USESHOWWINDOW | win32con.SW_HIDE
#     process_flags = win32con.CREATE_NEW_CONSOLE | win32con.CREATE_NEW_PROCESS_GROUP
#
#     lpApplicationName = 'python'
#     lpCommandLine = 'python {}'.format(script)
#
#     win32api.ShellExecute(lpApplicationName=lpApplicationName,
#                             lpCommandLine=lpCommandLine,
#                             lpVerb='runas',
#                             nShow=win32con.SW_NORMAL,
#                             fMask=shell_flags)
#
#
# run_elevated('DisplayCAL/main.py')

# 方案2
# import subprocess
#
# command = 'runas /user:Administrator python DisplayCAL/main.py'
# subprocess.call(command, shell=True)

# 方案3
# ! /usr/bin/env python3
import ctypes
import enum
import sys


# Reference:
# msdn.microsoft.com/en-us/library/windows/desktop/bb762153(v=vs.85).aspx


class SW(enum.IntEnum):
    HIDE = 0
    MAXIMIZE = 3
    MINIMIZE = 6
    RESTORE = 9
    SHOW = 5
    SHOWDEFAULT = 10
    SHOWMAXIMIZED = 3
    SHOWMINIMIZED = 2
    SHOWMINNOACTIVE = 7
    SHOWNA = 8
    SHOWNOACTIVATE = 4
    SHOWNORMAL = 1


class ERROR(enum.IntEnum):
    ZERO = 0
    FILE_NOT_FOUND = 2
    PATH_NOT_FOUND = 3
    BAD_FORMAT = 11
    ACCESS_DENIED = 5
    ASSOC_INCOMPLETE = 27
    DDE_BUSY = 30
    DDE_FAIL = 29
    DDE_TIMEOUT = 28
    DLL_NOT_FOUND = 32
    NO_ASSOC = 31
    OOM = 8
    SHARE = 26


def bootstrap():
    if ctypes.windll.shell32.IsUserAnAdmin():
        main()
    else:
        hinstance = ctypes.windll.shell32.ShellExecuteW(
            None, 'runas', sys.executable, sys.argv[0], None, SW.SHOWNORMAL
        )
        if hinstance <= 32:
            raise RuntimeError(ERROR(hinstance))


def main():
    from DisplayCAL.main import main as display_main
    display_main()
    # print(input('Echo: '))


if __name__ == '__main__':
    bootstrap()
