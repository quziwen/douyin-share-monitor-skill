# Source and attribution

The runnable source used by this Skill is published at:

- Source fork: <https://github.com/quziwen/douyin-share>
- Pinned release: `v2.0.0`
- Upstream project: <https://github.com/DannyZZ2/douyin-share>

The source repository is a GitHub fork so that the original author, commit history, and upstream relationship remain visible.

The upstream repository does not currently declare an open-source license. The GitHub fork relationship does not grant additional redistribution or relicensing rights. This repository does not claim ownership of the upstream source and does not add a license on its behalf.

本 Skill 使用的可运行源码发布在 `quziwen/douyin-share`，并通过 GitHub fork 保留原作者、提交历史和上下游关系。上游目前未声明开源许可证；本仓库不会替原作者授予额外的复制、再分发或重新许可权利。

## Whisper model

The v2.0.2 installer prepares [`Systran/faster-whisper-base`](https://huggingface.co/Systran/faster-whisper-base) at revision `ebe41f70d5b6dfa9166e2c581c45c9c0cfc57b66`. The model card identifies it as an MIT-licensed CTranslate2 conversion of `openai/whisper-base`. Model artifacts are downloaded to the user's local Hugging Face cache and are not committed to this repository.

v2.0.2 安装器固定准备 `Systran/faster-whisper-base` revision `ebe41f70d5b6dfa9166e2c581c45c9c0cfc57b66`。模型卡将其标注为 MIT 许可的 `openai/whisper-base` CTranslate2 转换版本；模型文件只下载到用户本机 Hugging Face 缓存，不进入本仓库。
