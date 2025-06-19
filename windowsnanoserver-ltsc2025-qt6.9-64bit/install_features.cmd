REM FoDs such as Microsoft.NanoServer.Datacenter.WOWSupport will trigger a request for reboot.
REM For those FoDs, DISM will exit with 3010 which must be handled to prevent the batch from exiting with a non-zero status.
REM Additionally we must supply the /NoRestart argument to suppress the reboot prompt.
DISM /Online /Add-Capability /CapabilityName:Microsoft.NanoServer.Datacenter.WOWSupport /NoRestart
if errorlevel 3010 (
    echo The specified optional feature requested a reboot which was suppressed.
    exit /b 0
)
