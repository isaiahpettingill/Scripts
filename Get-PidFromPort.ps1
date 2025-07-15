param(
    [Parameter(Mandatory=$true)]
    [int]$Port
)

# Get listening connections for the specified port
$connections = Get-NetTCPConnection -State Listen -LocalPort $Port -ErrorAction SilentlyContinue

if ($connections) {
    # Get the unique Process IDs (PIDs) associated with these connections
    $uniquePids = $connections | Select-Object -ExpandProperty OwningProcess -Unique

    if ($uniquePids) {
        Write-Host "Process(es) listening on port ${Port}:"

        # --- RENAMED LOOP VARIABLE BELOW ---
        # Loop through each unique PID found using a different variable name
        foreach ($processId in $uniquePids) { # Renamed from $pid to $processId
            # Get the process details using the PID
            # Include FileVersionInfo to try and get the Path more reliably
             # --- USE RENAMED VARIABLE BELOW ---
            $processInfo = Get-Process -Id $processId -IncludeUserName -ErrorAction SilentlyContinue # Use $processId here

            if ($processInfo) {
                # Output the PID, Process Name, and full path to the executable
                $processInfo | Select-Object Id, ProcessName, Path # , UserName # Uncomment UserName if needed and running as admin
            } else {
                # Handle cases where the process might have terminated between checks
                 # --- USE RENAMED VARIABLE BELOW ---
                Write-Warning "Could not get details for PID $processId. The process may have stopped." # Use $processId here
            }
        }
    } else {
         Write-Warning "Found listening connection(s) on port $Port, but could not identify the owning process PID."
    }
} else {
    Write-Host "No process found listening on port $Port."
}