$ErrorActionPreference = 'Stop'

$dir = Join-Path -Path (Get-Location) -ChildPath 'images'
if (!(Test-Path -Path $dir)) {
  throw "images directory not found at $dir"
}

$typeMap = @{
  'crown'  = 'crown'
  'amulet' = 'amulet'
  'weapon' = 'weapon'
  'sword'  = 'weapon'
  'axe'    = 'weapon'
  'bow'    = 'weapon'
  'dagger' = 'weapon'
  'blade'  = 'weapon'
}

$files = Get-ChildItem -Path $dir -File | Where-Object { $_.Extension -match '^(?i)\.(png|jpg|jpeg|webp|avif)$' }

$items = @()
foreach ($f in $files) {
  $name  = $f.BaseName
  $lower = $name.ToLower()
  $type  = 'weapon'
  foreach ($k in $typeMap.Keys) {
    if ($lower -like "*${k}*") { $type = $typeMap[$k]; break }
  }
  $id = ($name -replace '[^a-zA-Z0-9_-]', '-').ToLower()
  $displayName = ($name -replace '_', ' ')
  $items += [PSCustomObject]@{
    id   = $id
    name = $displayName
    type = $type
    file = $f.Name
  }
}

$json = $items | ConvertTo-Json -Depth 3
Set-Content -Encoding UTF8 -NoNewline -Path (Join-Path (Get-Location) 'items.json') -Value $json
Write-Host "Wrote items.json with $($items.Count) items"


