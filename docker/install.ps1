# ====================================
# Docker Supabase Installation Script
# ====================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Docker Supabase Installer" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is installed
Write-Host "Step 1/4: Checking Docker installation..." -ForegroundColor Green
try {
    $dockerVersion = docker --version
    Write-Host "OK - Docker installed: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR - Docker not found" -ForegroundColor Red
    Write-Host "Please install Docker Desktop first" -ForegroundColor Yellow
    Write-Host "Download: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    pause
    exit 1
}

# Check if Docker is running
Write-Host ""
Write-Host "Step 2/4: Checking Docker status..." -ForegroundColor Green
try {
    docker info | Out-Null
    Write-Host "OK - Docker is running" -ForegroundColor Green
} catch {
    Write-Host "ERROR - Docker is not running" -ForegroundColor Red
    Write-Host "Please start Docker Desktop and try again" -ForegroundColor Yellow
    pause
    exit 1
}

# Pull images
Write-Host ""
Write-Host "Step 3/4: Pulling Supabase images..." -ForegroundColor Green
Write-Host "This may take several minutes, please wait..." -ForegroundColor Yellow
Write-Host ""

$images = @(
    "supabase/postgres:15.1.0.147",
    "supabase/studio:20240103-4c8b3c4",
    "kong:2.8.1",
    "supabase/gotrue:v2.99.0",
    "postgrest/postgrest:v11.2.0",
    "supabase/storage-api:v1.8.0"
)

$total = $images.Count
$current = 0

foreach ($image in $images) {
    $current++
    Write-Host "[$current/$total] Pulling $image ..." -ForegroundColor Cyan
    docker pull $image
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Done" -ForegroundColor Green
    } else {
        Write-Host "  Failed" -ForegroundColor Red
    }
    Write-Host ""
}

# Create network
Write-Host ""
Write-Host "Step 4/4: Creating Docker network..." -ForegroundColor Green
try {
    docker network create supabase-network 2>$null
    Write-Host "OK - Network created" -ForegroundColor Green
} catch {
    Write-Host "INFO - Network may already exist, continuing..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Start services: .\start.ps1" -ForegroundColor White
Write-Host "  2. Initialize DB: .\init-db.ps1" -ForegroundColor White
Write-Host "  3. Open admin UI: http://localhost:54323" -ForegroundColor White
Write-Host ""

pause
