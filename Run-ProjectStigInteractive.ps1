Param(
    $DestinationRg,
    $imageResourceGroup,
    $TenantId,
    $url
)

Connect-AzAccount -UseDeviceAuthentication -TenantId $TenantId

$deploymentName = "$($imageResourceGroup)_$(Get-Random)"
New-AzSubscriptionDeployment `
  -Name $deploymentName `
  -Location eastus `
  -TemplateUri $url `
  -rgName $imageResourceGroup `
  -rgLocation eastus `
  -DeploymentDebugLogLevel All


$imageTemplates = Get-AzImageBuilderTemplate -ResourceGroupName $imageResourceGroup
foreach($template in $imageTemplates){
    Start-AzImageBuilderTemplate -ResourceGroupName $imageResourceGroup -Name $template.Name -AsJob
}