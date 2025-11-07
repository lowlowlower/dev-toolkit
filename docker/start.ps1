# ====================================
# Docker Supabase Start Script
# ====================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Start Docker Supabase Services" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Docker Status
Write-Host "Checking Docker status..." -ForegroundColor Green
try {
    docker info | Out-Null
    Write-Host "OK - Docker is running" -ForegroundColor Green
} catch {
    Write-Host "ERROR - Docker is not running, please start Docker Desktop" -ForegroundColor Red
    pause
    exit 1
}

# 检查是否已有容器在运行
Write-Host ""
Write-Host "检查现有容器..." -ForegroundColor Green
$running = docker ps --filter "name=supabase-db" --format "{{.Names}}"

if ($running) {
    Write-Host "⚠️  Supabase 容器已在运行" -ForegroundColor Yellow
    Write-Host ""
    $choice = Read-Host "是否重启服务？(y/n)"
    if ($choice -eq "y" -or $choice -eq "Y") {
        Write-Host "停止现有服务..." -ForegroundColor Yellow
        docker-compose down
        Write-Host "✅ 服务已停止" -ForegroundColor Green
    } else {
        Write-Host "保持现有服务运行" -ForegroundColor Green
        Write-Host ""
        Write-Host "服务访问地址:" -ForegroundColor Yellow
        Write-Host "  - 数据库: localhost:54322" -ForegroundColor Cyan
        Write-Host "  - API网关: http://localhost:54324" -ForegroundColor Cyan
        Write-Host "  - 管理界面: http://localhost:54323" -ForegroundColor Cyan
        Write-Host ""
        pause
        exit 0
    }
}

# 启动服务
Write-Host ""
Write-Host "启动 Supabase 服务..." -ForegroundColor Green
Write-Host "这可能需要 30-60 秒，请稍候..." -ForegroundColor Yellow
Write-Host ""

docker-compose up -d

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Supabase 服务启动成功！" -ForegroundColor Green
    Write-Host ""
    
    # 等待数据库准备就绪
    Write-Host "等待数据库准备就绪..." -ForegroundColor Yellow
    $maxAttempts = 30
    $attempt = 0
    $ready = $false
    
    while ($attempt -lt $maxAttempts -and -not $ready) {
        $attempt++
        Write-Host "  尝试连接 ($attempt/$maxAttempts)..." -ForegroundColor Gray
        
        $healthCheck = docker exec supabase-db pg_isready -U postgres 2>&1
        if ($LASTEXITCODE -eq 0) {
            $ready = $true
            Write-Host "  ✓ 数据库已就绪！" -ForegroundColor Green
        } else {
            Start-Sleep -Seconds 2
        }
    }
    
    if (-not $ready) {
        Write-Host "⚠️  数据库启动超时，请手动检查" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  📊 服务信息" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "数据库 (PostgreSQL):" -ForegroundColor Green
    Write-Host "  地址: localhost:54322" -ForegroundColor White
    Write-Host "  用户: postgres" -ForegroundColor White
    Write-Host ""
    Write-Host "API 网关 (Kong):" -ForegroundColor Green
    Write-Host "  地址: http://localhost:54324" -ForegroundColor White
    Write-Host ""
    Write-Host "管理界面 (Studio):" -ForegroundColor Green
    Write-Host "  地址: http://localhost:54323" -ForegroundColor White
    Write-Host ""
    Write-Host "其他服务:" -ForegroundColor Green
    Write-Host "  Auth: http://localhost:54325" -ForegroundColor White
    Write-Host "  REST: http://localhost:54326" -ForegroundColor White
    Write-Host "  Storage: http://localhost:54327" -ForegroundColor White
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "下一步操作:" -ForegroundColor Yellow
    Write-Host "  1. 初始化数据库: .\docker\init-db.ps1" -ForegroundColor White
    Write-Host "  2. 查看日志: .\docker\logs.ps1" -ForegroundColor White
    Write-Host "  3. 停止服务: .\docker\stop.ps1" -ForegroundColor White
    Write-Host ""
    
} else {
    Write-Host "❌ 服务启动失败" -ForegroundColor Red
    Write-Host "请检查 Docker 日志: docker-compose logs" -ForegroundColor Yellow
}

pause

