# Docker 代理配置指南

## 问题
Docker 尝试连接 `host.docker.internal:7897`，但代理地址是 `127.0.0.1:7897`

## 解决方案

### 方法1: 修改 Docker Desktop 代理设置（推荐）

1. **打开 Docker Desktop**
2. **点击右上角的设置图标（齿轮图标）**
3. **选择 Resources → Proxies**
4. **在 Manual proxy configuration 中设置：**
   - Web server (HTTP): `http://127.0.0.1:7897`
   - Secure Web server (HTTPS): `http://127.0.0.1:7897`
   - Bypass these hosts & domains: `localhost,127.0.0.1`
5. **点击 Apply & Restart**

### 方法2: 使用命令行配置 Docker daemon.json

1. **找到 Docker daemon.json 配置文件位置**（通常在）:
   - Windows: `%USERPROFILE%\.docker\daemon.json`
   - 或 Docker Desktop 设置中查看

2. **编辑或创建 daemon.json 文件**，添加以下内容：
```json
{
  "proxies": {
    "http-proxy": "http://127.0.0.1:7897",
    "https-proxy": "http://127.0.0.1:7897",
    "no-proxy": "localhost,127.0.0.1"
  }
}
```

3. **重启 Docker Desktop**

### 方法3: 临时禁用代理（如果代理不可用）

1. **打开 Docker Desktop**
2. **Settings → Resources → Proxies**
3. **取消勾选 Manual proxy configuration**
4. **点击 Apply & Restart**

## 配置完成后

运行以下命令启动服务：

```powershell
docker compose up -d
```

## 验证配置

检查 Docker 是否能够拉取镜像：

```powershell
docker pull hello-world
```

如果成功，说明代理配置正确。


