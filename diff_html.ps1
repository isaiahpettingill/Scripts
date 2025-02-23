param (
    [string]$File1,
    [string]$File2,
    [string]$OutputFile = "diff.html"
)

if (-not ($File1 -and $File2)) {
    Write-Host "Usage: .\diff_export.ps1 -File1 <path> -File2 <path> [-o <output.html>]"
    exit 1
}

&vim -d $File1 $File2 `
    -c "syntax off" `
    -c "set background=dark" `
    -c "colorscheme default" `
    -c "set wrap" `
    -c "TOhtml" `
    -c "w! $OutputFile" `
    -c "qa!"


Write-Host "Diff exported to $OutputFile in light mode"
