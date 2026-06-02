---
name: claude-code-dual-provider
description: Claude Code 免登录接入国产大模型 — Kimi · MiniMax · 智谱 GLM 三 Provider 智能切换（v2）
---

# Claude Code 免登录接入国产大模型 — Kimi · MiniMax · 智谱 GLM 三 Provider 智能切换

## 概述

Claude Code 可配置 **Kimi**、**MiniMax** 和 **智谱 GLM** 三个 API Provider，通过 `use-model` 脚本智能切换。

> **v2 更新**：不再使用 `cp` 覆盖 settings.json，改用 `use-model` 脚本只修改模型字段，切换时不会丢失插件、权限和 MCP 配置。

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

将 `use-model` 脚本下载到 PATH 中的目录（如 `~/npm-global/bin/` 或 `/usr/local/bin/`）：

```bash
# 确保目标目录存在且在 PATH 中
mkdir -p ~/npm-global/bin

# 下载脚本（二选一）
# 方式 A：从本仓库下载
curl -o ~/npm-global/bin/use-model \
  https://raw.githubusercontent.com/0505ttt/claude-code-dual-provider/main/use-model
chmod +x ~/npm-global/bin/use-model

# 方式 B：手动创建
# 将本仓库中的 use-model 文件复制到 ~/npm-global/bin/
```

编辑脚本，将 `PROFILES` 中的 API Key 替换为你的真实 Key：

```bash
nano ~/npm-global/bin/use-model
# 或
code ~/npm-global/bin/use-model
```

**Windows PowerShell：**

将 `use-model.ps1` 脚本下载到 PATH 中的目录：

```powershell
# 创建 bin 目录
$binDir = "$env:USERPROFILE\bin"
New-Item -ItemType Directory -Path $binDir -Force | Out-Null

# 下载脚本
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/0505ttt/claude-code-dual-provider/main/use-model.ps1" `
  -OutFile "$binDir\use-model.ps1"

# 确保 $env:USERPROFILE\bin 在 PATH 中
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$binDir*") {
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$binDir", "User")
}
```

编辑脚本，将 `$Profiles` 中的 API Key 替换为你的真实 Key。

### 第二步：配置 Shell 别名

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

**重要**：该文件必须保存为 **UTF-8 with BOM** 编码，否则中文字符串会导致 PowerShell 解析语法错误。

PowerShell Profile 路径（按版本）：
- **Windows PowerShell 5.1**：`C:\Users\用户名\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`
- **PowerShell 7+ (pwsh)**：`C:\Users\用户名\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`

### 第三步：绕过登录

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
  "language": "chinese"
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
  "language": "chinese"
}
'@ | Set-Content "$claudeDir\settings.json" -Encoding UTF8
```

### 第四步：验证

```bash
# 启动 Claude Code
cz    # 用智谱 GLM 启动

# 在 Claude Code 内验证
/status
```

## 启动命令

```bash
ck   # 切换到 Kimi + 启动 Claude Code + max 思考强度
cm   # 切换到 MiniMax + 启动 Claude Code + max 思考强度
cz   # 切换到智谱 GLM + 启动 Claude Code + max 思考强度
cc   # 仅启动 Claude Code + max 思考强度（不切换 API）

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
    │      (enabledPlugins, permissions, MCP, etc.)
    ├── 8. 原子写入（先 .tmp 再 rename）
    └── 9. 释放锁，显示状态
```

## 智谱模型说明

| Claude 模型映射 | GLM 模型 | 用途 |
|----------------|----------|------|
| Opus / Sonnet | GLM-5.1 | 默认模型，最强推理能力 |
| Haiku | GLM-5-Turbo | 快速响应，轻量任务 |

如需使用其他模型，修改 `use-model` 脚本中 `PROFILES` 的模型名称即可。

### 切换模型（智谱）

如需降级为 GLM-4.7，修改 `use-model` 脚本：
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
# 或
code ~/npm-global/bin/use-model
```

**Windows：**
```powershell
notepad "$env:USERPROFILE\bin\use-model.ps1"
```

找到对应 Provider 的 `ANTHROPIC_AUTH_TOKEN` 行，替换为新的 Key。

## /config 设置

在 Claude Code 内输入 `/config` 进入设置菜单，可设置：
- `Output style` → `Explanatory`
- `Verbose output` → `true`
- `Default permission mode` → `Plan Mode`
- `Language` → `Chinese`

**v2 优势**：用 `/config` 改好设置后，**无需手动同步到配置文件**。因为 `use-model` 不会覆盖其他字段，设置会自动保留。

## Claude Code 内切换模型

```bash
/model kimi-for-coding         # 切换到 Kimi 模型
/model MiniMax-M3              # 切换到 MiniMax 模型
/model GLM-5.1                 # 切换到智谱 GLM-5.1 模型
/model GLM-5-Turbo             # 切换到智谱 GLM-5-Turbo 模型
```

**注意**：`/model` 命令只切换模型名称，不改 BASE_URL。如需真正切换 Provider，必须用 `use-model` 后重启 Claude Code。

## MCP 配置

MCP 配置在 `~/.claude.json`，与 `settings.json`（Provider 配置）**完全独立**：
- `use-model` 切换 Provider 不会影响 MCP
- MCP 在所有 Provider 下都可使用

### 查看已启用的 MCP
```bash
cat ~/.claude.json | grep mcpServers -A20
```

### 查看已安装的插件
```bash
cat ~/.claude/plugins/installed_plugins.json
```

## 常见问题

### 1. `ck` / `cz` 等命令 not found
**macOS / Linux**：
```bash
source ~/.zshrc
```
**Windows**：关闭并重新打开 PowerShell，或执行 `. $PROFILE`。

### 2. 切换后插件/权限丢失
确认你使用的是 v2 的 `use-model` 脚本，而不是 v1 的 `use-kimi`/`use-minimax`/`use-zhipu`（cp 覆盖方式）。v2 只改模型字段，不会丢失其他配置。

检查别名是否正确：
```bash
# 正确（v2）
alias ck='use-model kimi && claude --effort max'

# 错误（v1，会丢插件）
alias ck='use-kimi && claude --effort max'
```

### 3. 智谱配置后 API 连接失败
确保 `ANTHROPIC_BASE_URL` 是 `https://open.bigmodel.cn/api/anthropic`（Claude 兼容端点），不是 `api/coding/paas/v4`（OpenAI 兼容端点）。

### 4. Default permission mode 不生效
原因：环境变量 `CLAUDE_CODE_PERMISSIONS=auto-approve` 覆盖了 `settings.json` 设置。
解决：从 `~/.zshrc` 或 PowerShell Profile 中删除该行。

### 5. `/model` 切换后 API 地址没变
`/model` 只改模型名称，不改 BASE_URL。需要 `use-model` + 重启 Claude Code。

### 6. MiniMax 不认识 `kimi-for-coding` 模型
MiniMax API 会忽略请求中的模型名称，直接用自己的模型。BASE_URL 决定了实际使用的 API。

### 7. 智谱模型切换不生效
智谱 Coding Plan 需要通过 `ANTHROPIC_DEFAULT_*_MODEL` 环境变量配置。确保 `use-model` 脚本的 PROFILES 中包含完整映射。

### 8. Windows PowerShell 中文切换标语显示乱码
在 PowerShell Profile 开头加上 `chcp 65001 > $null`，确保控制台代码页是 UTF-8。

### 9. Windows PowerShell Profile 加载报"字符串缺少终止符"
将 Profile 文件保存为 **UTF-8 with BOM**（VS Code：右下角编码 → `Save with Encoding` → `UTF-8 with BOM`）。

### 10. Claude Code 启动仍进入初始化/登录界面
检查 `~/.claude.json` 是否包含 `"hasCompletedOnboarding": true` 字段。

## v1 迁移指南

如果你之前用的是 v1（`cp` 覆盖方式），按以下步骤迁移：

1. **安装 use-model 脚本**（见上方安装步骤）
2. **更新 Shell 别名**：
   ```bash
   # 删除旧别名（在 ~/.zshrc 中）
   # alias use-kimi='cp ...'
   # alias use-minimax='cp ...'
   # alias use-zhipu='cp ...'

   # 替换为新别名
   alias ck='use-model kimi && claude --effort max'
   alias cm='use-model minimax && claude --effort max'
   alias cz='use-model zhipu && claude --effort max'
   ```
3. **将当前 settings.json 同步到 use-model 脚本**：
   - 把当前 settings.json 中 `env` 的 API Key 填入 `use-model` 的 `PROFILES`
4. **可选：删除旧模板文件**（不再需要）
   ```bash
   rm ~/.claude/settings-kimi.json
   rm ~/.claude/settings-minimax.json
   rm ~/.claude/settings-zhipu.json
   ```

## 文件位置汇总

| 用途 | macOS / Linux | Windows |
|------|---------------|---------|
| 当前生效配置 | `~/.claude/settings.json` | `C:\Users\用户名\.claude\settings.json` |
| 切换脚本 | `~/npm-global/bin/use-model` | `C:\Users\用户名\bin\use-model.ps1` |
| 备份文件 | `~/.claude/settings.json.bak` | `C:\Users\用户名\.claude\settings.json.bak` |
| Shell 配置 | `~/.zshrc` | PowerShell Profile |
| 跳过登录配置 | `~/.claude.json` | `C:\Users\用户名\.claude.json` |

## 验证 API 连接

```bash
# 测试智谱 GLM
curl https://open.bigmodel.cn/api/anthropic/v1/models \
  -H "Authorization: Bearer <ZHIPU_KEY>"

# 测试 Kimi
curl https://api.kimi.com/coding/v1/models \
  -H "Authorization: Bearer <KIMI_KEY>"

# 测试 MiniMax
curl https://api.minimaxi.com/anthropic/v1/models \
  -H "Authorization: Bearer <MINIMAX_KEY>"
```

## 命令速查

```
ck              → Kimi API + max 思考强度
cm              → MiniMax API + max 思考强度
cz              → 智谱 GLM API + max 思考强度
cc              → 不切换 API + max 思考强度

use-model kimi      → 仅切换到 Kimi 配置
use-model zhipu     → 仅切换到智谱 GLM 配置
use-model minimax   → 仅切换到 MiniMax 配置

/model GLM-5.1           → 切换模型（不换 API，不推荐）
/model kimi-for-coding   → 切换模型（不换 API，不推荐）

/config         → 设置界面
/effort         → 思考强度（仅当前会话）
/mcp            → 查看 MCP 工具列表
/plugins        → 查看插件列表
```

## 参考资料

- 月之暗面普通 API 官方文档：https://platform.kimi.com/docs/guide/agent-support
- 智谱 Claude Code 接入文档：https://docs.bigmodel.cn/cn/guide/develop/claude
- 智谱 Coding Plan 快速开始：https://docs.bigmodel.cn/cn/coding-plan/quick-start
