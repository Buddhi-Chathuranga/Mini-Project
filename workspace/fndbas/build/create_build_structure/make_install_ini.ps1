# uppelk

param ( [string]$build_home, [string]$mode )

$p_ = Split-Path -Path $PSCommandPath -Parent
. $(Join-Path -Path $p_ -ChildPath "ini_file.ps1")
. $(Join-Path -Path $p_ -ChildPath "log.ps1")

Write-Output "INSTALL.INI CREATION UTILITY 1.0.0" | timestamp

# main
$ti_ = (Get-Culture).TextInfo
$component_mode_ = if ( $mode -eq "Fresh" ) { "FreshInstall" } else { "VersionUpToDate" } 
$db_path_ = Join-Path -Path $build_home -ChildPath "database"
if ( ! $(Test-Path -Path $db_path_) ) {
   Write-Output "Cannot generate Install.ini file." | timestamp_err
   Write-Output "database folder '$db_path_' does not exist." | timestamp_err
   return 0
}
$mod_conxs_ = ""
$inst_ver_ = ""
Write-Output "Processing database ini files in $($db_path_)" | timestamp
Get-ChildItem -Path $db_path_ -File | ForEach-Object {
   if ( ".ini" -eq $_.Extension -and "Install.ini" -ne $_.Name ) {
      Write-Output "Processing $($_.Name)" | timestamp
      $comp_ = $_.BaseName
      $comp_u_ = $comp_.ToUpper()
      $comp_ = $ti_.ToTitleCase( $comp_.ToLower() )
      $ini_ = [Ini_File]::new( $_.FullName )
      $section_ = $ini_.GetSection( "Component" )
      if ( $section_ -and $section_.Exists( "Name" ) ) {
         Write-Output "Updating component $($comp_u_)" | timestamp
         $mod_conxs_ = $mod_conxs_ + $comp_ + "="
         $inst_ver_ = $inst_ver_ + $comp_u_ + "=" + $component_mode_ + "`r`n"
         $conns_ = $ini_.GetSection( "Connections" )
         if ( $conns_ ) {
            $entries_ = $conns_.GetEntries()
            for ($i = 0; $i -lt $entries_.Count; $i++) {
               $entry_ = $entries_[ $i ]
               for ($j = $i + 1; $j -lt $entries_.Count; $j++) {
                  $tmp_ = $entries_[ $j ]
                  if ($tmp_.getKey() -ieq $entry_.getKey() ) {
                     Write-Output "Duplicated component connection '$($tmp_.getKey())' in $comp_.ini." | timestamp_warn
                  }
               }
               $tmp_ = $ti_.ToTitleCase( $entry_.getKey().ToLower().Trim() )
               $mod_conxs_ = $mod_conxs_ + $tmp_ + "." + $entry_.getValue().Trim() + ";"
            }
         }
         $mod_conxs_ = $mod_conxs_ + "`r`n"
      } else {
         Write-Output "Unknown or invalid component .ini file '$($_.Name)'." | timestamp_warn
         Write-Output "Component $($comp_u_) will not be included in Install.ini" | timestamp_warn
      }
   }
}

Write-Output "Creating Install.ini..." | timestamp
$install_ini_ = Join-Path -Path $build_home -ChildPath "database" | Join-Path -ChildPath "Install.ini"
$all_ = "[ModuleConnections]`r`n" + $mod_conxs_ + "[InstalledVersions]`r`n" + $inst_ver_ 
Set-Content -Path $install_ini_ -Value $all_ -Encoding Ascii -NoNewline