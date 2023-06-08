# uppelk

param ( $target, $source, $mode )

$p_ = Split-Path -Path $PSCommandPath -Parent
. $(Join-Path -Path $p_ -ChildPath "log.ps1")

Write-Output "BUILD_HOME CREATION UTILITY 1.0.0" | timestamp

$desc_ = if ( $mode -eq "Fresh" ) { "build home" } else { "delivery" }

# create target build home foder
Write-Output "Creating $desc_ folder $target" | timestamp

try {
   if ( -not ( Test-Path $target )) {
      $out_ = New-Item -ItemType directory -Path $target -ErrorAction Stop
      Write-Output "$($out_.FullName) created." | timestamp
   }
   if ( -not ( Test-Path $target -PathType container )) {
      Write-Output "Path '$target' is not a valid folder for $desc_." | timestamp_err
      exit 1
   }

   $total_file_count_ = 0
   $ti_ = (Get-Culture).TextInfo

   Get-ChildItem -Path $source -Directory | ForEach-Object {
      $comp_name_ = $_.PSChildName
      $comp_folder_ = $_.FullName
      Write-Output "Making $($comp_name_.ToUpper()) file structure..." | timestamp
      $spath_ = Join-Path $_.FullName "*"
      $res_ = Copy-Item -Path $spath_ -Destination $target -Exclude ('.svn', '.git', 'nobuild', 'cvs', 'misc', 'conditionalbuild', 'deploy.ini', '.vscode') -Recurse -PassThru -Force -ErrorAction Stop
      if ( $res_ ) {
         $file_count_ += $($res_.Count)
      }
      Write-Output "$file_count_ files copied." | timestamp

      $ini_file_ = Join-Path $comp_folder_ "deploy.ini"
      if ( Test-Path $ini_file_ -PathType Leaf ) {
         # rename and copy deploy.ini         
         $dest_comp_db_ = Join-Path $target "database"
         if ( -not ( Test-Path $dest_comp_db_ )) {
            $out_ = New-Item -ItemType directory -Path $dest_comp_db_ -ErrorAction Stop
            Write-Output "$out_.FullName created." | timestamp
         }
         $comp_name_ = $ti_.ToTitleCase( $comp_name_.ToLower() )
         $dest_comp_ini_ = Join-Path $dest_comp_db_ $comp_name_".ini"
         $res_ = Copy-Item -Path $ini_file_ -Destination $dest_comp_ini_ -PassThru -Force -ErrorAction Stop
         if ( $res_ ) {
            Write-Output "$comp_name_.ini created." | timestamp
            $file_count_ += 1
         }
      }
      $total_file_count_ += $file_count_
      
   }

   Write-Output "$total_file_count_ file(s) copied to $target." | timestamp
}
catch {
   Write-Output "Failed creating $desc_ folder $target" | timestamp_err
   Write-Output $_ | timestamp_err
   exit 1
}

exit 0