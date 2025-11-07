# Docker 代理诊断和修复脚本

Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "Docker 代理诊断报告" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

# 1. 检查代理服务
Write-Host "1. 检查代理服务状态..." -ForegroundColor Yellow
$port7897 = Test-NetConnection -ComputerName localhost -Port 7897 -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
if ($port7897.TcpTestSucceeded) {
    Write-Host "   ✓ 端口 7897 正在监听" -ForegroundColor Green
} else {
    Write-Host "   ✗ 端口 7897 未监听" -ForegroundColor Red
    Write-Host "   → 请确保代理软件正在运行" -ForegroundColor Yellow
    exit 1
}

# 2. 测试代理连接
Write-Host ""
Write-Host "2. 测试代理连接..." -ForegroundColor Yellow
$proxy = "http://127.0.0.1:7897"
try {
    $response = Invoke-WebRequest -Uri "https://httpbin.org/get" -Proxy $proxy -TimeoutSec 10 -UseBasicParsing
    Write-Host "   ✓ 代理连接正常 (HTTP 200)" -ForegroundColor Green
} catch {
    Write-Host "   ✗ 代理连接失败" -ForegroundColor Red
    exit 1
}

# 3. 检查 Docker Desktop 代理配置
Write-Host ""
Write-Host "3. Docker Desktop 代理配置检查..." -ForegroundColor Yellow
Write-Host "   ⚠ 请确认 Docker Desktop 中的代理设置:" -ForegroundColor Yellow
Write-Host "      Settings → Resources → Proxies" -ForegroundColor Cyan
Write-Host "      Web Server (HTTP): http://127.0.0.1:7897" -ForegroundColor White
Write-Host "      Secure Web Server (HTTPS): http://127.0.0.1:7897" -ForegroundColor White
Write-Host "      Bypass: localhost,127.0.0.1,.docker.internal,host.docker.internal" -ForegroundColor White
Write-Host ""

# 4. 检查 Docker daemon.json
Write-Host "4. 检查 Docker daemon.json 配置..." -ForegroundColor Yellow
$daemonJsonPaths = @(
    Join-Path $env:USERPROFILE ".docker\daemon.json",
    Join-Path $env:ProgramData "Docker\config\daemon.json"
)

$foundConfig = $false
foreach ($path in $daemonJsonPaths) {
    if (Test-Path $path) {
        Write-Host "   找到配置文件: $path" -ForegroundColor Green
        try {
            $config = Get-Content $path | ConvertFrom-Json
            if ($config.proxies) {
                Write-Host "   当前代理配置:" -ForegroundColor Cyan
                Write-Host "     HTTP: $($config.proxies.'http-proxy')" -ForegroundColor White
                Write-Host "     HTTPS: $($config.proxies.'https-proxy')" -ForegroundColor White
            } else {
                Write-Host "   ⚠ 配置文件中未找到代理设置" -ForegroundColor Yellow
            }
            $foundConfig = $true
        } catch {
            Write-Host "   ⚠ 无法读取配置文件" -ForegroundColor Yellow
        }
    }
}

if (-not $foundConfig) {
    Write-Host "   ⚠ 未找到 daemon.json 配置文件" -ForegroundColor Yellow
    Write-Host "   → Docker Desktop 使用 GUI 中的代理设置" -ForegroundColor Gray
}

# 5. 建议解决方案
Write-Host ""
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "解决方案" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "方案 1: 在 Docker Desktop 中配置代理（推荐）" -ForegroundColor Yellow
Write-Host "   1. 打开 Docker Desktop" -ForegroundColor White
Write-Host "   2. Settings → Resources → Proxies" -ForegroundColor White
Write-Host "   3. 确保配置如下:" -ForegroundColor White
Write-Host "      - Web Server (HTTP): http://127.0.0.1:7897" -ForegroundColor Cyan
Write-Host "      - Secure Web Server (HTTPS): http://127.0.0.1:7897" -ForegroundColor Cyan
Write-Host "      - 启用 'Manual proxy configuration'" -ForegroundColor Cyan
Write-Host "   4. 点击 'Apply and Restart'" -ForegroundColor White
Write-Host "   5. 等待 Docker Desktop 完全重启后，再次尝试拉取镜像" -ForegroundColor White
Write-Host ""

Write-Host "方案 2: 使用镜像加速器（如果在中国大陆）" -ForegroundColor Yellow
Write-Host "   1. 打开 Docker Desktop" -ForegroundColor White
Write-Host "   2. Settings → Docker Engine" -ForegroundColor White
Write-Host "   3. 添加以下配置:" -ForegroundColor White
Write-Host '      { "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"] }' -ForegroundColor Cyan
Write-Host "   4. 点击 'Apply and Restart'" -ForegroundColor White
Write-Host "   5. 禁用代理设置（如果使用镜像加速器）" -ForegroundColor White
Write-Host ""

Write-Host "方案 3: 检查代理软件设置" -ForegroundColor Yellow
Write-Host "   1. 确保代理软件允许本地连接" -ForegroundColor White
Write-Host "   2. 检查代理是否支持 HTTPS" -ForegroundColor White
Write-Host "   3. 某些代理软件需要允许 Docker Desktop 通过代理" -ForegroundColor White
Write-Host ""

Write-Host "测试命令:" -ForegroundColor Green
Write-Host "   docker pull hello-world" -ForegroundColor Cyan
Write-Host ""


