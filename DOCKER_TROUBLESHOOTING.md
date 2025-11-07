# Docker 镜像拉取问题解决方案

## 问题分析
EOF 错误通常表示：
1. 代理连接不稳定
2. 代理服务器未运行
3. 网络连接中断

## 解决方案

### 方案 1: 检查代理服务是否运行
确保你的代理软件（如 Clash、V2Ray 等）正在运行，并且监听在 127.0.0.1:7897

### 方案 2: 使用 Docker 镜像加速器（推荐，如果在中国）
如果在中国大陆，建议使用镜像加速器而不是代理：

1. 打开 Docker Desktop
2. Settings → Docker Engine
3. 添加以下配置：
```json
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ]
}
```
4. 点击 Apply & Restart
5. 重启后，禁用代理设置（Settings → Resources → Proxies → 关闭 Manual proxy configuration）

### 方案 3: 分步拉取镜像
逐个拉取镜像，找出哪个失败：

```powershell
docker pull supabase/postgres:15.1.0.147
docker pull kong:2.8.1
docker pull supabase/gotrue:v2.99.0
docker pull postgrest/postgrest:v11.2.0
docker pull supabase/storage-api:v1.8.0
docker pull supabase/studio:20240103-4c8b3c4
```

### 方案 4: 先使用模拟模式测试应用（无需 Docker）
应用已经支持模拟模式，可以先测试功能：

```powershell
npm run dev
```

然后访问 http://localhost:5173

### 方案 5: 临时禁用代理
如果代理不稳定，可以临时禁用 Docker Desktop 的代理设置，使用直接连接（可能较慢）


