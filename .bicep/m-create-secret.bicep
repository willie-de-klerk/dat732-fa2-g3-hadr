/*
    file: '.bicep/m-create-secet.bicep
    purpose: We are making use of this module to create azure key vault secrets using an Azure Verified Module that is not written by us.
*/

//Parameters

//data type: string
param sVaultName string
param sSecretName string
@secure()
param sSecretValue string


module vault 'br/public:avm/res/key-vault/vault/secret:0.1.0' = {
  params: {
    keyVaultName: sVaultName
    name: sSecretName
    value: sSecretValue
  }
}

