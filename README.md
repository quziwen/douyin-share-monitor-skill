# douyin-share-monitor Skill

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

### 依赖

本 Skill 是工作流层，不包含抖音抓取器、登录态、模型或密钥。使用前需要：

- 一个可运行的 [`douyin-share`](https://github.com/DannyZZ2/douyin-share) 项目副本
- Windows PowerShell、Node.js 和项目依赖
- Playwright 浏览器运行时
- 项目内 Python 虚拟环境和本地 Whisper-compatible 转写能力
- Obsidian；飞书仅在你明确选择为输出目标时需要

### 安装到 Codex

```powershell
git clone https://github.com/quziwen/douyin-share-monitor-skill.git
Copy-Item -Recurse -Force `
  '.\douyin-share-monitor-skill\skill\douyin-share-monitor' `
  "$env:USERPROFILE\.codex\skills\douyin-share-monitor"
```

重新打开 Codex 任务后即可通过自然语言触发。

### 安装到 Claude Code

```powershell
Copy-Item -Recurse -Force `
  '.\douyin-share-monitor-skill\skill\douyin-share-monitor' `
  "$env:USERPROFILE\.claude\skills\douyin-share-monitor"
```

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
- 本仓库只发布工作流 Skill，不代表上游项目已经完成生产验收。
- 本仓库暂未声明开源许可证；正式复用或再分发前请先确认授权。

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

### Requirements

This repository provides the workflow layer only. You still need:

- A working checkout of [`douyin-share`](https://github.com/DannyZZ2/douyin-share)
- Windows PowerShell, Node.js, and project dependencies
- A Playwright browser runtime
- A project-local Python environment with Whisper-compatible transcription
- Obsidian; Feishu is optional and only needed when selected as an output

### Install for Codex

```powershell
git clone https://github.com/quziwen/douyin-share-monitor-skill.git
Copy-Item -Recurse -Force `
  '.\douyin-share-monitor-skill\skill\douyin-share-monitor' `
  "$env:USERPROFILE\.codex\skills\douyin-share-monitor"
```

Open a new Codex task and invoke it with natural language.

### Install for Claude Code

```powershell
Copy-Item -Recurse -Force `
  '.\douyin-share-monitor-skill\skill\douyin-share-monitor' `
  "$env:USERPROFILE\.claude\skills\douyin-share-monitor"
```

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
- Publishing this Skill does not claim production acceptance for the upstream project.
- No open-source license has been declared yet; confirm permission before reuse or redistribution.

## Disclaimer

This is an independent workflow project. It is not affiliated with, endorsed by, or sponsored by Douyin, ByteDance, Feishu, Lark, or Obsidian. Use it only for content you are authorized to access and process, and comply with applicable platform terms and laws.
