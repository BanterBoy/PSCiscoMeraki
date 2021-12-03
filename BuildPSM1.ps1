$Scripts = Get-ChildItem $PSScriptRoot\PSCiscoMeraki\Public\ | Select-Object -Property FullName
foreach ( $Script in $Scripts) {
    $Content = Get-Content -Path $Script.fullname
    Add-Content -Path $PSScriptRoot\PSCiscoMeraki\PSCiscoMeraki.psm1 -Value $Content -Encoding UTF8
}
