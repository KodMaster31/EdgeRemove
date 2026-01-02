#repo 
$RepoUrl = "https://raw.githubusercontent.com/KodMaster31/EdgeRemove/main/EdgeSilici.ps1"
$LocalPath = "C:\EdgeSilici.ps1"

Write-Host "EdgeRemove Kurulumu Başlıyor..." -ForegroundColor Cyan

# 1. Ana scripti GitHub'dan çek ve C:'ye kaydet
try {
    Invoke-RestMethod -Uri $RepoUrl -OutFile $LocalPath
    Write-Host "[OK] Temizlik scripti C:\ dizinine kaydedildi." -ForegroundColor Green
} catch {
    Write-Host "[HATA] Script indirilemedi!" -ForegroundColor Red; exit
}

# 2. Planlanmış Görevi Oluştur
Unregister-ScheduledTask -TaskName "EdgeKalicisiz" -Confirm:$false -ErrorAction SilentlyContinue
$action = New-ScheduledTaskAction -Execute 'PowerShell.exe' `
  -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$LocalPath`""
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

Register-ScheduledTask -TaskName "EdgeKalicisiz" -Action $action -Trigger $trigger -Principal $principal
Write-Host "[OK] Her açılışta temizlik görevi tanımlandı!" -ForegroundColor Green
