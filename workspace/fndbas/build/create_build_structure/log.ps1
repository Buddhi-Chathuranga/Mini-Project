# uppelk

filter timestamp 
{
   $dt_ = "$(Get-Date -Format G):"
   if ( $_.GetType().Name -eq "Hashtable" ) {
      $hs_ = $_
      $hs_.Keys | ForEach-Object {
         Write-Host "$dt_ $_=$($hs_[$_])"
      }
   } else {
      Write-Host "$dt_ $_"
   }
}
filter timestamp_err 
{
   Write-Host "$(Get-Date -Format G): ERROR: $_" -ForegroundColor Red
}

filter timestamp_warn 
{
   Write-Host "$(Get-Date -Format G): WARNING: $_" -ForegroundColor Red
}