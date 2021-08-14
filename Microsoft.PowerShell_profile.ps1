# Personalization:



# Constants:
$isAdmin = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$pypath =  "C:\git\python\scripts\scripts\"
$itapath = "D:\stuff_to_keep\Italian\Italian_Reading\Material\"
$engwords = "D:\stuff_to_keep\English\Words\words.txt"

# Aliases:

$CtrVids = "D:\Videos\CTR_Script\Input Files\Video"
$CtrTechs = "D:\Videos\CTR_Techs"

# New-Alias -Name CtrView -Value "D:\Files\Other\CTR\Modding\ctr-viewer-r10"

# Functions:

#> Environment

function Get-Profile{
    [Alias("re")]
    Param()
    If(!$isAdmin){
        Start-Process wt " -M PowerShell -NoExit -Command Set-Location '$(Get-Location)'" -Verb RunAs
        Exit
    }
    Import-Module $Profile -Force -Global
    Update-Environment
}

function Update-Environment {
    $locations = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
                 'HKCU:\Environment'

    $locations | ForEach-Object {
        $k = Get-Item $_
        $k.GetValueNames() | ForEach-Object {
            $name  = $_
            $value = $k.GetValue($_)

            if ($userLocation -and $name -ieq 'PATH') {
                $Env:Path += ";$value"
            } else {
                Set-Item -Path Env:$name -Value $value
            }
        }

        $userLocation = $true
    }
}

#> Study

function Start-Python {
    [CmdletBinding()]

    Param()
 
    DynamicParam {
        $attributes = new-object System.Management.Automation.ParameterAttribute

        $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection.Add($attributes)

        $arrSet = Get-ChildItem $pypath | Select-Object -ExpandProperty Name
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
        $AttributeCollection.Add($ValidateSetAttribute)

        $dynParam1 = new-object -Type System.Management.Automation.RuntimeDefinedParameter("Script", [string], $attributeCollection)
            
        $paramDictionary = new-object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
        $paramDictionary.Add("Script", $dynParam1)
        
        return $paramDictionary
    }

    End{
    python $pypath$($PSBoundParameters['Script'])
    }
}

Function Start-Study {
    [CmdletBinding()]
    Param()
    DynamicParam {
        
        $attributes = new-object System.Management.Automation.ParameterAttribute
        $attributes.Mandatory = $false

        $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection.Add($attributes)

        $arrSet = Get-ChildItem $itapath | Select-Object -ExpandProperty Name | Sort-Object 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
        $AttributeCollection.Add($ValidateSetAttribute)

        $dynParam1 = new-object -Type System.Management.Automation.RuntimeDefinedParameter("PDF", [string], $attributeCollection)
        
        $paramDictionary = new-object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
        $paramDictionary.Add("PDF", $dynParam1)
        
        return $paramDictionary
    }

    End{
        Start-Process firefox "https://en.wiktionary.org/wiki/te#Italian"
        Start-Process firefox "https://translate.google.com/?sl=it&tl=en&op=translate&hl=en"
        foreach($path in (Get-ChildItem "D:\stuff_to_keep\Italian\Italian_Reading\*.txt").fullname) {
            Start-Process $path
        }
        Start-Process "D:\stuff_to_keep\Italian\Italian_Reading\Reference\Tenses"
        Start-Process $itapath$($PSBoundParameters['PDF'])
    }
}

#> Games

##> Melee

Function Start-Melee {
    [Alias("Melee")]
    Param()
    & "D:\Games\Melee\Slippi Dolphin.exe" /e "D:\Games\Melee\Super Smash Bros. Melee (v1.02).iso"
}

Function Start-UnclePunch {
    [Alias("Training")]
    Param()
    & "D:\Games\Melee\Slippi Dolphin.exe" /e "D:\Games\Melee\Training Mode v2.0 Beta 3.iso"
}

Function Start-20XX {
    [Alias("20xx")]
    Param()
    & "D:\Games\Melee\Slippi Dolphin.exe" /e "D:\Games\Melee\SSBM, 20XXHP 4.07++.iso"
}

# General:

Function Move-Up {
    $dirs = (Get-ChildItem).FullName
    Get-ChildItem | Get-ChildItem | ForEach-Object {Move-Item $_.FullName -Force -Confirm:$true} 
    Remove-Item $dirs

}

Function Out-SrtFile {
    [CmdletBinding()]
    param (
        $Hour = "00",
        $Minute = "00",
        $Second = "00",
        $Path 
    )
    Out-File 
}