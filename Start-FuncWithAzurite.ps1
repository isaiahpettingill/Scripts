
$azuritePorts = @(10000, 10001, 10002)
$azuriteRunning = $false

Write-Host "Checking if Azurite is running on ports $($azuritePorts -join ', ')..."

foreach ($port in $azuritePorts) {
    $connection = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
    if ($null -ne $connection) {
        Write-Host "Detected process listening on port $port. Assuming Azurite is running."
        $azuriteRunning = $true
        break
    }
}

if (-not $azuriteRunning) {
    Write-Host "Azurite not detected. Starting Azurite in a new window..."
    try {
        Start-Process pwsh -ArgumentList "-Command", "azurite" -ErrorAction Stop
        Write-Host "Azurite started in a new window. Allow a few seconds for it to initialize."
        Start-Sleep -Seconds 1
    } catch {
        Write-Error "Failed to start Azurite. Please ensure Azurite is installed and accessible in your PATH."
        Write-Error $_.Exception.Message
        exit 1 # Optional exit
    }
} else {
    Write-Host "Azurite appears to be running."
}

Write-Host "Starting Azure Functions host..."

func start

Write-Host "Azure Functions host stopped."
