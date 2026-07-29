# Recompiles every resume variant in this folder to PDF, placing PDFs in the parent (CV) folder.
# Run from PowerShell: .\build-all.ps1
# (Open a new terminal first if you just installed Tectonic, so PATH updates take effect.)

$tectonic = "$env:USERPROFILE\tools\tectonic\tectonic.exe"
$outdir = Join-Path $PSScriptRoot ".."

Get-ChildItem -Filter "*.tex" | ForEach-Object {
    Write-Host "Building $($_.Name)..."
    & $tectonic $_.FullName -o $outdir
}

Write-Host "Done. PDFs are in the CV folder."
