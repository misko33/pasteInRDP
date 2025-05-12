param (
    [string]$InputPath = "input.txt",
    [string]$OutputPath = "output.txt"
)

if (-not (Test-Path $InputPath)) {
    Write-Host "File not found: $InputPath" -ForegroundColor Red
    exit 1
}

$lines = Get-Content $InputPath
$cleanedLines = @()

foreach ($line in $lines) {
    $output = ""
    $prev = ""

    foreach ($char in $line.ToCharArray()) {
        if ($char -ne $prev) {
            $output += $char
        }
        $prev = $char
    }

    $cleanedLines += $output
}

$cleanedLines | Set-Content $OutputPath -Encoding UTF8
Write-Host "Cleaned file saved to $OutputPath" -ForegroundColor Green
