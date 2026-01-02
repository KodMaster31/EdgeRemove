# Yönetici kontrolü
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Lütfen bu scripti Yönetici olarak çalıştırın!"
    exit
}

$ScriptPath = "C:\EdgeSilici.ps1"
$CurrentDir = Get-Location
Copy-Item -Path "$CurrentDir\EdgeSilici.ps1" -Destination $ScriptPath -Force

# Eski görevi temizle
Unregister-ScheduledTask -TaskName "EdgeKalicisiz" -Confirm:$false -ErrorAction SilentlyContinue

# Yeni görevi tanımla
$action = New-ScheduledTaskAction -Execute 'PowerShell.exe' `
  -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$ScriptPath`""
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

Register-ScheduledTask -TaskName "EdgeKalicisiz" -Action $action -Trigger $trigger -Principal $principal

Write-Host "Edge Kalici Silici Basariyla Kuruldu!" -ForegroundColor Green