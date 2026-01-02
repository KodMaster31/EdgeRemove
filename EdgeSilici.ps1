# Hedef dizinler
$TargetPaths = @(
    "${env:ProgramFiles(x86)}\Microsoft\Edge\Application",
    "${env:ProgramFiles(x86)}\Microsoft\EdgeUpdate",
    "C:\ProgramData\Microsoft\EdgeUpdate"
)

# Süreçleri sonlandır (Daha kapsamlı durdurma)
$KillList = @("msedge", "MicrosoftEdgeUpdate", "edgeupdate", "edgeupdatem")
foreach ($proc in $KillList) {
    Stop-Process -Name $proc -Force -ErrorAction SilentlyContinue
}

foreach ($Path in $TargetPaths) {
    if (Test-Path $Path) {
        Write-Host "Temizleniyor: $Path" -ForegroundColor Yellow
        
        # 1. Sahipliği Al (Recursive)
        takeown /f "$Path" /r /d Y /a

        # 2. İzinleri Ver (Administrators grubuna tam yetki)
        icacls "$Path" /grant *S-1-5-32-544:F /t /c /l /q

        # 3. Salt-okunur ve Sistem niteliklerini temizle
        Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
            if ($_.Attributes -match "ReadOnly" -or $_.Attributes -match "System") {
                $_.Attributes = 'Normal'
            }
        }

        # 4. Silme İşlemi (Hata ayıklama için try-catch eklendi)
        try {
            Remove-Item -Path $Path -Recurse -Force -ErrorAction Stop
            Write-Host "Başarıyla silindi: $Path" -ForegroundColor Green
        } catch {
            Write-Host "Silinemedi (Dosya kullanımda olabilir): $Path" -ForegroundColor Red
        }
    }
}
