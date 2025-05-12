param (
    [string]$InputPath  = "input.txt",
    [string]$OutputPath = "output.txt"
)

if (-not (Test-Path $InputPath)) {
    Write-Host "File not found: $InputPath" -ForegroundColor Red
    exit 1
}

$content = Get-Content $InputPath -Raw

$sb   = [System.Text.StringBuilder]::new()
$prev = [char]0

foreach ($c in $content.ToCharArray()) {
    if ($c -ne $prev) {
        [void]$sb.Append($c)
    }
    $prev = $c
}

$clean = ($sb.ToString()) -replace '(\r?\n)+', "`r`n"

$clean | Set-Content $OutputPath -Encoding UTF8 -NoNewline
Write-Host "Cleaned file saved to $OutputPath" -ForegroundColor Green
