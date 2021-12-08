# user PowerShell profile

$p = [Environment]::GetEnvironmentVariable("PSModulePath")
$p += ";D:\Nous\Documents\WindowsPowerShell\Modules"
[Environment]::SetEnvironmentVariable("PSModulePath",$p)

New-Alias g git
New-Alias vi nvim

. _rg.ps1
. _fd.ps1

# https://rkeithhill.wordpress.com/2009/08/03/effective-powershell-item-16-dealing-with-errors/
function CheckLastExitCode {
    param ([int[]]$SuccessCodes = @(0), [scriptblock]$CleanupScript=$null)

    if ($SuccessCodes -notcontains $LastExitCode) {
        if ($CleanupScript) {
            "Executing cleanup script: $CleanupScript"
            &$CleanupScript
        }
        $msg = @"
EXE RETURNED EXIT CODE $LastExitCode
CALLSTACK:$(Get-PSCallStack | Out-String)
"@
        throw $msg
    }
}

# https://github.com/PowerShell/PowerShell/issues/2905
Update-FormatData -PrependPath (Join-Path (Get-Item $PROFILE).Directory MatchInfo.Format.ps1xml)

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# starship
Invoke-Expression (&starship init powershell)
