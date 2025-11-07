# 微信消息 AI 分析器 - 依赖安装脚本

Write-Host "================================" -ForegroundColor Cyan
Write-Host "  安装 Python 依赖" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# 检查 Python
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✅ Python: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ 未找到 Python" -ForegroundColor Red
    Write-Host ""
    Write-Host "请先安装 Python 3.8 或更高版本" -ForegroundColor Yellow
    Write-Host "下载地址: https://www.python.org/downloads/" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "安装时请勾选 'Add Python to PATH'" -ForegroundColor Yellow
    pause
    exit 1
}

# 检查 pip
try {
    $pipVersion = pip --version 2>&1
    Write-Host "✅ pip: $pipVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ 未找到 pip" -ForegroundColor Red
    pause
    exit 1
}

Write-Host ""
Write-Host "📦 开始安装依赖..." -ForegroundColor Cyan
Write-Host ""

# 显示将要安装的包
Write-Host "将安装以下 Python 包:" -ForegroundColor White
Write-Host "  - requests (HTTP 请求库)" -ForegroundColor Gray
Write-Host "  - pywxdump (微信数据库读取)" -ForegroundColor Gray
Write-Host "  - python-dotenv (环境变量管理)" -ForegroundColor Gray
Write-Host "  - pandas (数据处理)" -ForegroundColor Gray
Write-Host "  - schedule (定时任务)" -ForegroundColor Gray
Write-Host ""

$confirm = Read-Host "是否继续？(y/n)"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "❌ 已取消" -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "⏳ 安装中，请稍候..." -ForegroundColor Cyan
Write-Host ""

# 升级 pip
Write-Host "1. 升级 pip..." -ForegroundColor White
python -m pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple
Write-Host ""

# 安装依赖
Write-Host "2. 安装依赖包..." -ForegroundColor White

if (Test-Path "requirements.txt") {
    # 使用清华镜像加速
    pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "================================" -ForegroundColor Green
        Write-Host "✅ 依赖安装完成！" -ForegroundColor Green
        Write-Host "================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "下一步:" -ForegroundColor Cyan
        Write-Host "1. 复制 config.example.json 为 config.json" -ForegroundColor White
        Write-Host "2. 在 config.json 中填入你的 Gemini API Key" -ForegroundColor White
        Write-Host "3. 运行 快速启动.ps1 开始使用" -ForegroundColor White
    } else {
        Write-Host ""
        Write-Host "❌ 安装失败" -ForegroundColor Red
        Write-Host ""
        Write-Host "可能的原因:" -ForegroundColor Yellow
        Write-Host "1. 网络连接问题" -ForegroundColor Gray
        Write-Host "2. Python 版本过低（需要 3.8+）" -ForegroundColor Gray
        Write-Host "3. 权限不足" -ForegroundColor Gray
        Write-Host ""
        Write-Host "解决方案:" -ForegroundColor Yellow
        Write-Host "1. 尝试以管理员权限运行" -ForegroundColor Gray
        Write-Host "2. 检查网络连接" -ForegroundColor Gray
        Write-Host "3. 手动安装: pip install requests schedule pandas" -ForegroundColor Gray
    }
} else {
    Write-Host "❌ 未找到 requirements.txt" -ForegroundColor Red
    Write-Host ""
    Write-Host "手动安装依赖:" -ForegroundColor Yellow
    Write-Host "pip install requests pywxdump python-dotenv pandas schedule" -ForegroundColor Gray
}

Write-Host ""
Write-Host "按任意键退出..." -ForegroundColor Gray
pause

