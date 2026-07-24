#!/usr/bin/env python3
from faster_whisper import WhisperModel
from faster_whisper.utils import download_model


MODEL_NAME = "base"
MODEL_REVISION = "ebe41f70d5b6dfa9166e2c581c45c9c0cfc57b66"


def main():
    download_model(MODEL_NAME, revision=MODEL_REVISION)
    print(f"whisper_model_prepared:{MODEL_NAME}@{MODEL_REVISION}")

    WhisperModel(
        MODEL_NAME,
        device="cpu",
        compute_type="int8",
        local_files_only=True,
        revision=MODEL_REVISION,
    )
    print(f"whisper_model_ready:{MODEL_NAME}@{MODEL_REVISION}")


if __name__ == "__main__":
    main()
