<div align="center">

# Claude Code 免登录接入国产大模型 — Kimi · MiniMax · 智谱 GLM 三 Provider 一键切换

**绕过 Claude 官方登录，AI 自动帮你配置 Kimi / MiniMax / 智谱 GLM 三个国产大模型 Provider，一条命令随时切换**

**v2 更新：智能切换脚本，切换模型不再丢失插件、权限和 MCP 配置**

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
- 安装 `use-model` 智能切换脚本，一条命令切换 Provider + 启动

| Provider | 模型 | 特点 |
|----------|------|------|
| **智谱 GLM** | GLM-5.1 / GLM-5-Turbo | 推理能力强，Coding Plan 性价比高 |
| **MiniMax** | MiniMax-M3 / MiniMax-M2.7-highspeed | Agent 能力突出，Token Plan 全模态 |
| **Kimi** | kimi-for-coding | 月之暗面 Coding Plan，长上下文 |

## v1 → v2 升级要点

| | v1（旧版 cp 覆盖） | v2（use-model 智能切换） |
|---|---|---|
| 切换方式 | `cp settings-kimi.json settings.json` | `use-model kimi` 只改模型字段 |
| 插件 | **每次切换丢失** | 完整保留 |
| 权限 | **每次切换丢失** | 完整保留 |
| MCP | **每次切换丢失** | 完整保留 |
| 安装新插件后再切 | 插件消失 | 不受影响 |
| 备份 | 无 | 自动备份 + 损坏恢复 |
| 并发保护 | 无 | 文件锁 + 运行检测 |

## 安装方法

### 方式一：手动安装（推荐）

1. 将本仓库的 `SKILL.md` 下载到你的 Claude Code skills 目录：

**macOS / Linux：**
```bash
mkdir -p ~/.claude/skills
curl -o ~/.claude/skills/claude-code-dual-provider.md \
  https://raw.githubusercontent.com/0505ttt/claude-code-dual-provider/main/SKILL.md
```

**Windows PowerShell：**
```powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude\skills" -Force | Out-Null
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/0505ttt/claude-code-dual-provider/main/SKILL.md" -OutFile "$env:USERPROFILE\.claude\skills\claude-code-dual-provider.md"
```

2. 重启 Claude Code，AI 会自动加载此 Skill。

3. 在 Claude Code 中执行此 Skill：

```
/claude-code-dual-provider
```

AI 会读取 Skill 内容，引导你完成全部三个 Provider 的配置。

### 方式二：克隆整个仓库

```bash
git clone https://github.com/0505ttt/claude-code-dual-provider.git
```

然后将 `SKILL.md` 复制到你的 skills 目录。

## 它怎么工作？

```
你告诉 AI "帮我配置 Claude Code 接入国产大模型"
        ↓
AI 读取 SKILL.md 中的配置指南
        ↓
AI 自动完成：
  ├── 创建 ~/.claude.json（绕过官方登录）
  ├── 安装 use-model 切换脚本到 PATH
  ├── 配置 Shell 别名（ck / cm / cz / cc）
  └── 验证配置是否生效
        ↓
三个 Provider 全部就绪
  ├── ck → use-model kimi + 启动
  ├── cm → use-model minimax + 启动
  └── cz → use-model zhipu + 启动
```

## 命令速查

| 命令 | 作用 |
|------|------|
| `ck` | 切换到 Kimi + 启动 Claude Code |
| `cm` | 切换到 MiniMax + 启动 Claude Code |
| `cz` | 切换到智谱 GLM + 启动 Claude Code |
| `cc` | 不切换 Provider + 启动 Claude Code |
| `use-model kimi` | 仅切换到 Kimi（不启动） |
| `use-model minimax` | 仅切换到 MiniMax（不启动） |
| `use-model zhipu` | 仅切换到智谱 GLM（不启动） |

## API Key 获取

| Provider | 获取方式 | 价格参考 |
|----------|----------|----------|
| 智谱 GLM | [智谱 Coding Plan](https://open.bigmodel.cn) | Coding Plan 有免费额度 |
| MiniMax | [MiniMax Token Plan](https://platform.minimaxi.com/subscribe/token-plan) | 29 元/月起 |
| Kimi | [Kimi Coding Plan](https://kimi.com/code) | Coding Plan 会员专属 |

## 安全特性

`use-model` 脚本内置 7 层防护：

| # | 特性 | 说明 |
|---|------|------|
| 1 | 运行检测 | Claude Code 运行中切换需手动确认 |
| 2 | 文件锁 | 防止两个终端并发切换 |
| 3 | 自动备份 | 每次切换前备份到 `.bak` |
| 4 | 损坏恢复 | JSON 损坏自动从备份还原 |
| 5 | 重复跳过 | 已经是目标模型则不操作 |
| 6 | 原子写入 | 先写 `.tmp` 再 `rename` |
| 7 | 状态反馈 | 显示插件数量和权限条数 |

## 注意事项

- Kimi Coding Plan 的 Key **和** 月之暗面普通 API 的 Key **不通用**，用错端点会 401
- 智谱必须用 `api/anthropic` 端点（Claude 兼容），不能用 `api/coding/paas/v4`（OpenAI 兼容）
- `/model` 命令只切换模型名称，**不改变 API 地址**。切换 Provider 必须用 `use-model` 命令后重启
- MCP 工具配置在 `~/.claude.json`，与 `settings.json`（Provider 配置）完全独立，切换 Provider 不影响 MCP
- 更换 API Key 后需编辑 `use-model` 脚本中的 `PROFILES` 字典

## 常见问题

<details>
<summary><b>ck / cz 等命令 not found</b></summary>

**macOS / Linux**：先执行 `source ~/.zshrc` 或新开终端窗口。

**Windows**：关闭并重新打开 PowerShell 窗口，或执行 `. $PROFILE` 手动加载。

</details>

<details>
<summary><b>切换后插件/权限丢失了</b></summary>

如果你还在用 v1 的 `cp` 方式（`use-kimi`/`use-minimax`/`use-zhipu`），请升级到 v2 的 `use-model` 脚本。`cp` 会覆盖整个 settings.json，导致插件丢失。`use-model` 只改模型字段，保留其他所有配置。

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
├── use-model          # Mac/Linux 智能切换脚本
├── use-model.ps1      # Windows PowerShell 智能切换脚本
└── LICENSE            # MIT License
```

## 参考链接

- [月之暗面 API 接入指南](https://platform.kimi.com/docs/guide/agent-support)
- [智谱 Claude Code 接入文档](https://docs.bigmodel.cn/cn/guide/develop/claude)
- [智谱 Coding Plan 快速开始](https://docs.bigmodel.cn/cn/coding-plan/quick-start)

## License

[MIT](./LICENSE)
