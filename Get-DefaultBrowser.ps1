$defaultProgId = (Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice' -ErrorAction SilentlyContinue).ProgId

$browserMapping = @{
    'FirefoxURL-308046B0AF4A39CB'     = 'Firefox (Regular)'
    'FirefoxURL-CA9422711AE1A81C'     = 'Firefox Developer Edition'
    'ChromiumHTM.6XOGTEX4QNXW2G5A3KYLBVXGS4' = 'Chromium'
    'ChromeSSHTM.6XOGTEX4QNXW2G5A3KYLBVXGS4' = 'Google Chrome Canary'
    'VivaldiHTM.6XOGTEX4QNXW2G5A3KYLBVXGS4'  = 'Vivaldi'
    'MSEdgeHTM'                        = 'Microsoft Edge'
}

$browserName = $browserMapping[$defaultProgId] ?? "Unknown ($defaultProgId)"

Write-Output "Current Default Browser: $browserName"
