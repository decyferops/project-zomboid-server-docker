$ProgressPreference = "SilentlyContinue"

# ! Input Params
$KeyPath = ""
$LocalServername = "KappaLegacy"
$ServerName = "kappa-42"
$ServerIP = "192.168.0.250"
$ServerUser = "steam"

$DestinationZomboidPath = "C:\repo\pz-complete\server-data"
$DestinationPlatform = "Local_Windows"
$ArtifactDir = "C:/Users/Decyfer/Desktop/pz-bundle"

# ? Windows path 
# TODO: Include Linux path and custom path option
$SourceZomboidPath = "C:/Users/$($env:UserName)/Zomboid"

# ! (1.) Transfer 'Server' Configuration files
$configSrc = Join-Path $SourceZomboidPath "Server" 
$configDest = Join-Path $ArtifactDir "Server"
Write-Host "(1.) Transferring `Server` Configuration files | src: $configSrc               | dest: $configDest"
# ? If the destination does not exist - create directory
if (-Not(Test-Path $configDest)){
    Write-Host "Path $configDest does not exist, creating..."
    New-Item $configDest -ItemType Directory
}
Copy-Item -Path "$($configSrc)/$LocalServername*" -Destination $configDest -Recurse
Rename-Item "$($configDest)\$($LocalServername).ini" -NewName "$($ServerName).ini"
Rename-Item "$($configDest)\$($LocalServername)_SandboxVars.lua" -NewName "$($ServerName)_SandboxVars.lua"
Rename-Item "$($configDest)\$($LocalServername)_spawnregions.lua" -NewName "$($ServerName)_spawnregions.lua"


# ! Rename server files to match destination server names


# ! (2.) Transferring world data
$worldDataSrc = Join-Path $SourceZomboidPath "Saves/Multiplayer/$($LocalServername)"
Write-Host "(2.) Transferring world data | src: $worldDataSrc        | dest: $($ArtifactDir)/world_data.tar"

if (Test-Path $worldDataSrc){
    # ? We zip the contents of
    tar -czf world_data.tar -C $worldDataSrc .
    Copy-Item world_data.tar $ArtifactDir
    
    # Comment out the removal for debugging
    Remove-Item .\world_data.tar
}
else {
    Write-Host "dir does not exist $worldDataSrc"
}


# ! (3.) Transfer player data
$playerDataSrc = Join-Path $SourceZomboidPath "Saves/Multiplayer/$($LocalServername)_player"
Write-Host "(3.) Transfer player data    | src: $playerDataSrc | dest: $($ArtifactDir)/player_data.tar"

if (Test-Path $playerDataSrc){
    tar -czf player_data.tar -C $playerDataSrc .
    Copy-Item player_data.tar $ArtifactDir

    # Comment out the removal for debugging
    Remove-Item .\player_data.tar
}
else {
    Write-Host "dir does not exist $playerDataSrc"
}


$configDest = Join-Path $DestinationZomboidPath "Server"
$dataDest = Join-Path $DestinationZomboidPath "Saves/Multiplayer/$($ServerName)/"

if ($DestinationPlatform -eq "Local_Windows") {
    if (Test-Path $configDest){
        Write-Host "Cleaning up destination dir: $configDest"
        Remove-Item "$($configDest)/*" -Recurse
    }
    if (Test-Path $dataDest){
        Write-Host "Cleaning up destination dir: $dataDest"
        Remove-Item "$($dataDest)/*" -Recurse
    }
    Copy-Item "$($ArtifactDir)/Server/*" $configDest
    Copy-Item "$($ArtifactDir)/world_data.tar" $dataDest
    Copy-Item "$($ArtifactDir)/player_data.tar" $dataDest

    tar xvf "$($dataDest)\player_data.tar"
    # tar xvf .\world_data.tar -C $dataDest
}