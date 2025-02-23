param(
  [Parameter(Mandatory = $true, Position = 0)]
  [string]$UserName
)
$original = git config --get remote.origin.url
if ($original -match '^https://([^@]+)@github\.com/(.+)$') {
  $repoPath = $Matches[2]
} elseif ($original -match '^https://github\.com/(.+)$') {
  $repoPath = $Matches[1]
} else {
  Write-Error "Unsupported URL format: $original"
  exit 1
}
$newUrl = "https://$UserName@github.com/$repoPath"
git remote set-url origin $newUrl
