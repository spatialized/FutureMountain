param(
    [string]$ManifestPath = "handbook-manifest.txt",
    [string]$OutPath = "FutureMountain_Handbook.md"
)

$ErrorActionPreference = "Stop"

function Clean-Title {
    param([string]$Text)
    return ($Text -replace '^\s*#+\s*', '').Trim()
}

function Demote-MarkdownHeadings {
    param(
        [string[]]$Lines,
        [int]$Levels = 1
    )

    $prefix = "#" * $Levels

    foreach ($line in $Lines) {
        if ($line -match '^(#{1,6})(\s+.*)$') {
            $newLevel = [Math]::Min(6, $matches[1].Length + $Levels)
            ("#" * $newLevel) + $matches[2]
        }
        else {
            $line
        }
    }
}

Remove-Item $OutPath -ErrorAction SilentlyContinue

@"
---
title: Future Mountain Handbook
date: $(Get-Date -Format "yyyy-MM-dd")
toc: true
toc-depth: 3
numbersections: true
---

"@ | Set-Content -Path $OutPath -Encoding utf8

$currentHeadingLevel = 0

Get-Content -LiteralPath $ManifestPath | ForEach-Object {
    $line = $_.Trim()

    if ($line -eq "" -or $line.StartsWith("//")) {
        return
    }

    if ($line -match '^(#{1,6})\s+(.+)$') {
        $currentHeadingLevel = $matches[1].Length
        "`n$line`n" | Add-Content -Path $OutPath -Encoding utf8
        return
    }

    if (-not (Test-Path -LiteralPath $line)) {
        Write-Warning "Missing file: $line"
        return
    }

    $content = Get-Content -LiteralPath $line
    $firstHeading = $content | Where-Object { $_ -match '^#\s+' } | Select-Object -First 1

    if ($firstHeading) {
        $title = Clean-Title $firstHeading
    }
    else {
        $title = [IO.Path]::GetFileNameWithoutExtension($line)
    }

    $sectionLevel = [Math]::Min(6, $currentHeadingLevel + 1)
    $sectionPrefix = "#" * $sectionLevel

    "`n`n$sectionPrefix $title`n`n_Source: `$line`_`n`n" |
        Add-Content -Path $OutPath -Encoding utf8

    $withoutFirstTitle = $false

    $processed = foreach ($contentLine in $content) {
        if (-not $withoutFirstTitle -and $contentLine -match '^#\s+') {
            $withoutFirstTitle = $true
            continue
        }

        $contentLine
    }

    Demote-MarkdownHeadings -Lines $processed -Levels 1 |
        Add-Content -Path $OutPath -Encoding utf8
}

Write-Host "Created $OutPath"