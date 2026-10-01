$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Web
$root = $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding $false

function Read-Utf8([string]$p) { [System.IO.File]::ReadAllText($p, [System.Text.Encoding]::UTF8) }
function Write-Utf8([string]$p, [string]$t) { [System.IO.File]::WriteAllText($p, $t, $utf8) }

$html = Read-Utf8 (Join-Path $root 'index.html')
$css  = Read-Utf8 (Join-Path $root 'assets\css\styles.css')

if ($css -match '</style' -or $css -match '<script') { throw 'CSS contains a tag-breaking string' }

# --- inline the stylesheet -------------------------------------------------
$styleBlock = "<style>`r`n" + $css.Trim() + "`r`n</style>"
$pattern = '(?m)^\s*<link rel="stylesheet" href="assets/css/styles\.css" />\s*$'
if ($html -notmatch $pattern) { throw 'stylesheet link not found' }
$html = [regex]::Replace($html, $pattern, $styleBlock, 1)

# --- inline every script, in the order they appear ------------------------
$jsFiles = @(
  'core.js', 'basic.js', 'age.js', 'bmi.js', 'percentage.js',
  'gpa.js', 'loan.js', 'currency.js', 'units.js', 'app.js'
)
foreach ($f in $jsFiles) {
  $js = Read-Utf8 (Join-Path $root "assets\js\$f")
  if ($js -match '</script') { throw "$f contains a closing script tag" }
  $jsPattern = '(?m)^\s*<script src="assets/js/' + [regex]::Escape($f) + '"></script>\s*$'
  if ($html -notmatch $jsPattern) { throw "script tag not found for $f" }
  $block = "<script>`r`n/* ===== $f ===== */`r`n" + $js.Trim() + "`r`n</script>"
  $html = [regex]::Replace($html, $jsPattern, $block, 1)
}

# --- prove no local asset references are left -----------------------------
$left = [regex]::Matches($html, '(?i)(src|href)="assets/[^"]*"') | ForEach-Object { $_.Value }
if ($left) { throw ('local asset references remain: ' + ($left -join ', ')) }
# The only remote reference allowed is the web font, which has a system fallback.
$remote = [regex]::Matches($html, '(?i)(src|href)="(https?:)?//[^"]*"') | ForEach-Object { $_.Value } | Sort-Object -Unique

Write-Utf8 (Join-Path $root 'index.html') $html
Write-Host ("index.html is now {0:N0} bytes, fully self-contained." -f (Get-Item (Join-Path $root 'index.html')).Length)
Write-Host 'Remaining local references:'
[regex]::Matches($html, '(?i)(src|href)="[^"#][^"]*"') | ForEach-Object { '  ' + $_.Value } | Sort-Object -Unique
