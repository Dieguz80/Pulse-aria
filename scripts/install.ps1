# Pulse-Aria Windows installer script
# Pattern: 2-step (this is the "run" part; user already downloaded this file)
# What this script does:
#   1. Downloads the latest Pulse-Aria installer (.exe NSIS) from GitHub Releases
#   2. Verifies the file was actually downloaded
#   3. Launches the installer
# Manual alternative: https://github.com/Dieguz80/Pulse-aria/releases/latest

$ErrorActionPreference = 'Stop'

$RELEASE_URL = 'https://github.com/Dieguz80/Pulse-aria/releases/latest/download/pulse-aria-windows.exe'
$TEMP_FILE = Join-Path $env:TEMP 'pulse-aria-installer.exe'

Write-Host ""
Write-Host "  Pulse-Aria - Windows Installer" -ForegroundColor Cyan
Write-Host "  ==============================" -ForegroundColor Cyan
Write-Host ""

# Pre-flight: PowerShell version check
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Host "[X] PowerShell 5+ required. Current version: $($PSVersionTable.PSVersion)" -ForegroundColor Red
    exit 1
}

# Pre-flight: TLS 1.2 (older Windows)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Step 1: Download
Write-Host "[1/3] Downloading latest installer..." -ForegroundColor Yellow
Write-Host "      From: $RELEASE_URL"
Write-Host "      To:   $TEMP_FILE"
Write-Host ""

try {
    Invoke-WebRequest -Uri $RELEASE_URL -OutFile $TEMP_FILE -UseBasicParsing
}
catch {
    Write-Host ""
    Write-Host "[X] Download failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "    Manual download:" -ForegroundColor Yellow
    Write-Host "    https://github.com/Dieguz80/Pulse-aria/releases/latest"
    exit 1
}

# Step 2: Verify
Write-Host "[2/3] Verifying download..." -ForegroundColor Yellow
if (-not (Test-Path $TEMP_FILE)) {
    Write-Host "[X] File not found after download." -ForegroundColor Red
    exit 1
}

$fileSize = (Get-Item $TEMP_FILE).Length / 1MB
$fileSizeRounded = [math]::Round($fileSize, 2)
Write-Host "      Size: $fileSizeRounded MB"

if ($fileSize -lt 1) {
    Write-Host "[X] Downloaded file too small ($fileSizeRounded MB). Likely a redirect error." -ForegroundColor Red
    Remove-Item $TEMP_FILE -Force
    exit 1
}

Write-Host ""
Write-Host "      SHA256:" -ForegroundColor DarkGray
$hash = Get-FileHash $TEMP_FILE -Algorithm SHA256
Write-Host "      $($hash.Hash)" -ForegroundColor DarkGray
Write-Host ""
Write-Host "      Compare with the SHA256 in the release notes:" -ForegroundColor DarkGray
Write-Host "      https://github.com/Dieguz80/Pulse-aria/releases/latest" -ForegroundColor DarkGray
Write-Host ""

# Step 3: Launch installer
Write-Host "[3/3] Launching installer..." -ForegroundColor Yellow
Write-Host ""
Write-Host "      Note: Windows SmartScreen may show a warning because the app" -ForegroundColor DarkYellow
Write-Host "      is not yet signed with an EV certificate (coming in v0.6)." -ForegroundColor DarkYellow
Write-Host "      Click 'More info' -> 'Run anyway' to proceed." -ForegroundColor DarkYellow
Write-Host ""

Start-Process -FilePath $TEMP_FILE -Wait

Write-Host ""
Write-Host "[OK] Installation complete." -ForegroundColor Green
Write-Host ""
Write-Host "     Launch Pulse-Aria from the Start menu and follow the onboarding."
Write-Host ""
