
<#
.SYNOPSIS
    Starts a SQL Server LocalDB instance and connects to it using sqlcmd.

.DESCRIPTION
    This script ensures a specified LocalDB instance is running, retrieves its
    dynamic named pipe, and then opens an interactive sqlcmd session.

    It is designed to be more reliable than using the standard '(localdb)\...'
    alias, as it connects directly to the instance's active pipe.

.PARAMETER InstanceName
    The name of the SQL Server LocalDB instance you want to connect to.
    The default is 'MSSQLLocalDB', which is the standard instance name.

.EXAMPLE
    .\Connect-LocalDB.ps1
    # Starts and connects to the default 'MSSQLLocalDB' instance.

.EXAMPLE
    .\Connect-LocalDB.ps1 -InstanceName "MyProjectDB"
    # Starts and connects to a custom instance named 'MyProjectDB'.
#>
param (
    [string]$InstanceName = "MSSQLLocalDB"
)

Write-Host "▶️ Attempting to start LocalDB instance: '$InstanceName'..."

# Step 1: Start the LocalDB instance.
# This command ensures the instance is running. If it's already running,
# it does nothing. If it's stopped, it starts it.
SqlLocalDB.exe start $InstanceName
$startExitCode = $LASTEXITCODE

if ($startExitCode -ne 0) {
    Write-Error "❌ Failed to start LocalDB instance '$InstanceName'. Please check if it is installed correctly."
    # Exit the script if starting fails.
    return
}

Write-Host "✅ Instance '$InstanceName' is running."
Write-Host "▶️ Retrieving connection details..."

# Step 2: Get the instance information, which includes the named pipe.
# We execute the command and capture its output as an array of strings.
$infoOutput = SqlLocalDB.exe info $InstanceName

# Step 3: Find the instance pipe name from the output.
# We search the output for the line that contains "Instance pipe name:".
$pipeLine = $infoOutput | Where-Object { $_ -match "Instance pipe name:" }

if ($null -eq $pipeLine) {
    Write-Error "❌ Could not find 'Instance pipe name' for '$InstanceName'. Cannot connect."
    return
}

# Step 4: Extract the pipe path.
# The format is "Instance pipe name: np:\\.\pipe\LOCALDB#XXXX\tsql\query"
# We split the string at the colon and trim whitespace to get the clean path.
$pipeName = ($pipeLine -split ':', 2)[1].Trim()

if ([string]::IsNullOrWhiteSpace($pipeName)) {
    Write-Error "❌ Extracted pipe name is empty. Cannot connect."
    return
}

Write-Host "✅ Found pipe: $pipeName"
Write-Host "🚀 Launching sqlcmd..."

# Step 5: Connect using sqlcmd with the direct pipe name and trusted connection (-E).
# Using the direct pipe is more reliable than the '(localdb)\...' alias.
# We use Start-Process to launch sqlcmd in the current window.
Start-Process sqlcmd -ArgumentList "-S `"$pipeName`" -E" -NoNewWindow -Wait
