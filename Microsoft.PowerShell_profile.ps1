# ----------------------------------------------------
# Linux-style color prompt for Windows PowerShell 7
# ----------------------------------------------------

# ANSI colors
$esc = [char]27
$ColorUserHost = "${esc}[32m"   # green
$ColorCwd      = "${esc}[36m"   # cyan
$ColorGit      = "${esc}[35m"   # magenta
$ColorSymbol   = "${esc}[33m"   # yellow
$ColorReset    = "${esc}[0m"

function Get-ChildItemEx {
    param(
        [string[]]$Path = ".",
        [string[]]$Exclude = ".*"
    )
    Get-ChildItem -Path $Path -Exclude $Exclude
}



# Linux aliases
Set-Alias ll Get-ChildItemEx
Set-Alias la Get-ChildItem -Scope Global
Set-Alias grep Select-String -Scope Global

# cat and rm in Windows
function cat { param($file) Get-Content $file }
function rm { param($file) Remove-Item $file -Force }
function touch { param($file) New-Item -ItemType File -Path $file -Force }

# Prompt function
function prompt {
    $user = [System.Environment]::UserName
    $hostName = [System.Environment]::MachineName
    $userHost = "[$user@$hostName]-"

    # shortcut
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

    # colored prompt string
    $promptString = ""
    $promptString += "$ColorUserHost$userHost$ColorReset"
    $promptString += "$ColorCwd[$cwd$gitBranch]$ColorReset"
    $promptString += "$ColorSymbol λ$ColorReset "

    return $promptString
}
