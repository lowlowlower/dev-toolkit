# 微信多开脚本 - PowerShell 版本
# 使用方法: 右键 -> 使用 PowerShell 运行

param(
    [int]$Count = 2  # 默认打开2个，可以通过参数修改
)

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "          微信多开工具 (PowerShell)" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

# 常见微信安装路径
$possiblePaths = @(
    "C:\Program Files\Tencent\WeChat\WeChat.exe",
    "C:\Program Files (x86)\Tencent\WeChat\WeChat.exe",
    "$env:ProgramFiles\Tencent\WeChat\WeChat.exe",
    "${env:ProgramFiles(x86)}\Tencent\WeChat\WeChat.exe",
    "D:\WeChat\WeChat.exe",
    "D:\Program Files\Tencent\WeChat\WeChat.exe"
)

# 查找微信路径
$wechatPath = $null
foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        $wechatPath = $path
        break
    }
}

if (-not $wechatPath) {
    Write-Host "[错误] 未找到微信安装路径！" -ForegroundColor Red
    Write-Host "`n请手动指定路径:" -ForegroundColor Yellow
    Write-Host '  .\微信多开.ps1 -Count 2 -Path "D:\WeChat\WeChat.exe"' -ForegroundColor Gray
    Write-Host "`n按任意键退出..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

Write-Host "微信路径: " -NoNewline
Write-Host "$wechatPath" -ForegroundColor Green
Write-Host "打开数量: " -NoNewline
Write-Host "$Count 个" -ForegroundColor Green
Write-Host ""

# 检查是否已有微信进程在运行
$existingProcesses = Get-Process -Name "WeChat" -ErrorAction SilentlyContinue
if ($existingProcesses) {
    $runningCount = $existingProcesses.Count
    Write-Host "检测到已有 $runningCount 个微信进程在运行" -ForegroundColor Yellow
    Write-Host ""
}

# 启动微信
Write-Host "正在启动微信..." -ForegroundColor Cyan
for ($i = 1; $i -le $Count; $i++) {
    Start-Process -FilePath $wechatPath
    Write-Host "[✓] 第 $i 个微信已启动" -ForegroundColor Green
    Start-Sleep -Milliseconds 800  # 延迟避免同时启动太多
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "启动完成！" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "💡 提示:" -ForegroundColor Yellow
Write-Host "  • 每个窗口需要单独扫码登录" -ForegroundColor Gray
Write-Host "  • 可以同时登录不同账号" -ForegroundColor Gray
Write-Host "  • 数据相互独立，互不影响" -ForegroundColor Gray
Write-Host ""
Write-Host "按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

