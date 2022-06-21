$config = Get-Content ".\config.json" | ConvertFrom-Json
$repo = $config.Repo

$releases = Invoke-WebRequest "https://api.github.com/repos/$repo/releases/latest" | ConvertFrom-Json

$version = $releases.tag_name
$folder = ".\$version"

$assets = $releases.assets

$files = $config.Files
foreach ($file in $files) {

  $startsWith = $file.Split("*")[0]
  $endsWith = $file.Split("*")[-1]

  foreach ($asset in $assets) {
    if ($asset.name.StartsWith($startsWith) -and $asset.name.EndsWith($endsWith)) {
      $filename = $asset.name
      if (!(Test-Path -Path $folder)) { New-Item -Path $folder -ItemType Directory }
      Start-BitsTransfer -Source $asset.browser_download_url -Destination ".\$version\$filename" -DisplayName $filename
    }
  }

}
