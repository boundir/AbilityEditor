Param(
    [string] $srcDirectory, # the path that contains your mod's .XCOM_sln
    [string] $sdkPath, # the path to your SDK installation ending in "XCOM 2 War of the Chosen SDK"
    [string] $gamePath, # the path to your XCOM 2 installation ending in "XCOM2-WaroftheChosen"
    [string] $config # build configuration
)

$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
$common = Join-Path -Path $ScriptDirectory "X2ModBuildCommon\build_common.ps1"
Write-Host "Sourcing $common"
. ($common)

$builder = [BuildProject]::new("AbilityEditor", $srcDirectory, $sdkPath, $gamePath)

$builder.IncludeSrc((Join-Path $srcDirectory "CustomSrc"))

$builder.AddToClean("AbilityEditorHighlander")
$builder.AddToClean("AbilityEditorAlienHunters")

$overlayRoot = Join-Path $srcDirectory "CustomSrc"
$overlayStampPath = Join-Path $srcDirectory "BuildCache\CustomSrcPackages.json"
$sdkScriptDir = Join-Path $sdkPath "XComGame\Script"

function Get-OverlayPackageTimestamp([string] $package)
{
    $compiled = Get-Item (Join-Path $sdkScriptDir "$package.u") -ErrorAction SilentlyContinue
    if ($null -eq $compiled) { return $null }
    return $compiled.LastWriteTimeUtc.Ticks
}

$builder.AddPreMakeHook({
    $stamp = @{}
    if (Test-Path $overlayStampPath)
    {
        (Get-Content $overlayStampPath -Raw | ConvertFrom-Json).PSObject.Properties | ForEach-Object { $stamp[$_.Name] = $_.Value }
    }

    foreach ($packageDir in Get-ChildItem $overlayRoot -Directory)
    {
        $current = Get-OverlayPackageTimestamp $packageDir.Name
        if ($null -eq $current) { continue }
        if ($stamp.ContainsKey($packageDir.Name) -and [long]$stamp[$packageDir.Name] -eq $current) { continue }

        Write-Host "$($packageDir.Name).u was not produced by this mod's last build; recompiling it with CustomSrc"
        foreach ($file in Get-ChildItem $packageDir.FullName -Recurse -File)
        {
            $relative = $file.FullName.Substring($packageDir.FullName.Length + 1)
            $copy = Join-Path $sdkPath "Development\Src\$($packageDir.Name)\$relative"
            if (Test-Path $copy) { (Get-Item $copy).LastWriteTime = Get-Date }
        }
    }
})

switch ($config)
{
    "debug" {
        $builder.EnableDebug()
    }
    "default" {
        # Nothing special
    }
    "" { ThrowFailure "Missing build configuration" }
    default { ThrowFailure "Unknown build configuration $config" }
}

$builder.InvokeBuild()

# Only reached on success: the base packages now contain the CustomSrc changes.
$overlayStamp = @{}
foreach ($packageDir in Get-ChildItem $overlayRoot -Directory)
{
    $timestamp = Get-OverlayPackageTimestamp $packageDir.Name
    if ($null -ne $timestamp) { $overlayStamp[$packageDir.Name] = $timestamp }
}
New-Item -ItemType Directory -Force (Split-Path $overlayStampPath) | Out-Null
$overlayStamp | ConvertTo-Json | Set-Content -Path $overlayStampPath
