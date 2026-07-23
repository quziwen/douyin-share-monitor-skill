[CmdletBinding()]
param(
    [ValidateSet("Codex", "Claude", "Both")]
    [string]$InstallFor = "Codex",
    [string]$ProjectRoot = (Join-Path $env:USERPROFILE "douyin-share"),
    [string]$CodexSkillsRoot = (Join-Path $env:USERPROFILE ".codex\skills"),
    [string]$ClaudeSkillsRoot = (Join-Path $env:USERPROFILE ".claude\skills"),
    [switch]$SkipDependencies,
    [switch]$SkipVerification
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$SourceRepository = "https://github.com/quziwen/douyin-share.git"
$SourceVersion = "v2.0.0"
$InstallerVersion = "v2.0.1"
$SkillName = "douyin-share-monitor"
$SkillSource = Join-Path $PSScriptRoot "skill\$SkillName"
$ProjectRoot = [System.IO.Path]::GetFullPath($ProjectRoot)

function Assert-Command([string]$Name, [string]$InstallHint) {
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "required_command_missing:$Name. $InstallHint"
    }
}

function Invoke-Pnpm([string[]]$Arguments) {
    if (Get-Command "pnpm" -ErrorAction SilentlyContinue) {
        & pnpm @Arguments
    }
    elseif (Get-Command "corepack" -ErrorAction SilentlyContinue) {
        & corepack pnpm @Arguments
    }
    else {
        throw "required_command_missing:pnpm. Install Node.js with Corepack or install pnpm."
    }

    if ($LASTEXITCODE -ne 0) {
        throw "pnpm_failed:$($Arguments -join ' ')"
    }
}

function Test-PythonCandidate([string]$File, [string[]]$Prefix) {
    $previousErrorPreference = $ErrorActionPreference
    try {
        $ErrorActionPreference = "SilentlyContinue"
        $version = & $File @Prefix -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>$null
        $candidateExitCode = $LASTEXITCODE
    }
    finally {
        $ErrorActionPreference = $previousErrorPreference
    }
    if ($candidateExitCode -ne 0) {
        return $false
    }
    return $version -match '^3\.(9|10|11|12|13)$'
}

function Resolve-PythonLauncher {
    if (Get-Command "uv" -ErrorAction SilentlyContinue) {
        return @{ Mode = "uv"; File = "uv"; Prefix = @() }
    }

    if (Get-Command "py" -ErrorAction SilentlyContinue) {
        foreach ($version in @("3.11", "3.12", "3.13", "3.10", "3.9")) {
            $prefix = @("-$version")
            if (Test-PythonCandidate "py" $prefix) {
                return @{ Mode = "python"; File = "py"; Prefix = $prefix }
            }
        }
    }

    if ((Get-Command "python" -ErrorAction SilentlyContinue) -and
        (Test-PythonCandidate "python" @())) {
        return @{ Mode = "python"; File = "python"; Prefix = @() }
    }

    throw "supported_python_missing. Install 64-bit Python 3.9-3.13 or uv; Python 3.14 is not supported by the pinned transcription dependencies."
}

function Install-SkillCopy([string]$SkillsRoot) {
    $target = Join-Path $SkillsRoot $SkillName
    New-Item -ItemType Directory -Path $target -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $SkillSource "SKILL.md") -Destination (Join-Path $target "SKILL.md") -Force
    $agentsSource = Join-Path $SkillSource "agents"
    if (Test-Path -LiteralPath $agentsSource) {
        $agentsTarget = Join-Path $target "agents"
        New-Item -ItemType Directory -Path $agentsTarget -Force | Out-Null
        Copy-Item -LiteralPath (Join-Path $agentsSource "openai.yaml") -Destination (Join-Path $agentsTarget "openai.yaml") -Force
    }
    Set-Content -LiteralPath (Join-Path $target ".project-root") -Value $ProjectRoot -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $target ".source-version") -Value $SourceVersion -Encoding ascii
    Write-Output "skill_installed:$target"
}

Assert-Command "git" "Install Git for Windows, then rerun this script."

$reuseProject = $false
if (Test-Path -LiteralPath $ProjectRoot) {
    $existing = @(Get-ChildItem -LiteralPath $ProjectRoot -Force -ErrorAction SilentlyContinue)
    if ($existing.Count -gt 0) {
        $gitDir = Join-Path $ProjectRoot ".git"
        if (-not (Test-Path -LiteralPath $gitDir)) {
            throw "project_target_not_empty:$ProjectRoot. Choose an empty -ProjectRoot; the installer will not overwrite an unrelated directory."
        }

        $remoteUrl = (& git -C $ProjectRoot remote get-url origin).Trim()
        $headCommit = (& git -C $ProjectRoot rev-parse HEAD).Trim()
        $tagCommit = (& git -C $ProjectRoot rev-list -n 1 $SourceVersion).Trim()
        $trackedChanges = @(& git -C $ProjectRoot status --porcelain --untracked-files=no)
        if ($LASTEXITCODE -ne 0 -or
            $remoteUrl.TrimEnd("/") -ne $SourceRepository.TrimEnd("/") -or
            $headCommit -ne $tagCommit -or
            $trackedChanges.Count -gt 0) {
            throw "existing_checkout_not_reusable:$ProjectRoot. The installer only resumes a clean checkout of $SourceRepository@$SourceVersion."
        }
        $reuseProject = $true
        Write-Output "source_checkout_reused:$ProjectRoot"
    }
}
else {
    New-Item -ItemType Directory -Path $ProjectRoot -Force | Out-Null
}

if (-not $reuseProject) {
    & git -c advice.detachedHead=false clone --branch $SourceVersion --depth 1 $SourceRepository $ProjectRoot
    if ($LASTEXITCODE -ne 0) {
        throw "source_clone_failed:$SourceRepository@$SourceVersion"
    }
}

$envExample = Join-Path $ProjectRoot ".env.example"
$envFile = Join-Path $ProjectRoot ".env"
if ((Test-Path -LiteralPath $envExample) -and -not (Test-Path -LiteralPath $envFile)) {
    Copy-Item -LiteralPath $envExample -Destination $envFile
    Write-Output "local_env_template_created:$envFile"
}

if (-not $SkipDependencies) {
    Assert-Command "node" "Install the current Node.js LTS release, then rerun this script."

    Push-Location $ProjectRoot
    try {
        Invoke-Pnpm @("install", "--frozen-lockfile")
        Invoke-Pnpm @("exec", "playwright", "install", "chromium")

        $python = Resolve-PythonLauncher
        $venvPath = Join-Path $ProjectRoot ".venv"
        $venvPython = Join-Path $venvPath "Scripts\python.exe"
        $reuseVenv = $false
        if (Test-Path -LiteralPath $venvPython) {
            $venvVersion = & $venvPython -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>$null
            $reuseVenv = $LASTEXITCODE -eq 0 -and $venvVersion -match '^3\.(9|10|11|12|13)$'
            if ($reuseVenv) {
                $pipAvailable = & $venvPython -c "import importlib.util; print('yes' if importlib.util.find_spec('pip') else 'no')"
                $reuseVenv = $LASTEXITCODE -eq 0 -and $pipAvailable -eq "yes"
            }
        }

        if ((Test-Path -LiteralPath $venvPath) -and -not $reuseVenv) {
            $backupName = "douyin-share-venv-incompatible-$([DateTime]::UtcNow.ToString('yyyyMMddHHmmss'))"
            $backupPath = Join-Path ([System.IO.Path]::GetTempPath()) $backupName
            Move-Item -LiteralPath $venvPath -Destination $backupPath
            Write-Output "incompatible_venv_moved:$backupPath"
        }

        if ($reuseVenv) {
            Write-Output "python_venv_reused:$venvVersion"
        }
        elseif ($python.Mode -eq "uv") {
            & $python.File venv --python 3.11 --seed $venvPath
        }
        else {
            & $python.File @($python.Prefix) -m venv $venvPath
        }
        if ($LASTEXITCODE -ne 0) {
            throw "python_venv_failed"
        }

        $requirements = Join-Path $ProjectRoot "requirements.txt"
        if ($python.Mode -eq "uv") {
            $previousUvTimeout = $env:UV_HTTP_TIMEOUT
            $previousUvRetries = $env:UV_HTTP_RETRIES
            $previousUvDownloads = $env:UV_CONCURRENT_DOWNLOADS
            try {
                $env:UV_HTTP_TIMEOUT = "300"
                $env:UV_HTTP_RETRIES = "5"
                $env:UV_CONCURRENT_DOWNLOADS = "2"
                & $python.File pip install --python $venvPython -r $requirements
            }
            finally {
                $env:UV_HTTP_TIMEOUT = $previousUvTimeout
                $env:UV_HTTP_RETRIES = $previousUvRetries
                $env:UV_CONCURRENT_DOWNLOADS = $previousUvDownloads
            }
        }
        else {
            & $venvPython -m pip install --upgrade pip --timeout 120 --retries 5
            if ($LASTEXITCODE -ne 0) {
                throw "pip_upgrade_failed"
            }
            & $venvPython -m pip install -r $requirements --timeout 120 --retries 5
        }
        if ($LASTEXITCODE -ne 0) {
            throw "python_dependencies_failed"
        }

        if (-not (Get-Command "ffmpeg" -ErrorAction SilentlyContinue) -or
            -not (Get-Command "ffprobe" -ErrorAction SilentlyContinue)) {
            throw "required_command_missing:ffmpeg_or_ffprobe. Install FFmpeg and ensure both commands are on PATH."
        }

        if (-not $SkipVerification) {
            Invoke-Pnpm @("typecheck")
            Invoke-Pnpm @("test")
            & $venvPython -c "import faster_whisper; print('faster_whisper_ready')"
            if ($LASTEXITCODE -ne 0) {
                throw "faster_whisper_verification_failed"
            }
        }
    }
    finally {
        Pop-Location
    }
}

if ($InstallFor -in @("Codex", "Both")) {
    Install-SkillCopy $CodexSkillsRoot
}
if ($InstallFor -in @("Claude", "Both")) {
    Install-SkillCopy $ClaudeSkillsRoot
}

Write-Output "install_complete:$InstallerVersion"
Write-Output "source_version:$SourceVersion"
Write-Output "project_root:$ProjectRoot"
Write-Output "next_step:edit_local_env_and_complete_visible_douyin_login"
