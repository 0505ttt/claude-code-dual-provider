---
name: claude-code-dual-provider
description: Claude Code 免登录接入国产大模型 — Kimi · MiniMax · 智谱 GLM 三 Provider 智能切换（v2）
---

# Claude Code 免登录接入国产大模型 — Kimi · MiniMax · 智谱 GLM 三 Provider 智能切换

## 概述

Claude Code 可配置 **Kimi**、**MiniMax** 和 **智谱 GLM** 三个 API Provider，通过 `use-model` 脚本智能切换。

> **v2 更新**：不再使用 `cp` 覆盖 settings.json，改用 `use-model` 脚本只修改模型字段，切换时不会丢失插件、权限和 MCP 配置。新增状态栏模型名自动显示。

## API 配置信息

> ⚠️ **安全提醒**：以下为占位模板，请替换为你的真实 Key。请勿将真实 Key 写入 skill 或代码仓库。

| Provider | Base URL | API Key 格式 | 模型 |
|----------|----------|--------------|------|
| 智谱 GLM Coding Plan | `https://open.bigmodel.cn/api/anthropic` | 智谱 API Key | `GLM-5.1` / `GLM-5-Turbo` |
| MiniMax | `https://api.minimaxi.com/anthropic` | `sk-cp-...` | `MiniMax-M3` / `MiniMax-M2.7-highspeed` |
| Kimi Coding Plan | `https://api.kimi.com/coding/` | `sk-kimi-...` | `kimi-for-coding` |
| 月之暗面（普通） | `https://api.moonshot.cn/anthropic/` | `sk-...` | `kimi-k2-turbo-preview` |

### 区分 Kimi 两个端点

| 端点 | 用途 | Key 来源 |
|------|------|----------|
| `api.kimi.com/coding/` | **Kimi Coding Plan**（会员专属） | https://kimi.com/code 订阅 |
| `api.moonshot.cn/anthropic/` | 月之暗面普通 API | https://platform.moonshot.cn |

**两者 API Key 不通用**，用错端点会 401。

### 区分智谱两个端点

| 端点 | 用途 | 兼容格式 |
|------|------|----------|
| `open.bigmodel.cn/api/anthropic` | **Claude Code 专用**（Anthropic 兼容） | Claude SDK |
| `open.bigmodel.cn/api/coding/paas/v4` | 通用 API（OpenAI 兼容） | OpenAI SDK |

Claude Code 必须用 Anthropic 兼容端点 `api/anthropic`。

## 安装步骤

### 第一步：安装 use-model 切换脚本

**macOS / Linux：**

```bash
# 确保目标目录存在且在 PATH 中
mkdir -p ~/npm-global/bin

# 下载脚本
curl -o ~/npm-global/bin/use-model \
  https://raw.githubusercontent.com/0505ttt/claude-code-dual-provider/main/use-model
chmod +x ~/npm-global/bin/use-model
```

编辑脚本，将 `PROFILES` 中的 API Key 替换为你的真实 Key：

```bash
nano ~/npm-global/bin/use-model
```

**Windows PowerShell：**

```powershell
$binDir = "$env:USERPROFILE\bin"
New-Item -ItemType Directory -Path $binDir -Force | Out-Null

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/0505ttt/claude-code-dual-provider/main/use-model.ps1" `
  -OutFile "$binDir\use-model.ps1"

# 确保 PATH
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$binDir*") {
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$binDir", "User")
}
```

### 第二步：安装状态栏脚本

**macOS / Linux：**

```bash
mkdir -p ~/.claude/helpers

curl -o ~/.claude/helpers/statusline.cjs \
  https://raw.githubusercontent.com/0505ttt/claude-code-dual-provider/main/helpers/statusline.cjs
```

**Windows PowerShell：**

```powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude\helpers" -Force | Out-Null
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/0505ttt/claude-code-dual-provider/main/helpers/statusline.cjs" `
  -OutFile "$env:USERPROFILE\.claude\helpers\statusline.cjs"
```

### 第三步：配置 Shell 别名

#### macOS / Linux（zsh）

在 `~/.zshrc` 中添加：

```bash
# Claude Code 切换 Provider（智能切换，保留插件/权限/MCP）
alias cc='claude --effort max'
alias ck='use-model kimi && claude --effort max'
alias cm='use-model minimax && claude --effort max'
alias cz='use-model zhipu && claude --effort max'
```

然后执行 `source ~/.zshrc` 生效。

#### Windows PowerShell

在 PowerShell Profile 中添加：

```powershell
# 设置控制台为 UTF-8
chcp 65001 > $null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Claude Code 三 Provider 切换命令
function ck {
    use-model kimi
    claude --effort max @args
}

function cm {
    use-model minimax
    claude --effort max @args
}

function cz {
    use-model zhipu
    claude --effort max @args
}

function cc {
    claude --effort max @args
}
```

**重要**：该文件必须保存为 **UTF-8 with BOM** 编码。

PowerShell Profile 路径（按版本）：
- **Windows PowerShell 5.1**：`C:\Users\用户名\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`
- **PowerShell 7+ (pwsh)**：`C:\Users\用户名\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`

### 第四步：绕过登录 + 初始配置

**macOS / Linux：**
```bash
# 创建跳过登录
echo '{"hasCompletedOnboarding": true}' > ~/.claude.json

# 配置初始 API（任选一个 Provider）
cat > ~/.claude/settings.json << 'EOF'
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "你的智谱API_Key",
    "ANTHROPIC_MODEL": "GLM-5.1",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "GLM-5.1",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "GLM-5.1",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "GLM-5-Turbo",
    "API_TIMEOUT_MS": "3000000",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": 1
  },
  "language": "chinese",
  "statusLine": {
    "type": "command",
    "command": "node ~/.claude/helpers/statusline.cjs"
  }
}
EOF
```

**Windows PowerShell：**
```powershell
$claudeDir = "$env:USERPROFILE\.claude"
New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null
'{"hasCompletedOnboarding": true}' | Set-Content "$env:USERPROFILE\.claude.json" -Encoding UTF8

@'
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "你的智谱API_Key",
    "ANTHROPIC_MODEL": "GLM-5.1",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "GLM-5.1",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "GLM-5.1",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "GLM-5-Turbo",
    "API_TIMEOUT_MS": "3000000",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": 1
  },
  "language": "chinese",
  "statusLine": {
    "type": "command",
    "command": "node ~/.claude/helpers/statusline.cjs"
  }
}
'@ | Set-Content "$claudeDir\settings.json" -Encoding UTF8
```

> **注意**：`statusLine` 必须是 **object 格式**（`{"type": "command", "command": "..."}`），不能是 string 格式（`"node ..."`）。string 格式会导致状态栏不显示。

### 第五步：验证

```bash
cz    # 用智谱 GLM 启动
# 状态栏应显示 GLM-5.1 模型名
```

## 状态栏配置

状态栏脚本 `statusline.cjs` 通过 Claude Code 会话数据自动显示当前模型名称，无需手动配置。

**关键配置：**

1. 脚本位置：`~/.claude/helpers/statusline.cjs`
2. 模型名读取：自动从 Claude Code 会话数据获取（stdin JSON），无需环境变量
3. settings.json 中 `statusLine` 格式：
```json
"statusLine": {
  "type": "command",
  "command": "node ~/.claude/helpers/statusline.cjs"
}
```

**Windows 用户**路径改为：
```json
"statusLine": {
  "type": "command",
  "command": "node %USERPROFILE%\\.claude\\helpers\\statusline.cjs"
}
```

**切换模型后自动更新**：`use-model` 修改 `ANTHROPIC_MODEL`，下次启动 Claude Code 时状态栏自动显示新模型名。

## 启动命令

```bash
ck   # 切换到 Kimi + 启动 + 状态栏显示 kimi-for-coding
cm   # 切换到 MiniMax + 启动 + 状态栏显示 MiniMax-M3
cz   # 切换到智谱 GLM + 启动 + 状态栏显示 GLM-5.1
cc   # 不切换 API + 启动

# 仅切换，不启动
use-model kimi      # 切换到 Kimi
use-model zhipu     # 切换到智谱 GLM
use-model minimax   # 切换到 MiniMax
```

## use-model 脚本工作原理

```
use-model kimi
    │
    ├── 1. 检测 Claude Code 是否运行中 → 运行中则需确认
    ├── 2. 获取文件锁 → 防止并发切换
    ├── 3. 读取 settings.json
    ├── 4. 检测当前模型 → 已是目标则跳过
    ├── 5. 备份 → settings.json.bak
    ├── 6. 只修改 env 中 6 个模型字段
    │      (BASE_URL, AUTH_TOKEN, MODEL,
    │       SONNET_MODEL, OPUS_MODEL, HAIKU_MODEL)
    ├── 7. 保留其他所有字段不动
    │      (enabledPlugins, permissions, statusLine, MCP, etc.)
    ├── 8. 原子写入（先 .tmp 再 rename）
    └── 9. 释放锁，显示状态
```

## 智谱模型说明

| Claude 模型映射 | GLM 模型 | 用途 |
|----------------|----------|------|
| Opus / Sonnet | GLM-5.1 | 默认模型，最强推理能力 |
| Haiku | GLM-5-Turbo | 快速响应，轻量任务 |

### 切换模型（智谱）

修改 `use-model` 脚本中 PROFILES：
```python
"zhipu": {
    "ANTHROPIC_MODEL": "GLM-4.7",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "GLM-4.7",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "GLM-4.7",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "GLM-4.5-Air",
    ...
}
```

## 更换 API Key

编辑 `use-model` 脚本中的 `PROFILES` 字典：

**macOS / Linux：**
```bash
nano ~/npm-global/bin/use-model
```

**Windows：**
```powershell
notepad "$env:USERPROFILE\bin\use-model.ps1"
```

找到对应 Provider 的 `ANTHROPIC_AUTH_TOKEN` 行，替换为新的 Key。

## /config 设置

在 Claude Code 内输入 `/config` 进入设置菜单。

**v2 优势**：用 `/config` 改好设置后，**无需手动同步到配置文件**。因为 `use-model` 不会覆盖其他字段，设置会自动保留。

## Claude Code 内切换模型

```bash
/model kimi-for-coding         # 切换到 Kimi 模型
/model MiniMax-M3              # 切换到 MiniMax 模型
/model GLM-5.1                 # 切换到智谱 GLM-5.1
/model GLM-5-Turbo             # 切换到智谱 GLM-5-Turbo
```

**注意**：`/model` 只切换模型名称，不改 BASE_URL。真正切换 Provider 用 `use-model`。

## MCP 配置

MCP 配置在 `~/.claude.json`，与 `settings.json` **完全独立**：
- `use-model` 切换 Provider 不会影响 MCP
- MCP 在所有 Provider 下都可使用

```bash
# 查看已启用的 MCP
cat ~/.claude.json | grep mcpServers -A20

# 查看已安装的插件
cat ~/.claude/plugins/installed_plugins.json
```

## 常见问题

### 1. `ck` / `cz` 等命令 not found
**macOS / Linux**：`source ~/.zshrc`
**Windows**：重新打开 PowerShell，或 `. $PROFILE`

### 2. 切换后插件/权限丢失
确认使用 v2 的 `use-model`，不是 v1 的 `cp` 方式：
```bash
# 正确（v2）
alias ck='use-model kimi && claude --effort max'
# 错误（v1，会丢插件）
alias ck='use-kimi && claude --effort max'
```

### 3. 状态栏不显示模型名 / 显示 Unknown
确保：
1. `~/.claude/helpers/statusline.cjs` 存在
2. `settings.json` 中 `statusLine` 是 **object 格式**（不是 string）
3. `statusline.cjs` 已正确安装（模型名从会话数据自动获取）

### 4. 智谱配置后 API 连接失败
确保 `ANTHROPIC_BASE_URL` 是 `https://open.bigmodel.cn/api/anthropic`。

### 5. Default permission mode 不生效
检查环境变量 `CLAUDE_CODE_PERMISSIONS=auto-approve` 是否覆盖了设置。

### 6. `/model` 切换后 API 地址没变
`/model` 只改名称。切换 Provider 用 `use-model` + 重启。

### 7. MiniMax 不认识 `kimi-for-coding` 模型
MiniMax API 忽略模型名称，BASE_URL 决定实际 API。

### 8. Windows PowerShell 中文乱码
PowerShell Profile 开头加 `chcp 65001 > $null`。

### 9. Windows PowerShell Profile 报"字符串缺少终止符"
保存为 **UTF-8 with BOM**。

### 10. Claude Code 启动仍进入登录界面
检查 `~/.claude.json` 包含 `"hasCompletedOnboarding": true`。

## v1 迁移指南

1. **安装 use-model 脚本**（见安装步骤）
2. **更新 Shell 别名**：
   ```bash
   # 删除旧别名
   # alias use-kimi='cp ...'
   # 替换为新别名
   alias ck='use-model kimi && claude --effort max'
   alias cm='use-model minimax && claude --effort max'
   alias cz='use-model zhipu && claude --effort max'
   ```
3. **将 API Key 填入 use-model 脚本**
4. **可选：删除旧模板文件**
   ```bash
   rm ~/.claude/settings-kimi.json
   rm ~/.claude/settings-minimax.json
   rm ~/.claude/settings-zhipu.json
   ```

## 文件位置汇总

| 用途 | macOS / Linux | Windows |
|------|---------------|---------|
| 当前配置 | `~/.claude/settings.json` | `C:\Users\用户名\.claude\settings.json` |
| 切换脚本 | `~/npm-global/bin/use-model` | `C:\Users\用户名\bin\use-model.ps1` |
| 状态栏脚本 | `~/.claude/helpers/statusline.cjs` | `C:\Users\用户名\.claude\helpers\statusline.cjs` |
| 备份 | `~/.claude/settings.json.bak` | `C:\Users\用户名\.claude\settings.json.bak` |
| Shell 配置 | `~/.zshrc` | PowerShell Profile |
| 跳过登录 | `~/.claude.json` | `C:\Users\用户名\.claude.json` |

## 命令速查

```
ck              → Kimi API + max 思考强度
cm              → MiniMax API + max 思考强度
cz              → 智谱 GLM API + max 思考强度
cc              → 不切换 API + max 思考强度

use-model kimi      → 仅切换到 Kimi
use-model zhipu     → 仅切换到智谱 GLM
use-model minimax   → 仅切换到 MiniMax

/config         → 设置界面
/mcp            → 查看 MCP 工具列表
/plugins        → 查看插件列表
```

## 参考资料

- 月之暗面 API 文档：https://platform.kimi.com/docs/guide/agent-support
- 智谱 Claude Code 接入：https://docs.bigmodel.cn/cn/guide/develop/claude
- 智谱 Coding Plan 快速开始：https://docs.bigmodel.cn/cn/coding-plan/quick-start
