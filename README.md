<div align="center">

# Claude Code 三 Provider 配置 Skill

**安装此 Skill 后，AI 自动帮你配置 Kimi / MiniMax / 智谱 GLM 三 Provider，无需 Claude 官方账号**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![macOS](https://img.shields.io/badge/platform-macOS-blue.svg)]()
[![Windows](https://img.shields.io/badge/platform-Windows-blue.svg)]()
[![Linux](https://img.shields.io/badge/platform-Linux-blue.svg)]()

</div>

---

## 这是什么？

这是一个 **Claude Code Skill**，安装后 AI 会自动读取 [SKILL.md](./SKILL.md) 中的配置指南，一步步帮你完成：

- 绕过 Claude Code 官方登录（免账号）
- 配置 Kimi / MiniMax / 智谱 GLM 三个国产 API Provider
- 设置 Shell 别名，一条命令切换 Provider + 启动

| Provider | 模型 | 特点 |
|----------|------|------|
| **智谱 GLM** | GLM-5.1 / GLM-5-Turbo | 推理能力强，Coding Plan 性价比高 |
| **MiniMax** | MiniMax-M2.7 / MiniMax-M2.7-highspeed | Agent 能力突出，Token Plan 全模态 |
| **Kimi** | kimi-for-coding | 月之暗面 Coding Plan，长上下文 |

## 安装方法

### 方式一：手动安装（推荐）

1. 将本仓库的 `SKILL.md` 下载到你的 Claude Code skills 目录：

**macOS / Linux：**
```bash
# 创建 skills 目录（如果不存在）
mkdir -p ~/.claude/skills

# 下载 SKILL.md
curl -o ~/.claude/skills/claude-code-dual-provider.md \
  https://raw.githubusercontent.com/0505ttt/claude-code-dual-provider/main/SKILL.md
```

**Windows PowerShell：**
```powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude\skills" -Force | Out-Null
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/0505ttt/claude-code-dual-provider/main/SKILL.md" -OutFile "$env:USERPROFILE\.claude\skills\claude-code-dual-provider.md"
```

2. 重启 Claude Code，AI 会自动加载此 Skill。

3. 在 Claude Code 中告诉 AI 你想配置哪个 Provider，例如：

```
帮我配置智谱 GLM 的 Claude Code 接入
```

AI 会读取 Skill 内容，引导你完成所有配置。

### 方式二：克隆整个仓库

```bash
git clone https://github.com/0505ttt/claude-code-dual-provider.git
```

然后将 `SKILL.md` 复制到你的 skills 目录。

## 它怎么工作？

```
你告诉 AI "帮我配置智谱 GLM"
        ↓
AI 读取 SKILL.md 中的配置指南
        ↓
AI 自动完成：
  ├── 创建 ~/.claude.json（绕过登录）
  ├── 创建 ~/.claude/settings-zhipu.json（智谱配置）
  ├── 创建 ~/.claude/settings-kimi.json（Kimi 配置）
  ├── 创建 ~/.claude/settings-minimax.json（MiniMax 配置）
  ├── 配置 Shell 别名（use-kimi / use-minimax / use-zhipu / ck / cm / cz / cc）
  └── 验证配置是否生效
        ↓
你运行 cz 即可使用智谱 GLM
```

## 命令速查

安装完成后，你可以使用以下命令：

| 命令 | 作用 |
|------|------|
| `ck` | 切换到 Kimi + 启动 Claude Code |
| `cm` | 切换到 MiniMax + 启动 Claude Code |
| `cz` | 切换到智谱 GLM + 启动 Claude Code |
| `cc` | 不切换 Provider + 启动 Claude Code |
| `use-kimi` | 仅切换配置到 Kimi |
| `use-minimax` | 仅切换配置到 MiniMax |
| `use-zhipu` | 仅切换配置到智谱 GLM |

## API Key 获取

| Provider | 获取方式 | 价格参考 |
|----------|----------|----------|
| 智谱 GLM | [智谱 Coding Plan](https://open.bigmodel.cn) | Coding Plan 有免费额度 |
| MiniMax | [MiniMax Token Plan](https://platform.minimaxi.com/subscribe/token-plan) | 29 元/月起 |
| Kimi | [Kimi Coding Plan](https://kimi.com/code) | Coding Plan 会员专属 |

## Provider 能力对比

| 功能 | Kimi | Claude 内置 | MiniMax MCP | 智谱 MCP |
|------|------|-------------|-------------|----------|
| 图片理解 | 模型内置 | 基础 | `understand_image` | 视觉理解 MCP |
| 网络搜索 | 无 | Brave | `web_search` | 网络搜索 MCP |

## 注意事项

- Kimi Coding Plan 的 Key **和** 月之暗面普通 API 的 Key **不通用**，用错端点会 401
- 智谱必须用 `api/anthropic` 端点（Claude 兼容），不能用 `api/coding/paas/v4`（OpenAI 兼容）
- `/model` 命令只切换模型名称，**不改变 API 地址**。切换 Provider 必须用 `use-*` 命令后重启
- MCP 工具配置在 `~/.claude.json`，与 `settings.json`（Provider 配置）完全独立，切换 Provider 不影响 MCP

## 常见问题

<details>
<summary><b>use-zhipu / ck 等命令 not found</b></summary>

macOS / Linux：先执行 `source ~/.zshrc` 加载别名。

Windows：关闭并重新打开 PowerShell 窗口，或执行 `. $PROFILE` 手动加载。

</details>

<details>
<summary><b>智谱配置后 API 连接失败</b></summary>

确保 `ANTHROPIC_BASE_URL` 是 `https://open.bigmodel.cn/api/anthropic`（Claude 兼容端点），不是 `api/coding/paas/v4`（OpenAI 兼容端点）。

</details>

<details>
<summary><b>Claude Code 启动仍进入登录界面</b></summary>

检查 `~/.claude.json` 是否包含 `"hasCompletedOnboarding": true` 字段。没有该字段会走 onboarding 流程。

</details>

<details>
<summary><b>更多问题</b></summary>

完整常见问题（10 个）请查看 [SKILL.md](./SKILL.md)。

</details>

## 文件说明

```
claude-code-dual-provider/
├── README.md          # 项目说明（安装和使用方法）
├── SKILL.md           # Skill 文件（AI 读取的完整配置指南）
└── LICENSE            # MIT License
```

## 参考链接

- [月之暗面 API 接入指南](https://platform.kimi.com/docs/guide/agent-support)
- [智谱 Claude Code 接入文档](https://docs.bigmodel.cn/cn/guide/develop/claude)
- [智谱 Coding Plan 快速开始](https://docs.bigmodel.cn/cn/coding-plan/quick-start)

## License

[MIT](./LICENSE)
