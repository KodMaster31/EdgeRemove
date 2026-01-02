# Hedef dizinler
$TargetPaths = @(
    "${env:ProgramFiles(x86)}\Microsoft\Edge",
    "${env:ProgramFiles(x86)}\Microsoft\EdgeUpdate",
    "${env:ProgramFiles(x86)}\Microsoft\EdgeCore",
    "${env:ProgramData}\Microsoft\EdgeUpdate"
)

# Süreçleri durdur
$KillList = @("msedge", "msedgewebview2", "MicrosoftEdgeUpdate", "edgeupdate", "edgeupdatem")
foreach ($process in $KillList) {
    Get-Process -Name "$process*" -ErrorAction SilentlyContinue | Stop-Process -Force
}

# Sahiplik al ve zorla sil
foreach ($Path in $TargetPaths) {
    if (Test-Path $Path) {
        cmd /c "takeown /f `"$Path`" /r /d Y"
        cmd /c "icacls `"$Path`" /grant administrators:F /t /c /q"
        Remove-Item -Path $Path -Recurse -Force -ErrorAction SilentlyContinue
    }
}