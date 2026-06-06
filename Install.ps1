# ============================================================
#  Vortex Pharmacy - Installer
#  Double-click to run. No Administrator needed.
# ============================================================

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$msixPath  = Join-Path $scriptDir "VortexPharmacy.msix"
$certPath  = Join-Path $scriptDir "vortex.cer"

Write-Host ""
Write-Host "  ╔═══════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║      Vortex Pharmacy Installer        ║" -ForegroundColor Cyan
Write-Host "  ╚═══════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# --- Check files exist ---
foreach ($f in @($msixPath, $certPath)) {
    if (-not (Test-Path $f)) {
        Write-Host "  [X] Missing file: $f" -ForegroundColor Red
        Write-Host "      Make sure Install.ps1, VortexPharmacy.msix and vortex.cer are in the same folder." -ForegroundColor Red
        Write-Host ""
        pause; exit 1
    }
}

# --- Step 1: Trust certificate (no admin needed, user store) ---
Write-Host "  [1/2] Installing certificate..." -ForegroundColor Green

# TrustedPeople (user) - allows sideloading without developer mode
$result1 = & certutil -user -addstore TrustedPeople $certPath 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "      Trusted People store: OK" -ForegroundColor Gray
} else {
    Write-Host "      Warning (TrustedPeople): $result1" -ForegroundColor Yellow
}

# Root CA (user) - makes installer dialog show publisher name
# Note: Windows will show a security confirmation popup - click Yes
Write-Host "      Adding to Root CA... (click Yes on the security popup)" -ForegroundColor Gray
$result2 = & certutil -user -addstore Root $certPath 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "      Root CA store: OK" -ForegroundColor Gray
} else {
    Write-Host "      Warning (Root): $result2" -ForegroundColor Yellow
}

Write-Host "      Certificate installed." -ForegroundColor Green

# --- Step 2: Install the MSIX ---
Write-Host ""
Write-Host "  [2/2] Installing Vortex Pharmacy..." -ForegroundColor Green
try {
    Add-AppxPackage -Path $msixPath -ForceApplicationShutdown
    Write-Host ""
    Write-Host "  ================================================" -ForegroundColor Green
    Write-Host "    Vortex Pharmacy installed successfully!" -ForegroundColor Green
    Write-Host "    Open it from the Start Menu." -ForegroundColor Green
    Write-Host "  ================================================" -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host "  [!] Installation failed:" -ForegroundColor Red
    Write-Host "      $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "  If already installed, uninstall first:" -ForegroundColor Yellow
    Write-Host "  Settings → Apps → Vortex Pharmacy → Uninstall" -ForegroundColor Yellow
}

Write-Host ""
pause
