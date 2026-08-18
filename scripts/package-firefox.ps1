param(
    [string]$RootPath = (Split-Path -Parent $PSScriptRoot),
    [string]$DistPath,
    [switch]$WriteGitHubOutput
)

$ErrorActionPreference = 'Stop'

$root = (Resolve-Path $RootPath).Path
if (-not $DistPath) {
    $DistPath = Join-Path $root 'dist'
}

$manifestPath = Join-Path $root 'manifest.json'
$firefoxManifestPath = Join-Path $root 'firefox/manifest.json'
foreach ($path in @($manifestPath, $firefoxManifestPath)) {
    if (-not (Test-Path $path)) {
        throw "Required manifest not found: $path"
    }
}

$chromeManifest = Get-Content -Path $manifestPath -Raw | ConvertFrom-Json
$firefoxManifest = Get-Content -Path $firefoxManifestPath -Raw | ConvertFrom-Json
if (-not $chromeManifest.version -or $chromeManifest.version -ne $firefoxManifest.version) {
    throw 'Firefox manifest version must match the authoritative root manifest.json version.'
}

$version = $chromeManifest.version
$stageDir = Join-Path $DistPath "firefox-package-$version"
$zipName = "myte-autofill-$version-firefox.zip"
$zipPath = Join-Path $DistPath $zipName
$contentsPath = Join-Path $DistPath "myte-autofill-$version-firefox-contents.txt"
$productPaths = @('background.js', 'content.js', 'panel.html', 'styles.css', 'icons')

New-Item -ItemType Directory -Path $DistPath -Force | Out-Null
if (Test-Path $stageDir) {
    Remove-Item -Path $stageDir -Recurse -Force
}
if (Test-Path $zipPath) {
    Remove-Item -Path $zipPath -Force
}

New-Item -ItemType Directory -Path $stageDir -Force | Out-Null
Copy-Item -Path $firefoxManifestPath -Destination (Join-Path $stageDir 'manifest.json') -Force

foreach ($relativePath in $productPaths) {
    $sourcePath = Join-Path $root $relativePath
    if (-not (Test-Path $sourcePath)) {
        throw "Required packaging path not found: $relativePath"
    }

    $destinationPath = Join-Path $stageDir $relativePath
    if (Test-Path $sourcePath -PathType Container) {
        Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Force
    }
    else {
        Copy-Item -Path $sourcePath -Destination $destinationPath -Force
    }
}

$archiveEntries = Get-ChildItem -Path $stageDir -Recurse -File |
    ForEach-Object { $_.FullName.Substring($stageDir.Length + 1).Replace('\', '/') } |
    Sort-Object
$archiveEntries | Set-Content -Path $contentsPath
Compress-Archive -Path (Join-Path $stageDir '*') -DestinationPath $zipPath -CompressionLevel Optimal

if (-not (Test-Path $zipPath)) {
    throw "Package creation failed: $zipPath"
}

Write-Host "Created Firefox package: $zipPath"
Write-Host "Version: $version"

if ($WriteGitHubOutput -and $env:GITHUB_OUTPUT) {
    Add-Content -Path $env:GITHUB_OUTPUT -Value "package_path=$zipPath"
    Add-Content -Path $env:GITHUB_OUTPUT -Value "package_name=$zipName"
    Add-Content -Path $env:GITHUB_OUTPUT -Value "package_version=$version"
    Add-Content -Path $env:GITHUB_OUTPUT -Value "contents_path=$contentsPath"
}
