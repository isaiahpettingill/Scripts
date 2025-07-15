Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinAPI {
    [DllImport("user32.dll")]
    public static extern bool PostMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);
    public const int WM_CLOSE = 0x0010;
}
"@

$excludedApps = @(
    'explorer',
    'ShellExperienceHost',
    'SearchHost',
    'StartMenuExperienceHost',
    'Widgets',
    'WindowsTerminal',
    'wt',
    'cmd',
    'powershell',
    'pwsh'
)

Get-Process | Where-Object {
    $_.MainWindowHandle -ne 0 -and
    $excludedApps -notcontains $_.ProcessName
} | ForEach-Object {
    [WinAPI]::PostMessage($_.MainWindowHandle, [WinAPI]::WM_CLOSE, [IntPtr]::Zero, [IntPtr]::Zero) | Out-Null
}
