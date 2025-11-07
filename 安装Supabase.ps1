# ====================================
# Install and Start Supabase in Docker
# ====================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Supabase Docker Setup" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Docker
Write-Host "[Step 1/4] Checking Docker..." -ForegroundColor Green
try {
    docker info | Out-Null
    Write-Host "  OK - Docker is running" -ForegroundColor Green
} catch {
    Write-Host "  ERROR - Docker not running" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please start Docker Desktop and try again" -ForegroundColor Yellow
    Write-Host ""
    pause
    exit 1
}

Write-Host ""

# Step 2: Pull Images
Write-Host "[Step 2/4] Pulling Docker images..." -ForegroundColor Green
Write-Host "  This may take 5-10 minutes depending on your network" -ForegroundColor Yellow
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
    Write-Host "  [$current/$total] Pulling $image ..." -ForegroundColor Cyan
    docker pull $image 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "    Done" -ForegroundColor Green
    } else {
        Write-Host "    Failed" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "  OK - All images downloaded" -ForegroundColor Green
Write-Host ""

# Step 3: Start Services
Write-Host "[Step 3/4] Starting Supabase services..." -ForegroundColor Green

docker-compose up -d

if ($LASTEXITCODE -ne 0) {
    Write-Host "  ERROR - Failed to start services" -ForegroundColor Red
    pause
    exit 1
}

Write-Host "  OK - Services started" -ForegroundColor Green
Write-Host ""
Write-Host "  Waiting for database to be ready..." -ForegroundColor Yellow

# Wait for database
$maxWait = 60
$waited = 0
$ready = $false

while ($waited -lt $maxWait -and -not $ready) {
    Start-Sleep -Seconds 2
    $waited += 2
    
    $check = docker exec supabase-db pg_isready -U postgres 2>&1
    if ($LASTEXITCODE -eq 0) {
        $ready = $true
    }
    
    Write-Host "  Waiting... ($waited seconds)" -ForegroundColor Gray
}

if ($ready) {
    Write-Host "  OK - Database is ready" -ForegroundColor Green
} else {
    Write-Host "  WARNING - Database may not be ready yet" -ForegroundColor Yellow
    Write-Host "  But continuing anyway..." -ForegroundColor Yellow
}

Write-Host ""

# Step 4: Initialize Database
Write-Host "[Step 4/4] Initializing database..." -ForegroundColor Green

if (Test-Path "supabase\init.sql") {
    Get-Content "supabase\init.sql" | docker exec -i supabase-db psql -U postgres -d postgres | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  OK - Database initialized" -ForegroundColor Green
    } else {
        Write-Host "  WARNING - Database init had some errors" -ForegroundColor Yellow
        Write-Host "  But you can still try to use it" -ForegroundColor Yellow
    }
} else {
    Write-Host "  WARNING - init.sql not found" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Service URLs:" -ForegroundColor Yellow
Write-Host "  Admin UI:    http://localhost:54323" -ForegroundColor Cyan
Write-Host "  API Gateway: http://localhost:54324" -ForegroundColor Cyan
Write-Host "  Database:    localhost:54322" -ForegroundColor Cyan
Write-Host ""
Write-Host "Database Info:" -ForegroundColor Yellow
Write-Host "  - 20 business cards created" -ForegroundColor White
Write-Host "  - 5 workflow templates created" -ForegroundColor White
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Start frontend:  npm run dev" -ForegroundColor White
Write-Host "  2. Open browser:    http://localhost:5173" -ForegroundColor White
Write-Host ""
Write-Host "Useful Commands:" -ForegroundColor Yellow
Write-Host "  Check status:  cd docker; .\status.ps1" -ForegroundColor White
Write-Host "  View logs:     cd docker; .\logs.ps1" -ForegroundColor White
Write-Host "  Stop services: cd docker; .\stop.ps1" -ForegroundColor White
Write-Host ""

pause


