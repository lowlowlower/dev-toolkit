# Docker 镜像加速器配置

Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "Docker 镜像加速器配置指南" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "请按照以下步骤配置镜像加速器:" -ForegroundColor Yellow
Write-Host ""
Write-Host "步骤 1: 打开 Docker Desktop" -ForegroundColor Cyan
Write-Host "   - 点击右上角的 Settings (设置图标)" -ForegroundColor White
Write-Host ""
Write-Host "步骤 2: 选择 Docker Engine" -ForegroundColor Cyan
Write-Host "   - 在左侧菜单中选择 'Docker Engine'" -ForegroundColor White
Write-Host ""
Write-Host "步骤 3: 配置镜像加速器" -ForegroundColor Cyan
Write-Host "   - 在 JSON 配置中找到或添加 'registry-mirrors' 字段" -ForegroundColor White
Write-Host "   - 使用以下配置:" -ForegroundColor White
Write-Host ""
Write-Host "{" -ForegroundColor Green
Write-Host '  "registry-mirrors": [' -ForegroundColor Green
Write-Host '    "https://docker.mirrors.ustc.edu.cn",' -ForegroundColor Yellow
Write-Host '    "https://hub-mirror.c.163.com",' -ForegroundColor Yellow
Write-Host '    "https://mirror.baidubce.com"' -ForegroundColor Yellow
Write-Host '  ]' -ForegroundColor Green
Write-Host "}" -ForegroundColor Green
Write-Host ""
Write-Host "步骤 4: 应用配置" -ForegroundColor Cyan
Write-Host "   - 点击 'Apply & Restart' 按钮" -ForegroundColor White
Write-Host "   - 等待 Docker Desktop 完全重启" -ForegroundColor White
Write-Host ""
Write-Host "步骤 5: (可选) 禁用代理设置" -ForegroundColor Cyan
Write-Host "   - 如果使用镜像加速器，可以暂时禁用代理" -ForegroundColor White
Write-Host "   - Settings → Resources → Proxies" -ForegroundColor White
Write-Host "   - 关闭 'Manual proxy configuration'" -ForegroundColor White
Write-Host ""
Write-Host "配置完成后，运行测试脚本:" -ForegroundColor Green
Write-Host "  powershell -ExecutionPolicy Bypass -File test-mirror.ps1" -ForegroundColor Cyan
Write-Host ""

# 检查当前配置
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "检查当前 Docker 配置" -ForegroundColor Yellow
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

$daemonJsonPaths = @(
    Join-Path $env:USERPROFILE ".docker\daemon.json",
    Join-Path $env:ProgramData "Docker\config\daemon.json"
)

$found = $false
foreach ($path in $daemonJsonPaths) {
    if (Test-Path $path) {
        Write-Host "找到配置文件: $path" -ForegroundColor Green
        try {
            $content = Get-Content $path -Raw
            Write-Host "当前配置内容:" -ForegroundColor Yellow
            Write-Host $content -ForegroundColor Gray
            $found = $true
        } catch {
            Write-Host "无法读取配置文件" -ForegroundColor Red
        }
        break
    }
}

if (-not $found) {
    Write-Host "未找到配置文件，需要在 Docker Desktop GUI 中配置" -ForegroundColor Yellow
}

Write-Host ""


