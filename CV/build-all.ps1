# Recompiles every resume variant in this folder to PDF.
# Run from PowerShell: .\build-all.ps1
# (Open a new terminal first if you just installed Tectonic, so PATH updates take effect.)

$tectonic = "$env:USERPROFILE\tools\tectonic\tectonic.exe"

Get-ChildItem -Filter "*.tex" | ForEach-Object {
    Write-Host "Building $($_.Name)..."
    & $tectonic $_.FullName
}

Write-Host "Done. PDFs are in this folder."
