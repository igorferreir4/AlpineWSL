@ECHO OFF
SET EsteDiretorio=%~dp0
SET DiretorioMaisScript=%EsteDiretorio%PortasWSL.ps1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%DiretorioMaisScript%""' -Verb RunAs}";