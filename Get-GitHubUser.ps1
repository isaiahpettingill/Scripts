param()
$original = git config --get remote.origin.url
if ($original -match '^https://([^@]+)@github\.com/(.+)$') {
  Write-Output $Matches[1]
} elseif ($original -match '^https://github\.com/(.+)$') {
  Write-Error "No username set in remote URL"
  exit 1
} else {
  Write-Error "Unsupported URL format: $original"
  exit 1
}
