Function Parse-IniFile ($file) {
  $ini = @{}

  # Create a default section if none exist in the file. Like a java prop file.
  $section = "NO_SECTION"
  $ini[$section] = @{}

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

Parse-IniFile "./server-config-template.ini"
