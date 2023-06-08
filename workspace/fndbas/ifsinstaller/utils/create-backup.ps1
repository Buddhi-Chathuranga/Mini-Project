param (
    [Parameter(Mandatory=$true)][string]$backupPath,
    [Parameter(Mandatory=$true)][string]$namespace,
    [string]$kubeconfig,
    [string]$context
)
Import-Module -DisableNameChecking -Force $PSScriptRoot\backup-module.psm1
Create-Backup -backupPath $backupPath -namespace $namespace -kubeconfig $kubeconfig -context $context