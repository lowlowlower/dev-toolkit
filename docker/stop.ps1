# ====================================
# Docker Supabase Stop Script
# ====================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Stop Docker Supabase Services" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Container Status
Write-Host "Checking running containers..." -ForegroundColor Green
$running = docker ps --filter "name=supabase" --format "{{.Names}}"

if (-not $running) {
    Write-Host "⚠️  没有运行中的 Supabase 容器" -ForegroundColor Yellow
    Write-Host ""
    pause
    exit 0
}

Write-Host "找到运行中的容器:" -ForegroundColor Green
$running -split "`n" | ForEach-Object { Write-Host "  - $_" -ForegroundColor White }
Write-Host ""

# 询问是否保留数据
Write-Host "停止选项:" -ForegroundColor Yellow
Write-Host "  1. 仅停止容器（保留数据）" -ForegroundColor White
Write-Host "  2. 停止并删除容器（保留数据卷）" -ForegroundColor White
Write-Host "  3. 完全清理（删除容器和数据）⚠️" -ForegroundColor Red
Write-Host ""

$choice = Read-Host "请选择 (1/2/3)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "停止容器..." -ForegroundColor Yellow
        docker-compose stop
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ 容器已停止" -ForegroundColor Green
            Write-Host "数据已保留，下次启动将恢复" -ForegroundColor White
        }
    }
    
    "2" {
        Write-Host ""
        Write-Host "停止并删除容器..." -ForegroundColor Yellow
        docker-compose down
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ 容器已删除" -ForegroundColor Green
            Write-Host "数据卷已保留，下次启动将恢复数据" -ForegroundColor White
        }
    }
    
    "3" {
        Write-Host ""
        Write-Host "⚠️  警告: 此操作将删除所有数据！" -ForegroundColor Red
        $confirm = Read-Host "确认删除所有数据？(yes/no)"
        
        if ($confirm -eq "yes") {
            Write-Host ""
            Write-Host "完全清理中..." -ForegroundColor Yellow
            docker-compose down -v
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ 已完全清理" -ForegroundColor Green
                Write-Host "所有容器和数据已删除" -ForegroundColor White
            }
        } else {
            Write-Host "操作已取消" -ForegroundColor Yellow
        }
    }
    
    default {
        Write-Host "无效选择" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "提示:" -ForegroundColor Yellow
Write-Host "  重新启动: .\docker\start.ps1" -ForegroundColor White
Write-Host "  查看状态: docker ps -a" -ForegroundColor White
Write-Host ""

pause

