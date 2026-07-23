# douyin-share-monitor Skill v2.0

[中文](#中文) · [English](#english)

## 中文

`douyin-share-monitor` 是一个面向 Codex / Claude Code 的安全工作流 Skill。它把一句自然语言指令：

> 帮我抓取这个抖音：https://v.douyin.com/xxxxx/

转化为一条可验证的知识整理流程：

> 解析链接 → 精确抓取视频 → 本地转写 → 内容整理 → 保存到 Obsidian → 回读验证

### 适用场景

- 把单条抖音视频沉淀为 Obsidian 知识笔记
- 只做本地语音转写，不写外部系统
- 检查视频是否已抓取、转写或入库
- 对指定旧记录重新处理并回写
- 查看、启动或停止 `douyin-share` 后台监控
- 按本次指令切换到本地 Markdown、飞书文档或企业飞书 Base

### 核心特点

- **短口令。** 直接粘贴抖音链接或完整分享文案。
- **默认本地优先。** 单条抓取默认终点是 Obsidian，不默认写飞书。
- **范围化授权。** 一条指令只授权一个链接和明确指定的输出目标。
- **防重复。** 已存在相同去重 ID 时优先返回原结果，不重复创建或覆盖。
- **证据分层。** 下载、转写、Obsidian、飞书和监控状态分别验收。
- **隐私保护。** 不读取或输出 `.env`、Cookie、Token、浏览器 Profile、私信正文、签名媒体地址或完整转写。

### v2.0 包含什么

v2.0 不再要求用户自行寻找上游项目。公开安装流程会固定使用：

- 完整源码 fork：[`quziwen/douyin-share@v2.0.0`](https://github.com/quziwen/douyin-share/tree/v2.0.0)
- 工作流 Skill：本仓库的 `skill/douyin-share-monitor`
- Windows 一键安装器：`install.ps1`（当前 `v2.0.1`）

源码通过 GitHub fork 保留原作者、提交历史和上下游关系。详见 [SOURCE.md](SOURCE.md)。

`v2.0.1` 修复了 Python 3.14 误选、中断后不能安全续装，以及慢速 PyPI 连接容易超时的问题；运行源码仍固定为 `douyin-share@v2.0.0`。

### 安装前准备

- Windows PowerShell 5.1 或 PowerShell 7
- Git for Windows
- Node.js LTS（包含 Corepack）或可用的 `pnpm`
- 64 位 Python 3.9–3.13，或可提供 Python 3.11 的 `uv`
- FFmpeg，并确保 `ffmpeg`、`ffprobe` 在 `PATH`
- Obsidian；飞书仅在明确选择为输出目标时需要

安装器不会代替用户登录抖音，也不会创建真实飞书配置。

### 一键安装到 Codex

```powershell
git clone https://github.com/quziwen/douyin-share-monitor-skill.git
Set-Location .\douyin-share-monitor-skill
powershell -ExecutionPolicy Bypass -File .\install.ps1 -InstallFor Codex
```

安装器会：

1. 下载固定版本的完整源码到 `$env:USERPROFILE\douyin-share`；
2. 安装 Node 项目依赖、Playwright Chromium、Python 项目依赖和 `faster-whisper`；
3. 从 `.env.example` 创建本机 `.env` 空白模板，不覆盖已有文件；
4. 安装 Skill，并在本机写入项目定位文件；
5. 运行类型检查、自动化测试和转写依赖检查。

安装完成后，需要用户自行填写本机 `.env`，并在可见浏览器中完成首次抖音登录。请勿把 `.env`、Cookie 或浏览器 Profile 发到 Issue 或聊天中。

### 安装到 Claude Code

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 -InstallFor Claude
```

同时安装到 Codex 和 Claude Code：

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 -InstallFor Both
```

已有依赖、只想安装 Skill 时，可以使用 `-SkipDependencies`。安装中断后可直接重新运行；安装器只会续用来源、版本和工作区状态均匹配的源码目录，不会覆盖其他非空目录。也可通过 `-ProjectRoot` 指定新的空目录。

### 常用口令

```text
帮我抓取这个抖音：<抖音链接>
只转文字：<抖音链接>
查这个抖音：<抖音链接>
帮我抓取这个抖音：<链接>，本次保存到 Obsidian 的「视频知识库」
帮我抓取这个抖音：<链接>，同时保存到 Obsidian 和企业飞书 Base
监控状态
启动监控
停止监控
```

### 安全边界

单条“抓取”不授权抖音重新登录、外部 LLM、飞书/Base 写入、消息发送、个人镜像、计划任务或权限修改。只有指令明确选择相应目标时，Skill 才会进入对应流程。永久修改默认保存工具时，应先展示配置文件、字段和影响，再由用户确认。

### 当前限制

- 抖音页面和接口可能变化，真实抓取需要单独运行验证。
- 首次登录必须由用户在可见浏览器中完成。
- Skill 不内置任何本机路径、Base 标识、会话名称或凭证。
- 本地测试通过不等于真实抖音、Whisper、Obsidian 或飞书端到端验收。
- 上游源码目前未声明开源许可证；GitHub fork 保留来源关系，但不会自动授予额外的再分发或重新许可权利。

## English

`douyin-share-monitor` is a safety-oriented workflow Skill for Codex and Claude Code. It turns a short request such as:

> Capture this Douyin video: https://v.douyin.com/xxxxx/

into a verifiable knowledge-capture pipeline:

> Resolve link → capture exact media → transcribe locally → organize content → save to Obsidian → read back and verify

### Use cases

- Convert one Douyin video into an Obsidian knowledge note
- Run local transcription without writing to external systems
- Check whether a link has already been captured or processed
- Reprocess one explicitly selected historical record
- Inspect, start, or stop the `douyin-share` background monitor
- Override the output for one request with Markdown, Feishu Docs, or Feishu Base

### Highlights

- **Natural-language shortcuts.** Paste a Douyin URL or a full share message.
- **Local-first default.** Single-link capture stops at Obsidian unless another destination is explicit.
- **Scoped authorization.** One command covers one link and the named output only.
- **Duplicate protection.** Existing deduplication IDs are returned instead of overwritten.
- **Evidence-based completion.** Media, transcription, Obsidian, Feishu, and monitor health are verified separately.
- **Privacy boundaries.** The Skill does not read or expose `.env`, cookies, tokens, browser profiles, private messages, signed media URLs, or full transcripts.

### What v2.0 includes

v2.0 no longer requires users to locate the upstream project manually. The public installation flow pins:

- Full source fork: [`quziwen/douyin-share@v2.0.0`](https://github.com/quziwen/douyin-share/tree/v2.0.0)
- Workflow Skill: `skill/douyin-share-monitor` in this repository
- Windows installer: `install.ps1` (current version: `v2.0.1`)

The source is published as a GitHub fork so the original author, history, and upstream relationship remain visible. See [SOURCE.md](SOURCE.md).

`v2.0.1` fixes accidental Python 3.14 selection, safe resume after interruption, and timeouts on slow PyPI connections. The runnable source remains pinned to `douyin-share@v2.0.0`.

### Prerequisites

- Windows PowerShell 5.1 or PowerShell 7
- Git for Windows
- Node.js LTS with Corepack, or an available `pnpm`
- 64-bit Python 3.9–3.13, or `uv` capable of providing Python 3.11
- FFmpeg with both `ffmpeg` and `ffprobe` on `PATH`
- Obsidian; Feishu is optional and only needed when selected as an output

The installer does not log into Douyin or create real Feishu configuration.

### One-command setup for Codex

```powershell
git clone https://github.com/quziwen/douyin-share-monitor-skill.git
Set-Location .\douyin-share-monitor-skill
powershell -ExecutionPolicy Bypass -File .\install.ps1 -InstallFor Codex
```

The installer clones the pinned source release, installs Node project dependencies, Playwright Chromium, Python project dependencies, and `faster-whisper`, creates a blank local `.env` from `.env.example`, installs the Skill, writes a local project pointer, and runs automated verification.

After setup, fill in the local `.env` and complete the first Douyin login in a visible browser. Never post `.env`, cookies, or browser-profile content in issues or chats.

### Install for Claude Code

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 -InstallFor Claude
```

Use `-InstallFor Both` to install both Skill copies. Use `-SkipDependencies` only when the runnable project and its dependencies are already available. An interrupted installation can be rerun safely: the installer resumes only when the source, pinned version, and tracked worktree state match. It never overwrites another non-empty directory; use `-ProjectRoot` to choose a new empty target.

### Example prompts

```text
Capture this Douyin video: <URL>
Transcribe only: <URL>
Check this Douyin link: <URL>
Capture this Douyin video: <URL>, save this one to my Obsidian Video Knowledge folder.
Capture this Douyin video: <URL>, save it to both Obsidian and the enterprise Feishu Base.
Check monitor status.
Start the Douyin monitor.
Stop the Douyin monitor.
```

### Safety model

A single capture command does not authorize a new Douyin login, external LLM calls, Feishu/Base writes, messages, personal mirrors, scheduled tasks, or permission changes. Those actions require an explicit destination or separate authorization. Persistent routing changes must disclose the exact configuration file, field, and impact before modification.

### Limitations

- Douyin behavior may change, so real capture still requires runtime validation.
- First-time login must be completed by the user in a visible browser.
- No local path, Base identifier, chat name, credential, or browser state is bundled.
- Local tests do not prove real Douyin, Whisper, Obsidian, or Feishu end-to-end acceptance.
- The upstream source currently declares no open-source license. The GitHub fork preserves attribution but does not create additional redistribution or relicensing rights.

## Disclaimer

This is an independent workflow project. It is not affiliated with, endorsed by, or sponsored by Douyin, ByteDance, Feishu, Lark, or Obsidian. Use it only for content you are authorized to access and process, and comply with applicable platform terms and laws.
