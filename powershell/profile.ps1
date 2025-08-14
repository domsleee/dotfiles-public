
function ForceRemoveAlias {
    Param(
        [Parameter(Mandatory = $true)][string]$alias
    )
    If (Test-Path Alias:$alias) {
        Remove-Item Alias:$alias -Force
    }
}

ForceRemoveAlias curl
ForceRemoveAlias gl
ForceRemoveAlias gls
ForceRemoveAlias gp
ForceRemoveAlias gs
ForceRemoveAlias gc
ForceRemoveAlias ga
ForceRemoveAlias gm
ForceRemoveAlias pwd
ForceRemoveAlias ls
New-Alias grep rg
New-Alias open ii
New-Alias find fd
function pwd() { $(Get-Location).Path }
function gb { git branch $args }
function gco { git checkout $args }
function gd { git diff $args }
function gds { git diff --stat=120 $args }

function gc { git commit $args }
function gs { git status --stat=120 }
function gl { git pull $args }
function gls { git submodule update --init --recursive $args }
function gph { git push -u origin $(git rev-parse --abbrev-ref HEAD) $args }
function gp { git push $args }
function gll { git pull origin $(git rev-parse --abbrev-ref HEAD) }
function gaa { git add -A }
function ga { git add $args }
function gm { git merge $args }
function glg { git log --pretty=oneline $args }
function gcot {
    Param($branch)
    git remote set-branches --add origin $branch
    git fetch origin $branch
    git checkout $branch
}

function which { (Get-Command $args).Source }

# $env:TABCOMPLETE_FILE = "C:\Users\dominic.slee\git\posh-tabcomplete\resource\completions.nu"
# Set-PSReadLineKeyHandler -Chord Ctrl+Shift+r ForwardSearchHistory
Set-PSReadLineKeyHandler -Chord Ctrl+. -Function ForwardChar
Set-PSReadLineKeyHandler -Key Tab MenuComplete
Set-PSReadlineKeyHandler -Chord Ctrl+d -Function DeleteCharOrExit

# EXA
function l { eza --all --no-git --group-directories-first --time-style relative --classify @args }
function ll { l --no-permissions --long -s modified @args }
function ls { lsd --long --blocks size,date,name --date relative -A -tr --group-dirs first --size=short --permission=disable -F @args }
function lls { l --long --header -s size @args }

function Invoke-PoshFzfRedrawLastLineOfPrompt {
    Write-Output "`e[1;32m$([char]0x276F)"
}
$commands = @(
    "posh-tabcomplete init",
    "posh-fzf init",
    'pwsh -NoProfile -c Write-Host `$env:LS_COLORS = `"$(vivid generate snazzy)`"',
    # 'pwsh -NoProfile -c Write-Host `$env:node21 = `"$(nvs which 21)`"',
    "starship init powershell --print-full-init",
    "zoxide init --cmd cd powershell"
)
Invoke-Expression (& { (posh-invoker print -- @commands | Out-String) })

function gitsdk() {
    & C:\git-sdk-64\msys2_shell.cmd -defterm -here -no-start -mingw64
}


# $env:LS_COLORS = "$(vivid generate snazzy)"

# Alternative
# Import-Module ~\git\posh-git\src\posh-git.psd1 -arg 0,0,1
# Import-Module "$HOME\scoop\apps\psfzf\current\PSFzf.psm1"
# Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
# Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

Set-PSReadLineKeyHandler -Key 'Ctrl+t' -ScriptBlock { Invoke-PoshFzfSelectItems }
Set-PSReadLineKeyHandler -Key 'Alt+c' -ScriptBlock { Invoke-PoshFzfChangeDirectory }
Set-PSReadLineKeyHandler -Key 'Ctrl+r' -ScriptBlock { Invoke-PoshFzfSelectHistory }
Set-PSReadLineKeyHandler -Key 'Ctrl+b' -ScriptBlock {
    $branch = git branch | Invoke-PoshFzfStartProcess -FileName "fzf" -Arguments @("--height=45%") -HeightRowsOrPercent "45%"
    if ($branch) {
        $branch = $branch.Replace("*", "").Trim()
        [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
        Invoke-PoshFzfInsertUtf8("git checkout '$branch'")
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
}
Set-PSReadLineKeyHandler -Key 'Ctrl+shift+z' -ScriptBlock {
    # 45% height comes from: https://github.com/ajeetdsouza/zoxide/blob/a624ceef54a31de2d0624e9eb14ce65024cc9e79/src/cmd/query.rs#L92
    $fzfSelection = Invoke-PoshFzfStartProcess -FileName "zoxide" -Arguments @("query", "-i") -HeightRowsOrPercent "45%"
    if ($fzfSelection) {
        [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
        Invoke-PoshFzfInsertUtf8("cd $fzfSelection")
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
}
Set-PSReadLineKeyHandler -Key 'Ctrl+shift+k' -ScriptBlock {
    $task = tasklist /nh | Sort-Object | Invoke-PoshFzfStartProcess -FileName "fzf" -Arguments @("--height=45%") -HeightRowsOrPercent "45%"
    if ($task) {
        $task = $task.Split(" ")[0].Trim()
        [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
        Invoke-PoshFzfInsertUtf8("taskkill /f /im $task")
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
}

function gcob {
    $branch = (git branch | fzf --height=45%)
    if ($branch) {
        gco $branch.Trim()
    }
}

# STARSHIP
$env:STARSHIP_CONFIG = [IO.Path]::Combine($PSScriptRoot, "../config/starship.toml")
$global:STARSHIP_FIRST_RENDER = $true
function Invoke-Starship-PreCommand {
    if ($global:STARSHIP_FIRST_RENDER -eq $true) {
        $global:STARSHIP_FIRST_RENDER = $false
    }
    elseif ($host.UI.RawUI.CursorPosition.Y -ne 0) {
        Write-Host -NoNewline "`n"
        # $host.ui.Write("`n")
    }
}

function Profile([string] $script) {
    pwsh -NoProfile {
        param($script)
        Import-Module ~\git\PSProfiler\src\PSProfiler.psd1
        Measure-Script -HumanReadable -Path $script
    } -args $script
}

$global:OutputEncoding = [Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
