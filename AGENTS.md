# Project Guide

- This repository is the public installer and workflow layer for `douyin-share-monitor`.
- The runnable source stays in the attributed GitHub fork `quziwen/douyin-share`; do not copy upstream source into this unrelated repository.
- Keep installation deterministic by pinning a published source tag in `install.ps1`.
- Never commit `.env`, credentials, browser profiles, cookies, private-message content, signed media URLs, local vault paths, downloaded media, transcripts, logs, or generated runtime state.
- Installation may prepare local dependencies, but it must not perform Douyin login, Feishu writes, messages, scheduled-task registration, or external LLM calls.
- Validate changes with PowerShell parsing, an isolated `-SkipDependencies` installer test, source-project tests and type checking, and a staged-content secret scan.
- Preserve the existing 1.0 repository history and publish version changes through normal commits; never force-push over confirmed releases.
