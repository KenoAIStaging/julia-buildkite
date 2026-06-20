@echo off
rem Bridge from Inno Setup's compile-time SignTool (ISCC runs under Wine
rem on the linux publish agent) back to the host-side Azure Trusted Signing
rem signer: Wine's start.exe can launch host binaries via /unix. CODESIGN_SH
rem holds the host path of utilities/windows/codesign.sh (exported by
rem upload_julia.sh; linux environment variables are visible inside Wine).
rem
rem `start /unix` applies Windows->Unix path translation to its positional
rem arguments, which corrupts the codesign.sh host path (bash then reports it
rem as "No such file or directory"). So pass both the signer script and the
rem target file through the environment -- which Wine forwards verbatim -- and
rem let bash expand them. %1 is a Windows-style path, translated back via
rem winepath inside codesign.sh. (CI paths are space-free.)
set SIGN_TARGET=%~1
start /wait /unix /bin/bash -c "exec $CODESIGN_SH $SIGN_TARGET"
if errorlevel 1 exit /b 1
