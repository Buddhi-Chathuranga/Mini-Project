# uppelk

param ( [string]$source, [string]$target )

$p_ = Split-Path -Path $PSCommandPath -Parent
. $(Join-Path -Path $p_ -ChildPath "log.ps1")

Write-Output "SYSTEM UPDATE UTILITY 1.0.0" | timestamp

$cbs_ = "create_build_structure"

# updatable packages
$pkgs_ = # update.ps1 is always checked and updated, then restarted
         "${cbs_}\log.ps1:Log tool:0",
         "${cbs_}\ini_file.ps1:.ini tool:0",
         "${cbs_}\make_build_home.ps1:Build home builder:0",
         "${cbs_}\make_install_ini.ps1:Install .ini builder:0",
         "create_build_structure.ps1:Build structure builder:1" # have to restart if this file was updated

function Check_File_Update
{
   param (
      [string]$path_,
      [string]$filename_,
      [string]$desc_
   )

   Write-Output "Checking updates of $desc_..." | timestamp
   $update_loc_ = Join-Path $source "fndbas" | Join-Path -ChildPath "build" | Join-Path -ChildPath $filename_
   if ( Test-Path $update_loc_ -PathType Leaf ) {
      $file_ = Join-Path -Path $path_ -ChildPath $filename_
      $cmp_ = Compare-Object -ReferenceObject ( Get-Content -Path $update_loc_ ) -DifferenceObject ( Get-Content -Path $file_ ) -PassThru 
      if ( ! ( $null -eq $cmp_ ) ) {
         Write-Output "Updating $desc_..." | timestamp   
         Copy-Item -Path $update_loc_ -Destination $file_ -Force
         Write-Output "$desc_ updated." | timestamp   
         return 2
      }
   }
   Write-Output "$desc_ is up to date." | timestamp
   return 0
}

function Check_Updates 
{
   $res_ = Check_File_Update $target "${cbs_}\update.ps1" "Updater"
   if ( $res_ -eq 2 ) {
      # special case update app was updated
      Write-Output "Update utility was updated, restarting update utility..." | timestamp
      $pwsh_ = (Get-Process -Id $pid).Path
      $proc = Start-Process -FilePath $pwsh_ -ArgumentList "-file", "${cbs_}\update.ps1", "-source", "$source" , "-target", "$target" -Wait -NoNewWindow -PassThru
      Exit $proc.ExitCode
   }

   foreach ( $pkg_ in $pkgs_ )
   {
      $tmp_ = $pkg_.Split(":")
      $res_ = Check_File_Update $target $tmp_[0] $tmp_[1]
      if ( $tmp_[2] -eq "1" ) 
      {
         return $res_
      }
   }
   return $res_
}

# updated files are fetched from components_path
if ( [string]::IsNullOrEmpty($source) ) {
   exit 1
}
if ( [string]::IsNullOrEmpty($target) ) {
   exit 1
}
if ( $target -eq $source ) {
   exit 0
}

$res_ = Check_Updates
exit $res_