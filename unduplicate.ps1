param (
    [string]$InputPath  = "input.txt",
    [string]$OutputPath = "output.txt"
)

if (-not (Test-Path $InputPath)) {
    Write-Host "File not found: $InputPath" -ForegroundColor Red
    exit 1
}

# Read whole file (keeps CR/LF)
$content = Get-Content $InputPath -Raw

$sb   = [System.Text.StringBuilder]::new()
$prev = [char]0                            # sentinel

foreach ($c in $content.ToCharArray()) {   # deduplicate consecutive chars
    if ($c -ne $prev) { [void]$sb.Append($c) }
    $prev = $c
}

# also collapse exactly one extra blank line  (CRLFCRLF → CRLF)
$result = ($sb.ToString()) -replace '(\r\n){2}', "`r`n"

$result | Set-Content $OutputPath -Encoding UTF8 -NoNewline
Write-Host "Cleaned file saved to $OutputPath" -ForegroundColor Green
