Function Parse-IniFile ($file) {
  $ini = @{}

  # Create a default section if none exist in the file. Like a java prop file.
  $ini = @{}

  switch -regex -file $file {
    "^\[(.+)\]$" {
      $section = $matches[1].Trim()
      $ini[$section] = @{}
      Write-Host "First"
      Write-Host $ini
    }
    "^\s*([^#].+?)\s*=\s*(.*)" {
      $name,$value = $matches[1..2]
      # skip comments that start with semicolon:
      if (!($name.StartsWith(";"))) {
        # $ini[$section][$name] = $value.Trim()
        $ini[$name] = $value.Trim()
      }
    }
  }
  $ini
}

$WorkshopIdsArr = @()
$ModIdsArr = @()

$modDir = "C:\Steam\steamapps\workshop\content\108600"
$modIds = gci $modDir
foreach ($workshopId in $modIds){
    $WorkshopIdsArr += "$($workshopId);" 
    $modNames = gci "$($workshopID.FullName)\mods" 
    foreach ($modName in $modNames){
        $modInfo = "$($modName.FullName)/mod.info"
        $modParams = Parse-IniFile($modInfo)
        foreach($modParam in $modParams){
            $ModIdsArr += "$($modParam.id);"
            Write-Host "Link: https://steamcommunity.com/sharedfiles/filedetails/?id=$($workshopId) => Workshop ID: $workshopId --- Mod ID: $($modParam.id)"
        }
    }
}
$WorkshopIds = $WorkshopIdsArr -join ""
$ModIds = $ModIdsArr -join ""
Write-Host 
Write-Host "=== ALL WORKSHOP IDs ==="
Write-Host $WorkshopIds
Write-Host 
Write-Host "=== ALL MOD IDs ==="
Write-Host $ModIds
Write-Host 
