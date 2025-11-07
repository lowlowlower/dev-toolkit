# 🚀 快速开始

## 一步安装 Supabase

### 前提条件
- Docker Desktop 已安装并运行

### 安装步骤

**打开 PowerShell，运行：**

```powershell
# 进入项目目录
cd D:\SDevolpment\github\环境营造

# 运行安装脚本
.\INSTALL.ps1
```

**就这么简单！** 脚本会自动：
1. 检查 Docker
2. 下载所有镜像（约 5-10 分钟）
3. 启动所有服务
4. 初始化数据库

### 启动前端

```powershell
npm run dev
```

访问：http://localhost:5173

---

## 常用操作

### 查看服务状态
```powershell
docker ps
```

### 停止服务
```powershell
docker-compose down
```

### 重新启动
```powershell
docker-compose up -d
```

### 查看日志
```powershell
docker-compose logs -f
```

---

## 服务地址

- **前端**: http://localhost:5173
- **管理界面**: http://localhost:54323
- **API**: http://localhost:54324
- **数据库**: localhost:54322

---

## 遇到问题？

### PowerShell 执行策略错误
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

### Docker 未运行
启动 Docker Desktop

### 端口被占用
```powershell
# 查找占用端口的进程
netstat -ano | findstr "54322"

# 停止进程
taskkill /PID <进程ID> /F
```

### 完全重置
```powershell
# 停止并删除所有容器和数据
docker-compose down -v

# 重新安装
.\INSTALL.ps1
```

---

## 更多工具

在 `docker/` 目录下有更多管理脚本：

```powershell
cd docker

# 各种管理工具
.\status.ps1    # 查看状态
.\logs.ps1      # 查看日志
.\backup.ps1    # 备份数据
.\query.ps1     # 查询数据
```

---

**就这样！开始使用吧！** 🎉


