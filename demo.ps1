#### Parameters

$keyvaultname = "aksdemocluster-kv11"
$location = "South India"
$keyvaultrg = "MyRg"
$sshkeysecret = "sshpubkey"
$spnclientid = "9b20c53c-41c5-422f-a193-3dc97d26b6c3"
$clientidkvsecretname = "spn-id"
$spnclientsecret = "CvX8Q~9sS2oq3PG1AsxQTjJ7Q8AlgfiL0SNNgax7"
$spnkvsecretname = "kpn-secret"
$spobjectID = "9b20c53c-41c5-422f-a193-3dc97d26b6c3"
$userobjectid = "56a2e32b-2961-4f83-83df-f74eca1bf3ed"


#### Create Key Vault

New-AzResourceGroup -Name $keyvaultrg -Location $location

New-AzKeyVault -Name $keyvaultname -ResourceGroupName $keyvaultrg -Location $location

Set-AzKeyVaultAccessPolicy -VaultName $keyvaultname -UserPrincipalName $userobjectid -PermissionsToSecrets get,set,delete,list

#### create an ssh key for setting up password-less login between agent nodes.

ssh-keygen  -f ~/.ssh/id_rsa_terraform


#### Add SSH Key in Azure Key vault secret

$pubkey = cat ~/.ssh/id_rsa_terraform.pub

$Secret = ConvertTo-SecureString -String $pubkey -AsPlainText -Force

Set-AzKeyVaultSecret -VaultName $keyvaultname -Name $sshkeysecret -SecretValue $Secret


#### Store service principal Client id in Azure KeyVault

$Secret = ConvertTo-SecureString -String $spnclientid -AsPlainText -Force

Set-AzKeyVaultSecret -VaultName $keyvaultname -Name $clientidkvsecretname -SecretValue $Secret


#### Store service principal Secret in Azure KeyVault

$Secret = ConvertTo-SecureString -String $spnclientsecret -AsPlainText -Force

Set-AzKeyVaultSecret -VaultName $keyvaultname -Name $spnkvsecretname -SecretValue $Secret


#### Provide Keyvault secret access to SPN using Keyvault access policy

Set-AzKeyVaultAccessPolicy -VaultName $keyvaultname -ServicePrincipalName $spobjectID -PermissionsToSecrets Get,Set