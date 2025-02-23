$PATH_TO_IERL = "D:\source\ierl"
$file_name = $args[0]
$remainingArgs = @()
if ($args.Count -gt 1) {
    $remainingArgs = $args[0..($args.Count - 1)]
} 

Write-Output @remainingArgs

&escript $PATH_TO_IERL @remainingArgs