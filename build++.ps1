if ($args.Count -lt 1) {
    Write-Error "Usage: .\script.ps1 <filename_without_extension>"
    exit 1
}

$file_name = $args[0]
$remainingArgs = @()
if ($args.Count -gt 1) {
    $remainingArgs = $args[1..($args.Count - 1)]
} 

& clang.exe -std=c++17 --target=x86_64-pc-windows-gnu -lc++ -lc++abi -Wall @remainingArgs -o "$file_name.exe" "$file_name.cpp"
