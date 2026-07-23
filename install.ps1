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

function Resolve-PythonLauncher {
    if (Get-Command "py" -ErrorAction SilentlyContinue) {
        return @{ File = "py"; Prefix = @("-3") }
    }
    if (Get-Command "python" -ErrorAction SilentlyContinue) {
        return @{ File = "python"; Prefix = @() }
    }
    throw "required_command_missing:python. Install a supported 64-bit Python 3 runtime."
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

if (Test-Path -LiteralPath $ProjectRoot) {
    $existing = @(Get-ChildItem -LiteralPath $ProjectRoot -Force -ErrorAction SilentlyContinue)
    if ($existing.Count -gt 0) {
        throw "project_target_not_empty:$ProjectRoot. Choose an empty -ProjectRoot; the installer will not overwrite an existing checkout."
    }
}
else {
    New-Item -ItemType Directory -Path $ProjectRoot -Force | Out-Null
}

& git clone --branch $SourceVersion --depth 1 $SourceRepository $ProjectRoot
if ($LASTEXITCODE -ne 0) {
    throw "source_clone_failed:$SourceRepository@$SourceVersion"
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
        & $python.File @($python.Prefix) -m venv (Join-Path $ProjectRoot ".venv")
        if ($LASTEXITCODE -ne 0) {
            throw "python_venv_failed"
        }

        $venvPython = Join-Path $ProjectRoot ".venv\Scripts\python.exe"
        & $venvPython -m pip install --upgrade pip
        if ($LASTEXITCODE -ne 0) {
            throw "pip_upgrade_failed"
        }
        & $venvPython -m pip install -r (Join-Path $ProjectRoot "requirements.txt")
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

Write-Output "install_complete:$SourceVersion"
Write-Output "project_root:$ProjectRoot"
Write-Output "next_step:edit_local_env_and_complete_visible_douyin_login"
