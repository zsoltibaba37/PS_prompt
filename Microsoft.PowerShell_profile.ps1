# ----------------------------
# Linux-style színes prompt Windows PowerShell 7-hez
# ----------------------------

# ANSI színek
$esc = [char]27
$ColorUserHost = "${esc}[32m"   # zöld
$ColorCwd      = "${esc}[36m"   # cyan
$ColorGit      = "${esc}[35m"   # magenta
$ColorSymbol   = "${esc}[33m"   # sárga
$ColorReset    = "${esc}[0m"

# Linuxos aliasok
Set-Alias ll Get-ChildItem -Scope Global
Set-Alias la "Get-ChildItem -Force" -Scope Global
Set-Alias grep Select-String -Scope Global

# cat és rm Windows-ban
function cat { param($file) Get-Content $file }
function rm { param($file) Remove-Item $file -Force }
function touch { param($file) New-Item -ItemType File -Path $file -Force }

# Prompt függvény
function prompt {
    $user = [System.Environment]::UserName
    $hostName = [System.Environment]::MachineName
    $userHost = "[$user@$hostName]-"

    # rövidített útvonal
    $cwd = (Get-Location).Path -replace [regex]::Escape($env:USERPROFILE), '~'

    # git branch
    $gitBranch = ""
    if (Get-Command git -ErrorAction SilentlyContinue) {
        try {
            $branch = git rev-parse --abbrev-ref HEAD 2>$null
            if ($branch) {
                $gitStatus = git status --porcelain 2>$null
                $branchColor = if ($gitStatus) { "${esc}[31m" } else { $ColorGit } # piros ha dirty
                $gitBranch = " ($branch)"
            }
        } catch {}
    }

    # színes prompt string
    $promptString = ""
    $promptString += "$ColorUserHost$userHost$ColorReset"
    $promptString += "$ColorCwd[$cwd$gitBranch]$ColorReset"
    $promptString += "$ColorSymbol λ$ColorReset "

    return $promptString
}
