---
name: claude-code-dual-provider
description: Claude Code 免登录接入国产大模型 — Kimi · MiniMax · 智谱 GLM 三 Provider 一键切换
---

# Claude Code 免登录接入国产大模型 — Kimi · MiniMax · 智谱 GLM 三 Provider 一键切换

## 概述

Claude Code 可配置 **Kimi**、**MiniMax** 和 **智谱 GLM** 三个 API Provider，通过配置文件切换。

## API 配置信息

> ⚠️ **安全提醒**：以下为占位模板，请替换为你的真实 Key。请勿将真实 Key 写入 skill 或代码仓库。

| Provider | Base URL | API Key 格式 | 模型 |
|----------|----------|--------------|------|
| MiniMax（高速） | `https://api.minimaxi.com/anthropic` | `sk-cp-...` | `MiniMax-M2.7-highspeed` |
| MiniMax（标准） | `https://api.minimaxi.com/anthropic` | `sk-cp-...` | `MiniMax-M2.7` |
| Kimi Coding Plan | `https://api.kimi.com/coding/` | `sk-kimi-...` | `kimi-for-coding` |
| 月之暗面（普通） | `https://api.moonshot.cn/anthropic/` | `sk-...` | `kimi-k2-turbo-preview` |
| 智谱 GLM Coding Plan | `https://open.bigmodel.cn/api/anthropic` | 智谱 API Key | `GLM-5.1` / `GLM-5-Turbo` |

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

Claude Code 必须用 Anthropic 兼容端点 `api/anthropic`，不能用 OpenAI 兼容端点。

## 配置文件

### 位置（按 OS）

| OS | 配置目录 |
|----|----------|
| macOS / Linux | `~/.claude/` |
| Windows (PowerShell/CMD) | `C:\Users\你的用户名\.claude\` |
| Windows (Git Bash / WSL) | `~/.claude/`（同 macOS） |

配置文件：
- `settings-minimax.json` - MiniMax 配置
- `settings-kimi.json` - Kimi 配置
- `settings-zhipu.json` - 智谱 GLM 配置
- `settings.json` - **当前生效配置**（由 `use-kimi`/`use-minimax`/`use-zhipu` 复制覆盖）

### 配置文件结构

**智谱配置文件结构**
```json
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
  "alwaysThinkingEnabled": true
}
```

**MiniMax 配置文件结构**
```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.minimaxi.com/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "sk-cp-你的MiniMax-Key",
    "ANTHROPIC_MODEL": "MiniMax-M2.7-highspeed",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "MiniMax-M2.7-highspeed",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "MiniMax-M2.7-highspeed",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "MiniMax-M2.7-highspeed",
    "API_TIMEOUT_MS": "3000000",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": 1
  },
  "language": "chinese",
  "alwaysThinkingEnabled": true
}
```

**Kimi 配置文件结构**
```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.kimi.com/coding/",
    "ANTHROPIC_AUTH_TOKEN": "sk-kimi-你的Kimi-Key",
    "ANTHROPIC_MODEL": "kimi-for-coding",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "kimi-for-coding",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "kimi-for-coding",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "kimi-for-coding",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": 1
  },
  "language": "chinese",
  "alwaysThinkingEnabled": true
}
```

### 智谱模型说明

| Claude 模型映射 | GLM 模型 | 用途 |
|----------------|----------|------|
| Opus / Sonnet | GLM-5.1 | 默认模型，最强推理能力 |
| Haiku | GLM-5-Turbo | 快速响应，轻量任务 |

如需使用其他模型（如 GLM-4.7），修改配置文件中的模型名称即可。

**Windows 用户**：直接创建/编辑 `C:\Users\你的用户名\.claude\settings.json`，内容同上。

### 切换模型（智谱）

如需降级为 GLM-4.7，修改配置文件中的模型名称：
```json
{
  "env": {
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "GLM-4.7",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "GLM-4.7",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "GLM-4.5-Air"
  }
}
```

## 切换命令

### macOS / Linux（zsh/bash，需 `source ~/.zshrc`）
```bash
use-kimi      # 切换到 Kimi API（复制 settings-kimi.json → settings.json）
use-minimax   # 切换到 MiniMax API（复制 settings-minimax.json → settings.json）
use-zhipu     # 切换到智谱 GLM API（复制 settings-zhipu.json → settings.json）
```

### Windows PowerShell

在 `C:\Users\你的用户名\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` 中添加以下内容：

```powershell
# 设置控制台为 UTF-8，避免中文乱码
chcp 65001 > $null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Claude Code 三 Provider 切换命令
function use-zhipu {
    $source = "$env:USERPROFILE\.claude\settings-zhipu.json"
    $target = "$env:USERPROFILE\.claude\settings.json"
    if (Test-Path $source) {
        Copy-Item $source $target -Force
        Write-Host "[claude-code] 已切换到智谱 GLM 配置" -ForegroundColor Cyan
    } else {
        Write-Error "settings-zhipu.json 不存在，请先创建配置文件"
    }
}

function use-kimi {
    $source = "$env:USERPROFILE\.claude\settings-kimi.json"
    $target = "$env:USERPROFILE\.claude\settings.json"
    if (Test-Path $source) {
        Copy-Item $source $target -Force
        Write-Host "[claude-code] 已切换到 Kimi 配置" -ForegroundColor Cyan
    } else {
        Write-Error "settings-kimi.json 不存在，请先创建配置文件"
    }
}

function use-minimax {
    $source = "$env:USERPROFILE\.claude\settings-minimax.json"
    $target = "$env:USERPROFILE\.claude\settings.json"
    if (Test-Path $source) {
        Copy-Item $source $target -Force
        Write-Host "[claude-code] 已切换到 MiniMax 配置" -ForegroundColor Cyan
    } else {
        Write-Error "settings-minimax.json 不存在，请先创建配置文件"
    }
}

function ck {
    use-kimi
    claude --effort max @args
}

function cm {
    use-minimax
    claude --effort max @args
}

function cz {
    use-zhipu
    claude --effort max @args
}

function cc {
    claude --effort max @args
}
```

**重要**：该文件必须保存为 **UTF-8 with BOM** 编码，否则中文字符串会导致 PowerShell 解析语法错误（报"字符串缺少终止符"）。

PowerShell Profile 路径（按版本）：
- **Windows PowerShell 5.1**：`C:\Users\用户名\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`
- **PowerShell 7+ (pwsh)**：`C:\Users\用户名\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`

修改后**关闭并重新打开** PowerShell 窗口生效（或执行 `. $PROFILE` 手动加载）。

### 启动命令
```bash
ck   # 切换到 Kimi + 启动 Claude Code + max 思考强度
cm   # 切换到 MiniMax + 启动 Claude Code + max 思考强度
cz   # 切换到智谱 GLM + 启动 Claude Code + max 思考强度
cc   # 仅启动 Claude Code + max 思考强度（不切换 API）
claude  # 原生命令（无思考强度设置）
```

### Claude Code 内切换模型命令
```bash
/model kimi-for-coding       # 切换到 Kimi 模型
/model MiniMax-M2.7-highspeed  # 切换到 MiniMax 模型
/model MiniMax-M2.7            # 切换到 MiniMax 标准版模型
/model GLM-4.7               # 切换到智谱 GLM-4.7 模型
/model GLM-5.1               # 切换到智谱 GLM-5.1 模型
/model GLM-5-Turbo           # 切换到智谱 GLM-5-Turbo 模型
```

**注意**：`/model` 命令只切换模型名称，不改变 API 地址。如需真正切换 Provider，必须用 `use-kimi`、`use-minimax` 或 `use-zhipu` 后重启 Claude Code。

## 设置命令

### `/config` 设置（持久化到 `settings.json`）
在 Claude Code 内输入 `/config` 进入设置菜单，可设置：
- `Output style` → `Explanatory`（输出风格）
- `Verbose output` → `true`（详细输出）
- `Default permission mode` → `Plan Mode`（计划模式权限）
- `Language` → `Chinese`（中文界面）

设置后会保存到当前 `settings.json`。**重要**：用 `/config` 改好设置后，需要手动复制到配置文件：

**macOS / Linux**：
```bash
cp ~/.claude/settings.json ~/.claude/settings-kimi.json   # 保存到 Kimi 配置
cp ~/.claude/settings.json ~/.claude/settings-minimax.json  # 保存到 MiniMax 配置
cp ~/.claude/settings.json ~/.claude/settings-zhipu.json  # 保存到智谱配置
```

**Windows PowerShell**：
```powershell
Copy-Item "$env:USERPROFILE\.claude\settings.json" "$env:USERPROFILE\.claude\settings-kimi.json" -Force
Copy-Item "$env:USERPROFILE\.claude\settings.json" "$env:USERPROFILE\.claude\settings-minimax.json" -Force
Copy-Item "$env:USERPROFILE\.claude\settings.json" "$env:USERPROFILE\.claude\settings-zhipu.json" -Force
```

### `/effort` 设置（仅当前会话有效）
```bash
/effort
# 选择: max（最大思考强度）
```

**注意**：`/effort` 设置**不持久化**，每次启动 Claude Code 都需要重新设置。建议使用 `cc`、`ck`、`cm`、`cz` 启动命令自动带 `--effort max` 参数。

## 绕过登录（免账号）

Claude Code **无需官方账号登录**，通过两个配置文件即可进入主界面：

### 核心配置文件
**`~/.claude.json`** — 加入一行跳过 onboarding：
```json
{
  "hasCompletedOnboarding": true
}
```
加上这行后，Claude Code 启动直接进主界面，不会显示登录页。

### API 配置
**`~/.claude/settings.json`** — 配第三方 API：
```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "你的智谱API_Key",
    "ANTHROPIC_MODEL": "GLM-5.1"
  }
}
```

**Windows 路径**：`C:\Users\你的用户名\.claude\`

### 完整绕过流程（全新安装）

**macOS / Linux**：
```bash
# 1. 创建跳过登录
echo '{"hasCompletedOnboarding": true}' > ~/.claude.json

# 2. 配置 API
cat > ~/.claude/settings.json << 'EOF'
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "你的智谱API_Key",
    "ANTHROPIC_MODEL": "GLM-5.1"
  }
}
EOF

# 3. 启动（无需任何登录操作）
claude
```

**Windows PowerShell**：
```powershell
# 1. 创建 .claude 目录并写入跳过登录
$claudeDir = "$env:USERPROFILE\.claude"
New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null
'{"hasCompletedOnboarding": true}' | Set-Content "$env:USERPROFILE\.claude.json" -Encoding UTF8

# 2. 写入 API 配置（替换为你的 Key）
@'
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "你的智谱API_Key",
    "ANTHROPIC_MODEL": "GLM-5.1"
  }
}
'@ | Set-Content "$claudeDir\settings.json" -Encoding UTF8

# 3. 启动
claude
```

### 验证是否生效
启动后看到主聊天界面而不是登录页，即为成功。如果仍弹登录页，检查 `~/.claude.json` 是否正确（JSON 格式、路径是否正确、字段名是否拼写正确）。

## 常见问题

### 1. `use-zhipu` / `ck` 等命令 not found
**macOS / Linux**：
```bash
source ~/.zshrc   # 先加载
```

**Windows**：关闭并重新打开 PowerShell 窗口，或执行 `. $PROFILE` 手动加载。

### 2. 智谱配置后 API 连接失败
**原因**：`ANTHROPIC_BASE_URL` 填成了 OpenAI 兼容端点 `api/coding/paas/v4`。
**解决方法**：确保使用 Claude 兼容端点：
```json
"ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic"
```

### 3. Default permission mode 不生效
**原因**：环境变量 `CLAUDE_CODE_PERMISSIONS=auto-approve` 覆盖了 `settings.json` 设置。
**解决方法**：从 `~/.zshrc` 或 PowerShell Profile 中删除该行。

### 4. 手动改的设置被 `use-zhipu` 覆盖
**原因**：`use-zhipu` 用 `settings-zhipu.json` 覆盖 `settings.json`。
**解决方法**：先在 Claude Code 里用 `/config` 改好设置，然后保存到对应 Provider 的配置文件（见上文 `/config` 设置章节）。

### 5. `/model` 切换后 API 地址没变
**原因**：`/model` 只改模型名称，不改 BASE_URL。需要 `use-kimi`/`use-minimax`/`use-zhipu` + 重启 Claude Code。

### 6. MiniMax 不认识 `kimi-for-coding` 模型
**原因**：MiniMax API 会忽略请求中的模型名称，直接用自己的模型。如果 `settings.json` 的 BASE_URL 是 MiniMax，即使 `/model` 切换成 `kimi-for-coding`，实际还是调用 MiniMax。

### 7. 智谱模型切换不生效
**原因**：智谱 Coding Plan 的模型映射需要通过 `ANTHROPIC_DEFAULT_*_MODEL` 环境变量配置，而不是仅修改 `ANTHROPIC_MODEL`。
**解决方法**：确保配置文件中包含完整的模型映射：
```json
{
  "env": {
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "GLM-5-Turbo",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "GLM-5.1",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "GLM-5.1"
  }
}
```

### 8. Windows PowerShell 中文切换标语显示乱码
**原因**：`[Console]::OutputEncoding` 设为 UTF-8，但控制台代码页（`chcp`）仍是 936 (GBK)，两者不一致导致 UTF-8 字节被 GBK 解码。
**解决方法**：在 PowerShell Profile 开头加上 `chcp 65001 > $null`，确保控制台代码页也是 UTF-8。详见上文 "Windows PowerShell" 配置代码。

### 9. Windows PowerShell Profile 加载报"字符串缺少终止符"
**原因**：PowerShell 5.1 默认用系统 locale（GBK）读取无 BOM 的 UTF-8 文件，中文字节被错误解析，导致引号位置错乱。
**解决方法**：将 Profile 文件保存为 **UTF-8 with BOM**（VS Code：右下角点击编码 → `Save with Encoding` → `UTF-8 with BOM`）。

### 10. Claude Code 启动仍进入初始化/登录界面
**原因**：`~/.claude.json` 中缺少 `"hasCompletedOnboarding": true` 字段。即使文件存在，没有该字段也会走 onboarding。
**解决方法**：检查并确保 `.claude.json` 包含该字段：
```json
{
  "hasCompletedOnboarding": true
}
```

## 验证配置

### 查看当前状态
在 Claude Code 内输入：
```bash
/status
```

### 测试 API 连接
```bash
# 测试 MiniMax
curl https://api.minimaxi.com/anthropic/v1/models \
  -H "Authorization: Bearer <MINIMAX_KEY>"

# 测试 Kimi
curl https://api.kimi.com/coding/v1/models \
  -H "Authorization: Bearer <KIMI_KEY>"

# 测试智谱 GLM
curl https://open.bigmodel.cn/api/anthropic/v1/models \
  -H "Authorization: Bearer <ZHIPU_KEY>"
```

## 文件位置汇总

| 用途 | macOS / Linux | Windows (PowerShell 5.1) | Windows (PowerShell 7+) |
|------|---------------|--------------------------|------------------------|
| MiniMax 配置 | `~/.claude/settings-minimax.json` | `C:\Users\用户名\.claude\settings-minimax.json` | 同左 |
| Kimi 配置 | `~/.claude/settings-kimi.json` | `C:\Users\用户名\.claude\settings-kimi.json` | 同左 |
| 智谱 GLM 配置 | `~/.claude/settings-zhipu.json` | `C:\Users\用户名\.claude\settings-zhipu.json` | 同左 |
| 当前生效配置 | `~/.claude/settings.json` | `C:\Users\用户名\.claude\settings.json` | 同左 |
| Shell 配置 | `~/.zshrc` | `C:\Users\用户名\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` | `C:\Users\用户名\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` |
| Claude Code 别名 | `ck`, `cm`, `cz`, `cc`（在 zshrc 中） | `ck`, `cm`, `cz`, `cc`（在 PowerShell Profile 中） | 同左 |
| 跳过登录配置 | `~/.claude.json` | `C:\Users\用户名\.claude.json` | 同左 |

## MCP 配置

### MiniMax Token Plan MCP
已在 `~/.claude.json` 中配置 MiniMax MCP，提供 `web_search` 和 `understand_image` 工具。

**重要**：MCP 配置在 `~/.claude.json`，与 `settings.json`（Provider 配置）**完全独立**：
- 切换 `use-kimi` / `use-minimax` / `use-zhipu` 不会影响 MCP
- MCP 在所有 Provider 下都可使用

### 智谱 MCP 服务器
智谱 Coding Plan 提供专属 MCP 服务器：
- **视觉理解 MCP** — 使用 GLM-4.6V 分析图像
- **网络搜索 MCP** — 获取最新技术信息
- **网页读取 MCP** — 抓取并解析网页内容
- **开源仓库 MCP** — GitHub 代码检索

详细配置请参考智谱官方文档。

### 查看已启用的 MCP
```bash
cat ~/.claude.json | grep mcpServers -A20
```

### 查看已安装的插件
```bash
cat ~/.claude/plugins/installed_plugins.json
```

## Provider 能力对比

| 功能 | Kimi | Claude 内置 | MiniMax MCP | 智谱 MCP |
|------|------|-------------|-------------|----------|
| 图片理解 | 模型内置 | 基础 | `understand_image` | 视觉理解 MCP |
| 网络搜索 | 无 | Brave | `web_search` | 网络搜索 MCP |

**注意**：用 `ck`（Kimi）时，图片理解由 Kimi 模型内置能力处理，不是 MiniMax MCP。用 `cz`（智谱）时，图片理解由智谱视觉 MCP 处理。

## 参考资料

- 月之暗面普通 API 官方文档：https://platform.kimi.com/docs/guide/agent-support
- 智谱 Claude Code 接入文档：https://docs.bigmodel.cn/cn/guide/develop/claude
- 智谱 Coding Plan 快速开始：https://docs.bigmodel.cn/cn/coding-plan/quick-start

## 命令速查

```
ck              → Kimi API + max 思考强度
cm              → MiniMax API + max 思考强度
cz              → 智谱 GLM API + max 思考强度
cc              → 不切换 API + max 思考强度

use-kimi        → 切换到 Kimi 配置
use-minimax     → 切换到 MiniMax 配置
use-zhipu       → 切换到 智谱 GLM 配置

/model kimi-for-coding       → 切换模型（不换 API，不推荐）
/model MiniMax-M2.7-highspeed → 切换模型（不换 API，不推荐）
/model MiniMax-M2.7            → 切换模型（不换 API，不推荐）
/model GLM-5.1               → 切换模型（不换 API，不推荐）

/config         → 设置界面
/effort         → 思考强度（仅当前会话，每次启动需重设）
/mcp            → 查看 MCP 工具列表
/plugins        → 查看插件列表
```
