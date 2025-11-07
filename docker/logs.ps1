# ====================================
# 查看 Docker Supabase 日志
# ====================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  📋 Supabase 服务日志" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "选择要查看的服务:" -ForegroundColor Yellow
Write-Host "  1. 所有服务" -ForegroundColor White
Write-Host "  2. 数据库 (PostgreSQL)" -ForegroundColor White
Write-Host "  3. API网关 (Kong)" -ForegroundColor White
Write-Host "  4. 管理界面 (Studio)" -ForegroundColor White
Write-Host "  5. 认证服务 (Auth)" -ForegroundColor White
Write-Host "  6. REST API" -ForegroundColor White
Write-Host "  7. 存储服务 (Storage)" -ForegroundColor White
Write-Host ""

$choice = Read-Host "请选择 (1-7)"

Write-Host ""
Write-Host "按 Ctrl+C 退出日志查看" -ForegroundColor Yellow
Write-Host ""
Start-Sleep -Seconds 2

switch ($choice) {
    "1" {
        Write-Host "查看所有服务日志..." -ForegroundColor Green
        docker-compose logs -f
    }
    "2" {
        Write-Host "查看数据库日志..." -ForegroundColor Green
        docker logs -f supabase-db
    }
    "3" {
        Write-Host "查看 Kong 日志..." -ForegroundColor Green
        docker logs -f supabase-kong
    }
    "4" {
        Write-Host "查看 Studio 日志..." -ForegroundColor Green
        docker logs -f supabase-studio
    }
    "5" {
        Write-Host "查看 Auth 日志..." -ForegroundColor Green
        docker logs -f supabase-auth
    }
    "6" {
        Write-Host "查看 REST API 日志..." -ForegroundColor Green
        docker logs -f supabase-rest
    }
    "7" {
        Write-Host "查看 Storage 日志..." -ForegroundColor Green
        docker logs -f supabase-storage
    }
    default {
        Write-Host "无效选择" -ForegroundColor Red
    }
}


