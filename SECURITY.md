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

`install.ps1` creates only a blank local `.env` template and a local `.project-root` pointer. Neither file belongs in Git. The installer does not perform Douyin login, Feishu writes, scheduled-task registration, or external LLM calls.

`install.ps1` 只会在本机创建空白 `.env` 模板和 `.project-root` 路径指针；两者都不应提交到 Git。安装器不会执行抖音登录、飞书写入、计划任务注册或外部模型调用。

## Reporting

If you find a vulnerability, do not publish sensitive reproduction data in a public issue. Contact the repository owner privately through the security-reporting channel configured on GitHub. If no private channel is available, open an issue containing only a sanitized summary and ask for a secure contact method.

发现漏洞时，请不要在公开 Issue 中发布敏感复现数据。优先使用 GitHub 仓库配置的私密安全报告渠道；如尚未配置，只提交脱敏摘要并请求安全联系方式。
