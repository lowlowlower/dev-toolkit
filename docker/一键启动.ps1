# ====================================
# Docker Supabase Auto Setup
# ====================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Docker Supabase Auto Setup" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Docker
Write-Host "[1/4] Checking Docker..." -ForegroundColor Green
try {
    docker info | Out-Null
    Write-Host "  OK - Docker is running" -ForegroundColor Green
} catch {
    Write-Host "  ERROR - Docker is not running" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please start Docker Desktop first" -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host ""

# Check Images
Write-Host "[2/4] Checking Supabase images..." -ForegroundColor Green
$images = @(
    "supabase/postgres:15.1.0.147",
    "supabase/studio:20240103-4c8b3c4",
    "kong:2.8.1",
    "supabase/gotrue:v2.99.0",
    "postgrest/postgrest:v11.2.0",
    "supabase/storage-api:v1.8.0"
)

$missingImages = @()
foreach ($image in $images) {
    $exists = docker images -q $image
    if (-not $exists) {
        $missingImages += $image
    }
}

if ($missingImages.Count -gt 0) {
    Write-Host "  Need to pull $($missingImages.Count) images" -ForegroundColor Yellow
    Write-Host ""
    
    $choice = Read-Host "Pull images now? This may take several minutes (y/n)"
    if ($choice -eq "y" -or $choice -eq "Y") {
        Write-Host ""
        Write-Host "Pulling images..." -ForegroundColor Green
        foreach ($image in $missingImages) {
            Write-Host "  Pulling $image ..." -ForegroundColor Cyan
            docker pull $image | Out-Null
        }
        Write-Host "  OK - Images pulled" -ForegroundColor Green
    } else {
        Write-Host "Please run: .\install.ps1 first" -ForegroundColor Yellow
        pause
        exit 0
    }
} else {
    Write-Host "  OK - All images ready" -ForegroundColor Green
}

Write-Host ""

# Start Services
Write-Host "[3/4] Starting Supabase services..." -ForegroundColor Green

$running = docker ps --filter "name=supabase-db" --format "{{.Names}}"
if ($running) {
    Write-Host "  INFO - Services already running" -ForegroundColor Yellow
} else {
    Write-Host "  Starting containers..." -ForegroundColor Cyan
    docker-compose up -d | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  OK - Containers started" -ForegroundColor Green
        
        Write-Host "  Waiting for database..." -ForegroundColor Cyan
        $maxAttempts = 30
        $attempt = 0
        $ready = $false
        
        while ($attempt -lt $maxAttempts -and -not $ready) {
            $attempt++
            $healthCheck = docker exec supabase-db pg_isready -U postgres 2>&1
            if ($LASTEXITCODE -eq 0) {
                $ready = $true
                Write-Host "  OK - Database ready" -ForegroundColor Green
            } else {
                Start-Sleep -Seconds 2
            }
        }
        
        if (-not $ready) {
            Write-Host "  ERROR - Database timeout" -ForegroundColor Red
            pause
            exit 1
        }
    } else {
        Write-Host "  ERROR - Failed to start containers" -ForegroundColor Red
        pause
        exit 1
    }
}

Write-Host ""

# Initialize Database
Write-Host "[4/4] Initializing database..." -ForegroundColor Green

$tableCheck = "SELECT COUNT(*) FROM information_schema.tables WHERE table_name = 'business_cards';" | docker exec -i supabase-db psql -U postgres -d postgres -t 2>&1

if ($tableCheck -match '^\s*1\s*$') {
    Write-Host "  INFO - Database already initialized" -ForegroundColor Yellow
    Write-Host ""
    $choice = Read-Host "Reinitialize? This will clear existing data (y/n)"
    
    if ($choice -ne "y" -and $choice -ne "Y") {
        Write-Host "  Skipping initialization" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host "  Services Ready!" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Access URLs:" -ForegroundColor Yellow
        Write-Host "  - Admin UI: http://localhost:54323" -ForegroundColor Cyan
        Write-Host "  - API Gateway: http://localhost:54324" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Yellow
        Write-Host "  cd .." -ForegroundColor White
        Write-Host "  npm run dev" -ForegroundColor White
        Write-Host ""
        pause
        exit 0
    }
}

Write-Host "  Running init script..." -ForegroundColor Cyan
$sqlFile = "..\supabase\init.sql"

if (-not (Test-Path $sqlFile)) {
    Write-Host "  ERROR - Cannot find init.sql" -ForegroundColor Red
    pause
    exit 1
}

Get-Content $sqlFile | docker exec -i supabase-db psql -U postgres -d postgres | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "  OK - Database initialized" -ForegroundColor Green
} else {
    Write-Host "  ERROR - Initialization failed" -ForegroundColor Red
    pause
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  All Done!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Service Info:" -ForegroundColor Yellow
Write-Host "  - Admin UI: http://localhost:54323" -ForegroundColor Cyan
Write-Host "  - API Gateway: http://localhost:54324" -ForegroundColor Cyan
Write-Host "  - Database: localhost:54322" -ForegroundColor Cyan
Write-Host ""
Write-Host "Initial Data:" -ForegroundColor Yellow
Write-Host "  - 20 business cards" -ForegroundColor White
Write-Host "  - 5 workflow templates" -ForegroundColor White
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Go back to root: cd .." -ForegroundColor White
Write-Host "  2. Start frontend: npm run dev" -ForegroundColor White
Write-Host "  3. Open browser: http://localhost:5173" -ForegroundColor White
Write-Host ""
Write-Host "Tips:" -ForegroundColor Yellow
Write-Host "  - Check status: .\status.ps1" -ForegroundColor White
Write-Host "  - View logs: .\logs.ps1" -ForegroundColor White
Write-Host "  - Stop service: .\stop.ps1" -ForegroundColor White
Write-Host ""

pause
