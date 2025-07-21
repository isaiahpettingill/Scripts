<#
.SYNOPSIS
combine markdown files into one file, separated by a delimiter.

.DESCRIPTION
recursively scans a directory for *.md files, orders them by path, and writes them
to a single output file with the chosen delimiter placed between each file’s text.

.PARAMETER Path
root directory to search. default is the current directory.

.PARAMETER OutputFile
file to create or overwrite with the combined result. default is "combined.md"
in the current directory.

.PARAMETER Delimiter
string inserted between files. default is "---"

.EXAMPLE
.\Combine-Markdown.ps1 -Path "c:\docs" -OutputFile "all.md" -Delimiter "---"
#>

[CmdletBinding()]
param(
    [string]$Path       = ".",
    [string]$OutputFile = "combined.md",
    [string]$Delimiter  = "---"
)

try {
    if (-not (Test-Path -Path $Path -PathType Container)) {
        throw "path '$Path' does not exist or is not a directory."
    }

    $markdownFiles = Get-ChildItem -Path $Path -Filter *.md* -Recurse -File | Sort-Object FullName
                        

    if (-not $markdownFiles) {
        throw "no markdown files found under '$Path'."
    }

    # read each file's content (raw keeps original newlines)
    $content = foreach ($file in $markdownFiles) {
        Get-Content -Path $file.FullName -Raw
    }

    # build combined text
    $delimiterWithNL = "`n$Delimiter`n"
    ($content -join $delimiterWithNL) |
        Set-Content -Path $OutputFile -Encoding utf8

    Write-Host "combined $($markdownFiles.Count) files into '$OutputFile'."
}
catch {
    Write-Error $_.Exception.Message
    exit 1
}
