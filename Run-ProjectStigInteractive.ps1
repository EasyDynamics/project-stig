Param(
    $minorVersion = "14", 
    $imageResourceGroup = "rg-stig-win-2019",
    $TenantId,
    $SubscriptionId,
    $url = "https://raw.githubusercontent.com/EasyDynamics/project-stig/feature/ChangeCpuFamily/azuredeploy.json"
)

if (-Not (Get-Module -ListAvailable Az.Resources,Az.ImageBuilder)) {
  Install-Module Az.Resources -Force -Scope CurrentUser
  Install-Module Az.ImageBuilder -Force -Scope CurrentUser
}

Write-Warning "Ensure that you have sufficient privileges in the account you're logging in with"
if (-Not (Get-AzContext)) {
  Connect-AzAccount -UseDeviceAuthentication -TenantId $TenantId
}
Set-AzContext -SubscriptionId $SubscriptionId

$deploymentName = "$($imageResourceGroup)_$(Get-Random)"
New-AzSubscriptionDeployment `
  -Name $deploymentName `
  -Location eastus `
  -TemplateUri $url `
  -rgName $imageResourceGroup `
  -minorVersion $minorVersion `
  -rgLocation eastus `
  -DeploymentDebugLogLevel All


$imageTemplates = Get-AzImageBuilderTemplate -ResourceGroupName $imageResourceGroup
foreach($template in $imageTemplates){
    Start-AzImageBuilderTemplate -ResourceGroupName $imageResourceGroup -Name $template.Name -AsJob
}