param(
    [Parameter(Mandatory = $true)]
    [string]$Version,
    [string]$RootPath = (Split-Path -Parent $PSScriptRoot),
    [switch]$SkipPackage
)

$ErrorActionPreference = 'Stop'

if ($Version -notmatch '^\d+\.\d+\.\d+$') {
    throw 'Version must use semantic version format: major.minor.patch'
}

$root = (Resolve-Path $RootPath).Path
$manifestPath = Join-Path $root 'manifest.json'
$firefoxManifestPath = Join-Path $root 'firefox/manifest.json'
$readmePath = Join-Path $root 'README.md'

if (-not (Test-Path $manifestPath)) {
    throw "manifest.json not found at $manifestPath"
}
if (-not (Test-Path $firefoxManifestPath)) {
    throw "Firefox manifest not found at $firefoxManifestPath"
}
if (-not (Test-Path $readmePath)) {
    throw "README.md not found at $readmePath"
}

$manifestContent = Get-Content -Path $manifestPath -Raw
if (-not [System.Text.RegularExpressions.Regex]::IsMatch($manifestContent, '("version"\s*:\s*")[^"]+("\s*,)')) {
    throw "No match found while updating $manifestPath"
}
$manifestUpdated = [System.Text.RegularExpressions.Regex]::Replace(
    $manifestContent,
    '("version"\s*:\s*")[^"]+("\s*,)',
    ('${1}' + $Version + '${2}'),
    1
)
Set-Content -Path $manifestPath -Value $manifestUpdated

$firefoxManifestContent = Get-Content -Path $firefoxManifestPath -Raw
if (-not [System.Text.RegularExpressions.Regex]::IsMatch($firefoxManifestContent, '("version"\s*:\s*")[^"]+("\s*,)')) {
    throw "No match found while updating $firefoxManifestPath"
}
$firefoxManifestUpdated = [System.Text.RegularExpressions.Regex]::Replace(
    $firefoxManifestContent,
    '("version"\s*:\s*")[^"]+("\s*,)',
    ('${1}' + $Version + '${2}'),
    1
)
Set-Content -Path $firefoxManifestPath -Value $firefoxManifestUpdated

$readmeContent = Get-Content -Path $readmePath -Raw
if (-not [System.Text.RegularExpressions.Regex]::IsMatch($readmeContent, 'Version-\d+\.\d+\.\d+-purple')) {
    throw "No match found while updating $readmePath"
}
$readmeUpdated = [System.Text.RegularExpressions.Regex]::Replace(
    $readmeContent,
    'Version-\d+\.\d+\.\d+-purple',
    ('Version-' + $Version + '-purple'),
    1
)
Set-Content -Path $readmePath -Value $readmeUpdated

Write-Host "Updated Chrome and Firefox manifests and README badge to version $Version"

if (-not $SkipPackage) {
    & (Join-Path $PSScriptRoot 'package-chrome.ps1') -RootPath $root
    & (Join-Path $PSScriptRoot 'package-firefox.ps1') -RootPath $root
}
