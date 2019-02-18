function Edit-XmlNodes {
    param (
        [xml] $doc = $(throw "doc is a required parameter"),
        [string] $xpath = $(throw "xpath is a required parameter"),
        [string] $value = $(throw "value is a required parameter"),
        [bool] $condition = $true,
        [string] $stringToReplace
    )

	$replacePartialValue = ($stringToReplace -ne $null -and $stringToReplace -ne '' -and $stringToReplace -ne '*')

    $nodes = $doc.SelectNodes($xpath)
    foreach ($node in $nodes) {
        if ($null -ne $node) {
            if ($node.NodeType -eq "Element") {
                if($replacePartialValue -eq $true) {
                    $node.InnerXml = $node.InnerXml -replace $stringToReplace, $value
                }
                else {
                    $node.InnerXml = $value
                }
            }
            else {
                if($replacePartialValue -eq $true) {
                    $node.Value = $node.Value -replace $stringToReplace, $value
                }
                else {
                    $node.Value = $value
                }
            }
        }
    }
}

$path = $env:Build_SourcesDirectory
#$path = "C:\Users\akhandelwal\source\repos\Tokenizable\TokenizableWebAPI"

Get-ChildItem -Path $path -Recurse *.config -Exclude packages.config | ForEach-Object {
    $configFileName = $_.FullName
    $configXml = [xml] (Get-Content($configFileName))
    $parentDirectory = [System.IO.Path]::GetDirectoryName($configFileName)
    $parameterFilePath = "$parentDirectory\Parameters.xml"

    If (Test-Path $parameterFilePath -PathType Leaf) {
        Write-Host "Tokenizing $configFileName"
        ([xml](Get-Content $parameterFilePath)).parameters.parameter | ForEach-Object {
            $tokenXPath  = $_.match
            $tokenKey = $_.token
            $stringToReplace = $_.stringToReplace

            Edit-XmlNodes -doc $configXml -xpath $tokenXPath -value $tokenKey -stringToReplace $stringToReplace
            $configXml.Save($configFileName)
        }
    }
}