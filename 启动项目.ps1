# 事业构建器 - 快速启动脚本

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   🎯 事业构建器 - 卡牌工作流系统" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查Docker是否运行
Write-Host "🔍 检查 Docker 状态..." -ForegroundColor Green
try {
    docker info | Out-Null
    Write-Host "✅ Docker 正在运行" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker 未运行，请先启动 Docker Desktop" -ForegroundColor Red
    pause
    exit 1
}

Write-Host ""
Write-Host "请选择运行模式:" -ForegroundColor Yellow
Write-Host "1. 仅前端模式 (使用模拟数据，无需 Docker Supabase)" -ForegroundColor Cyan
Write-Host "2. 完整模式 (启动 Docker Supabase + 前端)" -ForegroundColor Cyan
Write-Host ""

$choice = Read-Host "请输入选项 (1 或 2)"

if ($choice -eq "2") {
    Write-Host ""
    Write-Host "🚀 启动 Docker Supabase 服务..." -ForegroundColor Green
    
    # 检查容器是否已运行
    $running = docker ps --filter "name=supabase-db" --format "{{.Names}}"
    
    if ($running) {
        Write-Host "📦 Supabase 容器已在运行" -ForegroundColor Yellow
    } else {
        Write-Host "📦 启动 Supabase 容器..." -ForegroundColor Green
        docker-compose up -d
        
        Write-Host ""
        Write-Host "⏳ 等待数据库初始化... (30秒)" -ForegroundColor Yellow
        Start-Sleep -Seconds 30
        
        Write-Host "📊 执行数据库初始化脚本..." -ForegroundColor Green
        Get-Content "supabase\init.sql" | docker exec -i supabase-db psql -U postgres -d postgres
        
        Write-Host ""
        Write-Host "✅ Supabase 服务启动成功！" -ForegroundColor Green
        Write-Host "   - 数据库端口: http://localhost:54322" -ForegroundColor Cyan
        Write-Host "   - API 端口: http://localhost:54324" -ForegroundColor Cyan
        Write-Host "   - Studio 管理界面: http://localhost:54323" -ForegroundColor Cyan
    }
    
    Write-Host ""
    Write-Host "🌐 启动前端开发服务器..." -ForegroundColor Green
    Write-Host ""
    
    # 设置环境变量使用真实 Supabase
    $env:VITE_USE_MOCK = "false"
    $env:VITE_SUPABASE_URL = "http://localhost:54324"
    $env:VITE_SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0"
    
    npm run dev
    
} elseif ($choice -eq "1") {
    Write-Host ""
    Write-Host "📦 使用模拟数据模式（无需 Docker）" -ForegroundColor Green
    Write-Host "🌐 启动前端开发服务器..." -ForegroundColor Green
    Write-Host ""
    
    # 设置环境变量使用模拟数据
    $env:VITE_USE_MOCK = "true"
    
    npm run dev
    
} else {
    Write-Host "❌ 无效选项，请重新运行脚本" -ForegroundColor Red
    pause
    exit 1
}


