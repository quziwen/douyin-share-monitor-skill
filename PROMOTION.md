# Promotion Copy / 宣传文案

## 中文短版

我把“收藏一个抖音视频”改造成了一条真正可用的个人知识流。

现在只要把链接交给 Codex 或 Claude Code，说一句：

> 帮我抓取这个抖音：链接

它就会完成链接解析、视频抓取、本地转写、内容整理，并保存成 Obsidian 笔记。默认本地优先，不读取 Cookie、Token 或 `.env`，也不会顺手写入飞书；只有你明确指定目标时才扩展到飞书文档或 Base。

公开仓库：https://github.com/quziwen/douyin-share-monitor-skill

## 中文长版

很多“稍后看”最终都会变成“再也不看”。真正的问题不是收藏入口不够多，而是收藏之后没有进入可以搜索、整理和复用的知识系统。

`douyin-share-monitor` 是我为 Codex / Claude Code 制作的一个安全工作流 Skill。你只需要粘贴抖音视频链接或完整分享文案，说一句“帮我抓取这个抖音”，它就会把这条内容依次解析、抓取、在本地完成语音转写和内容整理，最后保存到 Obsidian，并回读确认笔记确实创建成功。

它默认停在本地，不自动写飞书，不读取 `.env`、Cookie、Token、浏览器 Profile 或私信正文。需要临时改变保存位置时，可以直接在同一句话里指定本地目录、飞书文档或企业 Base；需要永久改变默认工具时，它会先说明要修改的配置和影响，再等待确认。

这不是一个“显示成功就算完成”的脚本。媒体匹配、音轨、转写、Obsidian 和外部写入分别验收，任何缺失都会单独报告。

公开仓库：https://github.com/quziwen/douyin-share-monitor-skill

## English short version

I turned “save this Douyin video for later” into an actual personal knowledge workflow.

Paste a link into Codex or Claude Code and say:

> Capture this Douyin video: URL

The Skill resolves the link, captures the exact media, transcribes it locally, organizes the content, saves it to Obsidian, and reads the note back for verification. It is local-first by default and does not read cookies, tokens, browser profiles, or `.env` contents. Feishu and other external destinations are used only when explicitly selected.

GitHub: https://github.com/quziwen/douyin-share-monitor-skill

## English long version

Most “save for later” lists quietly become “never revisit.” The missing piece is not another bookmark button; it is a reliable path from a video link to searchable, reusable knowledge.

`douyin-share-monitor` is a safety-oriented workflow Skill for Codex and Claude Code. Paste a Douyin URL or full share message and ask it to capture the video. It resolves the target, captures verified media, transcribes locally, organizes the result, creates an Obsidian note, and reads the note back before claiming completion.

The default is deliberately local-first. The Skill does not read `.env`, cookies, tokens, browser profiles, private-message bodies, signed media URLs, or full transcripts. You can override one request with a local folder, Feishu Docs, or Feishu Base, while persistent routing changes require an explicit review of the configuration impact.

Media identity, audio validity, transcription, Obsidian output, external writes, and monitor health are verified as separate evidence layers.

GitHub: https://github.com/quziwen/douyin-share-monitor-skill

## Suggested release title

中文：`douyin-share-monitor：一句话把抖音视频沉淀到 Obsidian`

English: `douyin-share-monitor: Turn a Douyin link into an Obsidian knowledge note`
