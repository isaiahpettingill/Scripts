
param(
    [Parameter(Mandatory=$true)]
    [string]$FunctionName,

    [Parameter(Mandatory=$true)]
    [string]$MasterKey,

    [Parameter(Mandatory=$false)]
    [int]$Port = 7071,

    [Parameter(Mandatory=$false)]
    [string]$InputBody = '{}'
)

$uri = "http://localhost:$Port/admin/functions/$FunctionName"

$headers = @{
    "x-functions-key" = $MasterKey
    "Content-Type" = "application/json"
}

try {
    Write-Verbose "Triggering function '$FunctionName' at $uri"
    Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $InputBody -ErrorAction Stop
    Write-Host "Successfully sent trigger request to function '$FunctionName'."
}
catch {
    Write-Error "Failed to trigger function '$FunctionName'. URI: $uri. Error: $($_.Exception.Message)"
    # Throw again to ensure script exit code indicates failure if needed
    throw $_
}
