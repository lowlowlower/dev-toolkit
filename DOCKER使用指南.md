# 🐳 Docker Supabase 使用指南

## 📖 概述

本项目提供了完整的命令行工具来管理 Docker Supabase 服务，无需记忆复杂的 Docker 命令。

## 🚀 三步快速启动

### 步骤 1: 安装 Supabase 镜像（仅首次）

```powershell
cd docker
.\install.ps1
```

**这个脚本会:**
- ✅ 检查 Docker 环境
- ✅ 拉取所有 Supabase 镜像（约 1-2GB）
- ✅ 创建 Docker 网络

**预计时间:** 5-15 分钟（取决于网速）

---

### 步骤 2: 启动服务

```powershell
.\start.ps1
```

**这个脚本会:**
- ✅ 启动 6 个 Supabase 服务
- ✅ 等待数据库就绪
- ✅ 显示访问地址

**预计时间:** 30-60 秒

**服务地址:**
- 📊 管理界面: http://localhost:54323
- 🔌 API 网关: http://localhost:54324
- 💾 数据库: localhost:54322

---

### 步骤 3: 初始化数据库

```powershell
.\init-db.ps1
```

**这个脚本会:**
- ✅ 创建数据库表
- ✅ 插入 20 张卡片数据
- ✅ 创建 5 个工作流模板

**预计时间:** 5-10 秒

---

## 🎯 完成！

现在你可以：

```powershell
# 回到项目根目录
cd ..

# 启动前端
npm run dev
```

访问 http://localhost:5173 开始使用！

---

## 📋 常用命令速查

### 日常使用

```powershell
# 进入 docker 目录
cd docker

# 启动服务
.\start.ps1

# 停止服务
.\stop.ps1

# 查看状态
.\status.ps1

# 查看日志
.\logs.ps1

# 查询数据
.\query.ps1
```

### 管理操作

```powershell
# 重新初始化数据库（会删除现有数据）
.\init-db.ps1

# 完全清理（删除所有数据）
.\stop.ps1  # 选择选项 3
```

---

## 🔧 目录结构

```
docker/
├── install.ps1      # 安装脚本
├── start.ps1        # 启动脚本
├── stop.ps1         # 停止脚本
├── init-db.ps1      # 初始化数据库
├── status.ps1       # 状态检查
├── logs.ps1         # 日志查看
├── query.ps1        # 数据查询
└── README.md        # 详细文档
```

---

## 💡 使用场景

### 场景 1: 每天开始工作

```powershell
cd docker
.\start.ps1          # 启动服务
cd ..
npm run dev          # 启动前端
```

### 场景 2: 每天结束工作

```powershell
cd docker
.\stop.ps1           # 选择 1 - 仅停止容器
```

### 场景 3: 遇到问题调试

```powershell
cd docker
.\status.ps1         # 查看状态
.\logs.ps1           # 查看日志（选择有问题的服务）
```

### 场景 4: 重置所有数据

```powershell
cd docker
.\stop.ps1           # 选择 3 - 完全清理
.\start.ps1          # 重新启动
.\init-db.ps1        # 重新初始化
```

### 场景 5: 查看数据库内容

```powershell
cd docker
.\query.ps1          # 选择要查询的内容
```

---

## ❓ 常见问题

### Q1: 如何知道服务是否正在运行？

```powershell
cd docker
.\status.ps1
```

会显示所有服务的运行状态 ✓ 或 ✗

---

### Q2: 如何查看某个服务的日志？

```powershell
cd docker
.\logs.ps1
# 然后选择要查看的服务（1-7）
```

---

### Q3: 如何进入数据库执行 SQL？

```powershell
cd docker
.\query.ps1
# 选择 6 - 进入交互式 SQL 模式
```

**常用 SQL 命令:**
```sql
-- 查看所有表
\dt

-- 查看卡片
SELECT * FROM business_cards;

-- 退出
\q
```

---

### Q4: 启动失败怎么办？

**步骤 1: 检查 Docker 是否运行**
```powershell
docker info
```

**步骤 2: 查看详细日志**
```powershell
cd docker
.\logs.ps1  # 选择 1 - 所有服务
```

**步骤 3: 完全重置**
```powershell
.\stop.ps1   # 选择 3
.\start.ps1
.\init-db.ps1
```

---

### Q5: 端口被占用怎么办？

**查找占用端口的进程:**
```powershell
netstat -ano | findstr "54322"
netstat -ano | findstr "54323"
netstat -ano | findstr "54324"
```

**停止进程:**
```powershell
taskkill /PID <进程ID> /F
```

---

### Q6: 数据会丢失吗？

**不会！** 只要使用以下方式停止：
```powershell
.\stop.ps1  # 选择 1 或 2
```

数据保存在 Docker volumes 中，下次启动会自动恢复。

**只有选择选项 3（完全清理）才会删除数据**

---

### Q7: 如何备份数据？

```powershell
# 导出数据
docker exec supabase-db pg_dump -U postgres > backup_$(Get-Date -Format 'yyyyMMdd').sql

# 恢复数据
Get-Content backup_20241105.sql | docker exec -i supabase-db psql -U postgres
```

---

## 🎨 工作流示例

### 开发工作流

```powershell
# 早上启动
cd D:\SDevolpment\github\环境营造
cd docker
.\start.ps1

# 开发前检查
.\status.ps1

# 启动前端
cd ..
npm run dev

# [开发中...]

# 需要查看数据
cd docker
.\query.ps1

# 需要重置数据
.\init-db.ps1

# 晚上关闭
.\stop.ps1  # 选择 1
```

---

## 📊 服务端口映射

| 服务 | 容器端口 | 主机端口 | 访问方式 |
|------|----------|----------|----------|
| PostgreSQL | 5432 | 54322 | localhost:54322 |
| Studio | 3000 | 54323 | http://localhost:54323 |
| Kong | 8000 | 54324 | http://localhost:54324 |
| Auth | 9999 | 54325 | http://localhost:54325 |
| REST | 3000 | 54326 | http://localhost:54326 |
| Storage | 5000 | 54327 | http://localhost:54327 |

---

## 🔐 默认凭据

### 数据库
- **用户名:** postgres
- **密码:** your-super-secret-jwt-token-with-at-least-32-characters-long
- **数据库:** postgres

### JWT Keys
- **Anon Key:** eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
- **Service Key:** eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

**注意:** 这些是开发环境的默认值，生产环境请修改！

---

## 📚 更多帮助

- **详细文档:** `docker/README.md`
- **Docker 官方文档:** https://docs.docker.com/
- **Supabase 文档:** https://supabase.com/docs

---

## 🎉 提示

### 创建快捷方式

在桌面创建快捷方式以便快速访问：

**启动 Supabase:**
```
目标: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
参数: -NoExit -Command "cd 'D:\SDevolpment\github\环境营造\docker'; .\start.ps1"
```

**停止 Supabase:**
```
目标: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
参数: -NoExit -Command "cd 'D:\SDevolpment\github\环境营造\docker'; .\stop.ps1"
```

---

## ✅ 下一步

1. ✅ 安装完成 → `.\install.ps1`
2. ✅ 启动服务 → `.\start.ps1`
3. ✅ 初始化数据 → `.\init-db.ps1`
4. ✅ 开始使用 → `npm run dev`

**祝你使用愉快！** 🚀


