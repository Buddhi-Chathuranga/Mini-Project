function Create-Backup {
   param ([String] $backupPath, [String] $namespace, [String] $kubeconfig = '', [String] $context = '')

   $kubectlArgs = ''
   $helmArgs = ''
   if(-not ([string]::IsNullOrEmpty($kubeconfig))) 
   {
      $kubectlArgs += '--kubeconfig '
      $kubectlArgs += $kubeconfig + ' '
      $helmArgs += '--kubeconfig '
      $helmArgs += $kubeconfig + ' '
   }
   if(-not ([string]::IsNullOrEmpty($context))) 
   {
      $kubectlArgs += '--context '
      $kubectlArgs += $context + ' '
      $helmArgs += '--kube-context '
      $helmArgs += $context + ' '
   }
   
   $helmHistory = helm history ifs-cloud -n $namespace -o json $helmArgs.Split(' ') | ConvertFrom-Json
   $revision = -1
   foreach ($element in $helmHistory) {
      if ($element.status -eq 'Deployed')
      {
         $revision = $element.revision
      }
   }

   New-Item -Path "$backupPath\content_backup.yaml" -ItemType "file" -Force
   New-Item -Path "$backupPath\namespace_backup.yaml" -ItemType "file" -Force
   New-Item -Path "$backupPath\revision" -ItemType "file" -Force -Value $revision
   kubectl get secrets -n $namespace -o yaml $kubectlArgs.Split(' ') >> "$backupPath\content_backup.yaml"
   kubectl get ns $namespace -o yaml $kubectlArgs.Split(' ') >> "$backupPath\namespace_backup.yaml"
}
Export-ModuleMember -Function Create-Backup

function Restore-Backup {
   param ([String] $backupPath, [String] $namespace, [String] $kubeconfig = '', [String] $context = '')

   $kubectlArgs = ''
   $helmArgs = ''
   if(-not ([string]::IsNullOrEmpty($kubeconfig))) 
   {
      $kubectlArgs += '--kubeconfig '
      $kubectlArgs += $kubeconfig + ' '
      $helmArgs += '--kubeconfig '
      $helmArgs += $kubeconfig + ' '
   }
   if(-not ([string]::IsNullOrEmpty($context))) 
   {
      $kubectlArgs += '--context '
      $kubectlArgs += $context + ' '
      $helmArgs += '--kube-context '
      $helmArgs += $context + ' '
   }
   
   $revision = Get-Content -Path "$backupPath\revision" -Raw
   kubectl apply -f "$backupPath\namespace_backup.yaml" $kubectlArgs.Split(' ')
   kubectl apply -f "$backupPath\content_backup.yaml" $kubectlArgs.Split(' ')
   helm rollback ifs-cloud $revision -n $namespace $helmArgs.Split(' ')
}
Export-ModuleMember -Function Restore-Backup

