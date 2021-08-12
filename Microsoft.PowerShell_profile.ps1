# Personalization:

Set-Location $home


# Constants:
$isAdmin = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$pypath =  "C:\git\python\scripts\scripts\"
$itapath = "D:\stuff_to_keep\Italian\Italian_Reading\Material\"

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

##> CTR

Function Start-Viewer {
    [Alias("CTRView")]
    Param()
    & cd "D:\Files\Other\CTR\Modding\ctr-viewer-r10"
    & "D:\Files\Other\CTR\Modding\ctr-viewer-r10\ctrviewer.exe"
}


$TractDict = @{
    "Tiny Arena"    = "arena2"
    "Hot Air Skyway" = "blimp1"
    "Cortex Castle" = "castle1"
    "Mystery Caves" = "cave1"
    "Coco Park" = "coco1"
    "Blizzard Bluff" = "desert2"
    "Polar Pass" = "ice1"
    "Crash Cove" = "island1"
    "N. Gin Labs" = "labs1"
    "Dingo Canyon" = "proto8"
    "Dragon Mines" = "proto9"
    "Slide Coliseum" = "secret1"
    "Turbo Track" = "secret2"
    "Sewer Speedway" = "sewer1"
    "Oxide Station" = "space"
    "Tiger Temple" = "temple1"
    "Papu's Pyramid" = "temple2"
    "Roo's Tubes" = "tube1"
}



Function Start-CtrPC {
    Param(
    [ValidateSet(
    "Blizzard Bluff",
    "Coco Park",
    "Cortex Castle",
    "Crash Cove",
    "Dingo Canyon",
    "Dragon Mines",
    "Hot Air Skyway",
    "Mystery Caves",
    "N. Gin Labs",
    "Oxide Station",
    "Papu's Pyramid",
    "Polar Pass",
    "Roo's Tubes",
    "Sewer Speedway",
    "Slide Coliseum",
    "Tiger Temple",
    "Tiny Arena",
    "Turbo Track"
)]
    $Track,
    [ValidateSet("NTSC", "PAL")]
    $Version
    )
    End {
        if ($Track) {
            $path = "D:\Files\Other\CTR\Modding\ctr-viewer-r10\"
            switch ($version){
                "NTSC" {$path += "levelbank_NTSC\"}
                "PAL" {$path += "levelbank_PAL\"}
                Default {$path += "levelbank\"}
            }
            $loadpath = "D:\Files\Other\CTR\Modding\ctr-viewer-r10\levels"
            $pathChildItem = get-childitem $loadpath
            if ($pathChildItem) {
                $pathChildItem | remove-item -recurse -force
            }
            copy-item "$path$($TractDict[$Track])\*" $loadpath -force
            write-host "$path$($TractDict[$Track])"
        }
        & "D:\Games\Emulation\JoyToKey\JoyToKey.exe"
        & cd "D:\Programs\obs-studio\bin\64bit"
        & .\obs64 --startrecording
        & cd "D:\Files\Other\CTR\Modding\ctr-viewer-r10"
        & ".\ctrviewer.exe"
        & "D:\Games\Emulation\Emulators\PS1\mednafen\mednafen.exe" "D:\Games\Emulation\ROMs\PS1\Crash Bandicoot Racing [NTSC-J] [SCPS-10118].cue"
    }
}

Function Start-CtrConsole {
    [Alias("ctrcon")]
    Param()
    cd "D:\Programs\obs-studio\bin\64bit"
    & .\obs64 --startrecording
}

Function Start-Mednafen {
    [Alias("ctremu")]
    Param()
    & "D:\Games\Emulation\JoyToKey\JoyToKey.exe"
    & cd "D:\Games\Emulation\Emulators\PS1\mednafen"
    & .\mednafen.exe "D:\Games\Emulation\ROMs\PS1\Crash Bandicoot Racing [NTSC-J] [SCPS-10118].cue"
}

#> ffmpeg

Function Get-Video {
    [Alias("clip")]
    Param(
        $Start,
        $End,
        $InputPath,
        $OutputPath
    )
    if (!$InputPath) {
        $InputPath = (Get-Location).path
    }
    $Length = Get-TimeDifference -Start $Start -End $End
    ffmpeg -ss $Start -i $InputPath -t $Length $OutputPath
}

Function Add-Subtitles {
    [Alias("addsubs")]
    Param (
        $InputPath,
        $OutputPath,
        $SubsPath
    )
    ffmpeg -i $InputPath -vf subtitles=$SubsPath $OutputPath
}

Function Merge-Video {
    [Alias("combovid")]
    param (
        $ConcatPath,
        $OutputPath
    )
    ffmpeg -f concat -safe 0 -i $ConcatPath -c copy SC1_temp.mkv
}

Function Merge-AudioVideo {
    [Alias("musicombo")]
    param (
        $InputVideo,
        $InputAudio,
        $OutputPath
    )
    ffmpeg -i $InputVideo -i $InputAudio -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest $OutputPath
}

Function Open-Video{
    [Alias("playlast")]
    Param()
    cd $CtrVids
    $vids = Get-ChildItem | Where-Object {$_.Name -match "^\d.*"}
    vlc $vids[-1].Name
}

Function Get-TimeDifference{
    param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName)]
        $Start,
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName)]
        $End
        )
    process{
        $TypedStart = ([DateTime]::ParseExact($Start, "HH:mm:ss",$null))
        $TypedEnd = ([DateTime]::ParseExact($End, "HH:mm:ss",$null))
        $elapsed = [PSCustomObject]@{
            Start = $Start
            End = $End
            Elapsed = ($TypedEnd - $TypedStart).ToString("hh\:mm\:ss")
        }
        $elapsed.elapsed
    }
}

# General:

Function Move-Up {
    $dirs = (Get-ChildItem).FullName
    Get-ChildItem | Get-ChildItem | ForEach-Object {Move-Item $_.FullName -Force -Confirm:$true} 
    Remove-Item $dirs

}
