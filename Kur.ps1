# 1. Yönetici Kontrolü
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "LÜTFEN POWERSHELL'İ YÖNETİCİ OLARAK AÇIN!" -ForegroundColor Red
    exit
}

# 2. Değişkenler
$ScriptPath = "C:\EdgeSilici.ps1"
# Eğer script internetten (irm) çalıştırılıyorsa, ana scripti GitHub'dan çekmesini sağlarız
$RepoUrl = "https://raw.githubusercontent.com/KodMaster31/EdgeRemove/main/EdgeSilici.ps1"

Write-Host "Kurulum başlatılıyor..." -ForegroundColor Cyan

# 3. Dosyayı Sisteme Yerleştir
try {
    # Önce internetten güncel sürümü indirmeyi dene
    Invoke-RestMethod -Uri $RepoUrl -OutFile $ScriptPath -ErrorAction Stop
} catch {
    # İnternet yoksa veya hata verirse yerel dizinden kopyalamayı dene
    if (Test-Path "$PSScriptRoot\EdgeSilici.ps1") {
        Copy-Item -Path "$PSScriptRoot\EdgeSilici.ps1" -Destination $ScriptPath -Force
    } else {
        Write-Host "Hata: EdgeSilici.ps1 dosyası bulunamadı!" -ForegroundColor Red; exit
    }
}

# 4. Görev Zamanlayıcı Ayarları (Eskisini temizle, yenisini kur)
Unregister-ScheduledTask -TaskName "EdgeKalicisiz" -Confirm:$false -ErrorAction SilentlyContinue

$action = New-ScheduledTaskAction -Execute 'PowerShell.exe' `
  -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$ScriptPath`""
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

Register-ScheduledTask -TaskName "EdgeKalicisiz" -Action $action -Trigger $trigger -Principal $principal

Write-Host "-------------------------------------------"
Write-Host "Edge Kalıcı Silici Başarıyla Kuruldu!" -ForegroundColor Green
Write-Host "Artık her açılışta temizlik otomatik yapılacak." -ForegroundColor White
Write-Host "-------------------------------------------"
