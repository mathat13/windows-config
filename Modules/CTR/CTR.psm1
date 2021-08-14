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

Function New-SRT {
    Param(
        $CourseTime,
        $LapTime,
        $Hour = 00,
        $Minute = 00,
        $Second = 00
    )
    $Time = ([datetime]("$Hour`:$Minute`:$Second")).ToLongTimeString()
    $Add3 = (([datetime]$Time).AddSeconds(3)).ToLongTimeString()

    "1
00:00:00,00 --> 00:00:03,00
$CourseTime Course

2
$Time,00 --> $Add3,00
$LapTime Lap" > "subs.srt"

}

Function Add-Subtitles {
    [Alias("addsubs")]
    Param (
        $InputPath,
        $OutputPath,
        $SubsPath
    )

    $SubsPath = "C:\Users\liljo\Documents\WindowsPowerShell\Modules\CTR\subs.srt"
    ffmpeg -i $InputPath -vf subtitles=$SubsPath $OutputPath
}

Function Merge-Video {
    [Alias("combovid")]
    param (
        $ConcatPath,
        $OutputPath
    )
    ffmpeg -f concat -safe 0 -i $ConcatPath -c copy $OutputPath
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