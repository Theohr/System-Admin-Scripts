$Prog = "C:\daemon_crw\danaos.exe"
$Running = Get-Process prog -ErrorAction SilentlyContinue
$Start = {([wmiclass]"win32_process").Create($Prog)} 
if($Running -eq $null) # evaluating if the program is running
{& $Start} # the process is created on this line