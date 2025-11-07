# ⚡ 快速开始 - 5分钟上手指南

## 🎯 目标

在 5 分钟内完成安装并运行第一次分析。

## 📝 步骤

### 1️⃣ 准备工作（1分钟）

确保你有：
- ✅ Windows 10/11 电脑
- ✅ 已安装 Python 3.8+（[下载地址](https://www.python.org/downloads/)）
- ✅ 已登录微信 PC 客户端
- ✅ Gemini API Key（你已经有了：`AIzaSyApuy_ax9jhGXpUdlgI6w_0H5aZ7XiY9vU`）

### 2️⃣ 安装依赖（2分钟）

打开 PowerShell，进入项目目录，运行：

```powershell
# 右键点击"安装依赖.ps1"，选择"使用 PowerShell 运行"
# 或者手动执行：
.\安装依赖.ps1
```

等待安装完成。

### 3️⃣ 配置 API Key（1分钟）

```powershell
# 复制配置文件
copy config.example.json config.json

# 编辑配置（会自动打开记事本）
notepad config.json
```

在打开的文件中，你会看到：
```json
{
  "gemini_api_key": "AIzaSyApuy_ax9jhGXpUdlgI6w_0H5aZ7XiY9vU",
  ...
}
```

API Key 已经填好了，保存关闭即可。

### 4️⃣ 测试连接（30秒）

```powershell
# 右键点击"测试API.ps1"，选择"使用 PowerShell 运行"
# 或者：
.\测试API.ps1
```

如果看到 `✅ 所有测试通过！`，说明一切正常！

### 5️⃣ 开始分析！（30秒）

```powershell
# 方法一：使用快速启动脚本（推荐）
.\快速启动.ps1

# 方法二：直接运行 Python
python main.py
```

## 🎉 完成！

程序会自动：
1. 查找你的微信数据
2. 提取最近24小时的消息
3. 使用 AI 分析
4. 生成报告保存到 `reports` 目录

## 📊 查看报告

分析完成后，在 `reports` 目录下会生成两个文件：
- `messages_时间戳.txt` - 原始消息记录
- `report_时间戳.md` - AI 分析报告

直接用记事本或 Markdown 查看器打开 `report_*.md` 即可。

## 🤔 如果遇到问题

### 问题：提示"未找到微信数据路径"

**解决**：手动指定路径

1. 打开微信 → 设置 → 文件管理
2. 看到类似这样的路径：`C:\Users\你的用户名\Documents\WeChat Files`
3. 编辑 `config.json`：

```json
{
  "gemini_api_key": "AIzaSyApuy_ax9jhGXpUdlgI6w_0H5aZ7XiY9vU",
  "wechat_data_path": "C:\\Users\\你的用户名\\Documents\\WeChat Files"
}
```

注意：路径要用双反斜杠 `\\`

### 问题：提示"数据库已加密"

**方法一**：安装 pywxdump（推荐）
```powershell
pip install pywxdump
```

**方法二**：使用第三方工具导出
1. 下载 [WeChatMsg](https://github.com/LC044/WeChatMsg)
2. 导出消息为文本文件
3. 运行：
```powershell
python main.py --file 导出的文件.txt
```

### 问题：API 连接失败

**检查**：
1. API Key 是否正确（检查 `config.json`）
2. 网络能否访问 Google（测试：访问 google.com）
3. 没有代理或防火墙拦截

**临时测试**（不推荐生产使用）：
已经在配置中填入了一个可用的 API Key，可以先用这个测试。

## 📚 下一步

- 阅读 [README.md](README.md) 了解更多功能
- 查看 [安装指南.md](安装指南.md) 了解详细配置
- 设置定时任务，每天自动分析

## 💡 高级用法

### 自定义分析时间范围
```powershell
# 分析最近 48 小时
python main.py --hours 48

# 分析最近一周（168小时）
python main.py --hours 168
```

### 设置定时任务
```powershell
# 启动定时任务（每天自动运行）
python schedule_daily.py
```

在 `config.json` 中设置执行时间：
```json
{
  "schedule_time": "09:00"
}
```

### 从文件分析
```powershell
python main.py --file messages.txt
```

## 🎯 使用技巧

1. **每天定时查看**：设置每天早上9点自动分析，了解昨天的重要信息
2. **周报生成**：每周一分析过去7天（168小时）的消息，生成周报
3. **客户管理**：定期分析客户对话，提取重要需求
4. **待办提醒**：让 AI 帮你从聊天中提取待办事项

## ✅ 快速检查清单

- [ ] Python 已安装
- [ ] 依赖已安装
- [ ] config.json 已创建并配置
- [ ] API 测试通过
- [ ] 首次运行成功
- [ ] 可以查看生成的报告

全部打勾？恭喜，你已经成功掌握了基本用法！🎉

---

**有问题？** 查看 [README.md](README.md) 的常见问题部分

