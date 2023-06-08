<#
.SYNOPSIS
   Create or update build home structures

.PARAMETER components
   Specifies the folder where the source file check out is located.
   COMPONENTS can also be set as an environment variable. If passed as an argument the env variable is ignored.

.PARAMETER build_home
   Specifies a path to the build home folder. 
   This path and the contents are generated during fresh home mode. 
   BUILD_HOME can also be set as an environment variable. If passed as an argument the env variable is ignored.

.PARAMETER delivery
   Specifies the folder where the delivery to be created. This path and the contents are generated. 
   DELIVERY can also be set as an environment variable. If passed as an argument the env variable is ignored.

.PARAMETER skip_auto_update
   Optional parameter to skip checking for updated components.
   
.EXAMPLE
  PS> .\create_build_structure.ps1 -components C:\checkout\ifs-applications -build_home C:\ifs\build-home
  creates a new build folder structure (C:\ifs\build-home) using a full component set (C:\checkout\ifs-applications)
  
  .EXAMPLE
  PS> .\create_build_structure.ps1 -components C:\checkout\patch-1234 -delivery C:\ifs\delivery-1234
  creates a new build folder structure (C:\ifs\delivery-1234) using a patch delivery (C:\checkout\patch-1234)
  
#>

# uppelk

[CmdletBinding(DefaultParameterSetName = 'unknown')]
param (
   [Parameter(ParameterSetName = 'fresh_build_home', Mandatory = $True)]
   [Parameter(ParameterSetName = 'delivery_home')]
   [string]$components,
   [Parameter(ParameterSetName = 'fresh_build_home')]
   [string]$build_home,
   [Parameter(ParameterSetName = 'delivery_home')]
   [string]$delivery,
   [Parameter(ParameterSetName = 'delivery_home')]
   [switch]$skip_auto_update = $false
)

. .\create_build_structure\ini_file.ps1
. .\create_build_structure\log.ps1

class Globals {
   [string]$all_args                                     # all origianl arguments, used when restarting
   [string]$target_path                                  # path for delivery folder
   [string]$source_path                                  # path for components folder
   [bool]$build_install_ini
   [bool]$skip_auto_update
   [ValidateSet('Fresh', 'Delivery')][string]$mode       # true when in delivery build mode
}

function Init_Unknown {
   $tmp_ = $env:BUILD_HOME
   if ( ! [string]::IsNullOrEmpty($tmp_) ) { 
      # fresh_home_mode
      return Init_Fresh_Mode
   }
   $tmp_ = $env:DELIVERY
   if ( ! [string]::IsNullOrEmpty($tmp_) ) { 
      # fresh_home_mode
      return Init_Delivery_Mode
   }
   throw "One of BUILD_HOME or DELIVERY must be provided."
}

function Init_Fresh_Mode {
   $globals_ = [Globals]::new()
   $globals_.all_args = ""

   $globals_.target_path = $env:BUILD_HOME
   if ( $build_home ) { 
      $globals_.target_path = $build_home
      $globals_.all_args += " -build_home " + $build_home
   }

   $globals_.mode = "Fresh"
   $globals_.build_install_ini = $True
   $globals_.skip_auto_update = $True # source is always uptodate 

   return $globals_
}

function Init_Delivery_Mode {
   $globals_ = [Globals]::new()
   $globals_.all_args = ""

   $globals_.target_path = $env:DELIVERY
   if ( $delivery ) { 
      $globals_.target_path = $delivery
      $globals_.all_args += " -delivery " + $delivery
   }

   # check if delivery already exists and not empty
   if ( ( Test-Path $globals_.target_path ) -and (Get-ChildItem -Path $globals_.target_path | Measure-Object).Count -gt 0 ) {
      Write-Output "Delivery folder '$($globals_.target_path)' is not empty." | timestamp_warn
   }
   
   $globals_.mode = "Delivery"
   $globals_.build_install_ini = $false
   $globals_.skip_auto_update = $skip_auto_update
   return $globals_
}

function Init_Components_Path() {
   param (
       [Globals]$globals_
   )
   $globals_.source_path = $components
   if ( [string]::IsNullOrEmpty($globals_.source_path) ) {
      $globals_.source_path = $env:COMPONENTS
   } else {
      $globals_.all_args += " -components " + $globals_.source_path
   }
   if ( [string]::IsNullOrEmpty($globals_.source_path) ) {
      throw "COMPONENTS must be provided."
   }
   if ( ! $(Test-Path -Path $globals_.source_path) ) {
      throw "COMPONENTS Folder '$($globals_.source_path)' does not exist."
   }
   $globals_.source_path = Resolve-Path -Path $globals_.source_path
}

function Init_Globals {
   $globals_ = $null
   switch ( $PSCmdlet.ParameterSetName )
   {
      "fresh_build_home" { $globals_ = Init_Fresh_Mode }
      "delivery_home" { $globals_ = Init_Delivery_Mode }
      Default { $globals_ = Init_Unknown }
   }

   Init_Components_Path $globals_
   return $globals_
}

# main 
Write-Output "BUILD STRUCTURE BUILDER 1.0.0" | timestamp

# dump some context details
Write-Output "OS=$([environment]::OSVersion)" | timestamp
Write-Output $PSVersionTable | timestamp

$g_ = Init_Globals
Write-Output "source=$($g_.source_path)" | timestamp
Write-Output "target=$($g_.target_path)" | timestamp

$current_ = Get-Location

try {
   # fresh mode need no updates
   if ( ! $g_.skip_auto_update ) 
   {
      $this_ = $PSCommandPath
      $cur_parent_ = Split-Path -Path $this_ -Parent
      .\create_build_structure\update.ps1 -source $g_.source_path -target $cur_parent_ 
      if ( $LASTEXITCODE -eq 2 ) {
         Write-Output "Preparing to restart Build structure builder..." | timestamp
         $pwsh_ = (Get-Process -Id $pid).Path
         Write-Output "Restarting $pwsh_..." | timestamp
         # null or empty caused issues in arglist
         $args_ = if ( [string]::IsNullOrEmpty($g_.all_args) ) { " " } else { $g_.all_args }
         Start-Process -FilePath $pwsh_ -ArgumentList "-file", ".\create_build_structure.ps1", "$args_", "-skip_auto_update" -Wait -NoNewWindow 
         Exit 0
      }
   }

   .\create_build_structure\make_build_home.ps1 -s $g_.source_path -t $g_.target_path -m $g_.mode
   if ( $LASTEXITCODE -ne 0 ) {
      Write-Output "Failed building folder structure." | timestamp_err
      exit 1
   }

   if ( $g_.build_install_ini ) {
      .\create_build_structure\make_install_ini.ps1 -b $g_.target_path -m $g_.mode | Out-Null
      if ( $LASTEXITCODE -ne 0 ) {
         Write-Output "Failed creating install.ini." | timestamp_err
         exit 1
      }   
   } else {
      Write-Output "Creating empty Install.ini..." | timestamp
      $install_ini_ = Join-Path -Path $g_.target_path -ChildPath "database" | Join-Path -ChildPath "Install.ini"
      Set-Content -Path $install_ini_ -Value "" -Encoding Ascii -NoNewline
   }

   Write-Output "Build structure builder completed." | timestamp   
}
finally {
   Set-Location $current_
}
