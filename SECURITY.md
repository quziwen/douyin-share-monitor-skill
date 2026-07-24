# Security Policy / 安全说明

## Sensitive data

Do not include any of the following in issues, logs, screenshots, examples, or pull requests:

- `.env` contents
- cookies, tokens, credentials, or API keys
- browser profile files
- private-message bodies
- signed media URLs or request headers
- real Feishu Base, table, chat, or record identifiers
- private Obsidian vault paths or note contents

请勿在 Issue、日志、截图、示例或 PR 中提交 `.env` 正文、Cookie、Token、凭证、浏览器 Profile、私信正文、签名媒体地址、请求头、真实飞书标识、本机 Obsidian 路径或私人笔记正文。

As local configuration and state, `install.ps1` creates a blank `.env` template and a `.project-root` pointer. Neither file belongs in Git. The installer also downloads declared project dependencies and the pinned Whisper model, but it does not perform Douyin login, Feishu writes, scheduled-task registration, or external LLM calls.

作为本机配置和状态，`install.ps1` 会创建空白 `.env` 模板和 `.project-root` 路径指针；两者都不应提交到 Git。安装器还会下载已声明的项目依赖和固定 Whisper 模型，但不会执行抖音登录、飞书写入、计划任务注册或外部模型调用。

By default, v2.0.2 downloads the pinned public `faster-whisper` `base` model from Hugging Face and then reloads it with `local_files_only=True`. This transfers model artifacts only; it does not upload local media, transcripts, credentials, or configuration. Use `-SkipWhisperModelDownload` to disable this setup-time download.

v2.0.2 默认从 Hugging Face 下载固定 revision 的公开 `faster-whisper base` 模型，再以 `local_files_only=True` 重新加载。该过程只下载模型文件，不上传本地媒体、转写、凭证或配置；可使用 `-SkipWhisperModelDownload` 关闭安装阶段下载。

## Reporting

If you find a vulnerability, do not publish sensitive reproduction data in a public issue. Contact the repository owner privately through the security-reporting channel configured on GitHub. If no private channel is available, open an issue containing only a sanitized summary and ask for a secure contact method.

发现漏洞时，请不要在公开 Issue 中发布敏感复现数据。优先使用 GitHub 仓库配置的私密安全报告渠道；如尚未配置，只提交脱敏摘要并请求安全联系方式。
