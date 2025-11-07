# Docker 网络问题解决方案

## 🔍 问题诊断

你遇到的错误：
```
Error response from daemon: failed to resolve reference "docker.io/supabase/gotrue:v2.99.0": failed to do request: Head "https://registry-1.docker.io/v2/supabase/gotrue/manifests/v2.99.0": EOF
```

这是 Docker 访问 Docker Hub 时的网络问题。

## ✅ 解决方案

### 方案1: 检查和修复代理设置（最常见）

1. **打开 Docker Desktop**
2. **设置 → Resources → Proxies**
3. **检查代理设置**：
   - 如果不需要代理：**关闭 Manual proxy configuration**
   - 如果需要代理：确保代理地址正确（如 `http://127.0.0.1:7890`）

4. **点击 Apply & Restart**

### 方案2: 配置镜像加速器

你的 `daemon.json` 已配置，但需要确保 Docker 已重启：

```powershell
# 重启 Docker Desktop（在设置里点 Apply & Restart）
# 或者完全退出后重新打开
```

配置位置：`C:\Users\<你的用户名>\.docker\daemon.json`

当前配置：
```json
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ]
}
```

### 方案3: 测试网络连接

在 PowerShell 中测试：

```powershell
# 测试连接 Docker Hub
Test-NetConnection -ComputerName registry-1.docker.io -Port 443

# 测试代理
curl http://www.google.com
```

### 方案4: 使用阿里云镜像加速

1. 登录阿里云账号
2. 访问：https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors
3. 获取专属加速地址
4. 添加到 `daemon.json`：

```json
{
  "registry-mirrors": [
    "https://你的ID.mirror.aliyuncs.com",
    "https://docker.mirrors.ustc.edu.cn"
  ]
}
```

## 🚀 解决后继续安装

修复网络问题后，运行：

```powershell
# 进入项目目录
cd D:\SDevolpment\github\环境营造

# 启动服务（会自动拉取镜像）
docker-compose up -d

# 等待服务启动
Start-Sleep -Seconds 30

# 初始化数据库
Get-Content supabase\init.sql | docker exec -i supabase-db psql -U postgres -d postgres

# 启动前端
npm run dev
```

## 📞 快速解决步骤

**最快的方法：**

1. **打开 Docker Desktop**
2. **设置 → Resources → Proxies**  
3. **关闭代理**（如果不需要）
4. **Apply & Restart**
5. **重新运行安装**

## 🔧 诊断命令

```powershell
# 查看 Docker 配置
docker info

# 测试拉取简单镜像
docker pull hello-world

# 查看网络连接
Get-NetRoute
```

## ⚡ 立即尝试

修复后运行：
```powershell
.\INSTALL.ps1
```

或者手动运行：
```powershell
docker-compose up -d
```


