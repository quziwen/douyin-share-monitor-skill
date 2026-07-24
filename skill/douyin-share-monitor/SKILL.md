---
name: douyin-share-monitor
description: Manage a Windows-based douyin-share workflow for capturing Douyin video links, local transcription, content organization, Obsidian saving, optional Feishu Base writeback, and background monitoring. Use when the user pastes a Douyin link or share text and asks to capture it, save it to Obsidian or another destination, transcribe it, check it, reprocess it, or start, stop, and inspect the monitor.
---

# douyin-share-monitor

## Resolve the project

- Resolve the runnable project in this order:
  1. an explicit project path in the current request;
  2. the `DOUYIN_SHARE_PROJECT_ROOT` environment variable;
  3. the `.project-root` file beside this installed `SKILL.md`;
  4. a verified `douyin-share` checkout in the current workspace.
- The official v2 installer writes `.project-root` locally. Read only that path pointer; never read `.env` or browser state while resolving the project.
- Verify the resolved checkout contains `package.json`, `src/`, `scripts/start-monitor.ps1`, and `scripts/stop-monitor.ps1`. Ask for the path only when it cannot be resolved safely.
- Read the repository's `AGENTS.md`, `CLAUDE.md`, `README.md`, and relevant operating documentation before acting.
- Prefer the repository's PowerShell and Node entrypoints. Do not silently modify source code, dependencies, or configuration.
- Resolve Base, table, Obsidian, chat, and profile targets from user-approved project documentation or an explicit target in the current request. Never embed those identifiers in this Skill.

## Safety and authorization

- Treat status checks as read-only.
- Never read or print `.env` contents, browser profiles, cookies, tokens, credentials, private-message bodies, signed media URLs, request headers, or full transcripts. Existence checks are allowed.
- A single-link capture command authorizes only the named link, local media processing, and the explicitly selected output destination.
- Do not perform Douyin login, external LLM calls, Feishu/Base writes, messages, personal-mirror writes, scheduled-task changes, permission changes, or overwrites unless the user explicitly requests that action.
- If a duplicate ID already exists, return the verified existing result. Do not duplicate or overwrite it unless reprocessing is explicit.
- Keep local tests, browser checks, Douyin checks, transcription checks, Obsidian readback, Feishu readback, and long-running monitor evidence separate.

## Short commands

Accept a full Douyin share message, a `douyin.com` URL, or a `v.douyin.com` short URL. Extract and normalize the target link. If no link exists or multiple links are ambiguous, ask one focused question.

- `帮我抓取这个抖音：<link or share text>` / `Capture this Douyin video: <link>`: resolve the link, capture the matching media, transcribe locally, organize the content, create a new Obsidian note in the configured default destination, and read it back. Obsidian is the default endpoint; do not write Feishu.
- `只转文字：<link>` / `Transcribe only: <link>`: capture and transcribe locally without creating an Obsidian note or writing Feishu.
- `查这个抖音：<link>` / `Check this Douyin link: <link>`: read-only lookup; do not download, reprocess, or write.
- `重处理并回写：<link>` / `Reprocess and write back: <link>`: restrict reprocessing and writeback to the unique record for that link.
- `监控状态` / `启动监控` / `停止监控`: route to status, start, and stop workflows. Starting continuous monitoring requires confirmation of its ongoing write impact.

## Change the output destination

- Per request: append `本次保存到 <Obsidian relative folder or local folder>`, `本次改存为本地 Markdown：<folder>`, or `本次改存到飞书文档：<link>`. Change only this video's destination.
- Multiple destinations: append `同时保存到 Obsidian 和企业飞书 Base`. Treat this as scoped authorization for those two writes for this video only, and read back both.
- Persistent default: `以后默认保存到 <destination or tool>` requests a project routing change. First locate the non-secret configuration source and explain the exact file, field, and impact. Change it only after confirmation. Never reveal `.env` contents.
- When no destination is supplied, use the project's approved Obsidian default. Do not hardcode a vault path in this Skill.

## Windows execution

- Prefer the repository's `scripts\start-monitor.ps1` and `scripts\stop-monitor.ps1` when present and validated.
- If those scripts are absent, use the repository's documented Node/tsx entrypoint after verifying it exists. Do not invent or silently rewrite an entrypoint.
- Use only the project's controlled Python virtual environment for transcription. Verify the interpreter and dependencies before use; do not switch global Python configuration.
- Verify the selected Whisper model is locally loadable before processing private media. If setup skipped model preparation and a network download would be required, disclose that download before proceeding.
- Match monitor processes by both repository context and the monitor entrypoint. Never terminate unrelated Node processes.

## Single-link workflow

1. Normalize the supplied link and resolve the Douyin work ID.
2. Check the project's deduplication state before downloading.
3. Capture only media that is verified to match the requested ID; reject unverified page-media fallbacks.
4. Verify the media is readable and contains an audio stream.
5. Transcribe with the project's local Whisper-compatible pipeline.
6. Inspect transcript quality and identify obvious uncertainty without pasting the full transcript into chat.
7. Create a structured note containing source, capture time, canonical link, processing status, summary, and transcript according to the project template.
8. Read the saved note back and verify that the title, summary, and transcript are non-empty and correctly encoded.
9. Perform optional external writes only when the current command explicitly selected them; read each result back independently.

## Monitor status, start, and stop

- Status: reconcile the PID file, exact monitor process, child processes, sanitized heartbeat events, and optional scheduled-task history. A process snapshot proves only current-time liveness.
- Start: confirm continuous-write impact, prevent duplicate instances, start through the validated project entrypoint, and reconcile PID plus sanitized heartbeat. Login requires separate visible-browser authorization.
- Stop: stop only the exact project monitor, verify its children are gone, and preserve unrelated processes and local state.

## Completion criteria

Report completion only for the layers actually verified:

- Media: exact requested work and readable audio-bearing file.
- Transcript: non-empty and quality-reviewed.
- Obsidian: target note exists and was read back successfully.
- Feishu or another external tool: the requested fields were independently read back.
- Monitor: PID, exact process, and sanitized heartbeat agree.

List real writes performed, high-risk actions not performed, unresolved evidence, and any manual intervention still required.
