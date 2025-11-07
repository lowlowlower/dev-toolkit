# Simple Supabase Docker Installer
# Run this script to install and start everything

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  Supabase Docker Installer" -ForegroundColor Yellow
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Check Docker
Write-Host "Checking Docker..." -ForegroundColor Green
docker info 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker is not running!" -ForegroundColor Red
    Write-Host "Please start Docker Desktop first." -ForegroundColor Yellow
    Write-Host ""
    pause
    exit 1
}
Write-Host "OK - Docker is running" -ForegroundColor Green
Write-Host ""

# Pull images
Write-Host "Pulling Docker images (this may take 5-10 minutes)..." -ForegroundColor Green
Write-Host ""

docker pull supabase/postgres:15.1.0.147
docker pull supabase/studio:20240103-4c8b3c4
docker pull kong:2.8.1
docker pull supabase/gotrue:v2.99.0
docker pull postgrest/postgrest:v11.2.0
docker pull supabase/storage-api:v1.8.0

Write-Host ""
Write-Host "Starting services..." -ForegroundColor Green
docker-compose up -d

Write-Host ""
Write-Host "Waiting for database (30 seconds)..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

Write-Host ""
Write-Host "Initializing database..." -ForegroundColor Green
Get-Content "supabase\init.sql" | docker exec -i supabase-db psql -U postgres -d postgres

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Services running at:" -ForegroundColor Yellow
Write-Host "  Admin UI:  http://localhost:54323" -ForegroundColor Cyan
Write-Host "  API:       http://localhost:54324" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next step:" -ForegroundColor Yellow
Write-Host "  npm run dev" -ForegroundColor White
Write-Host ""
pause


