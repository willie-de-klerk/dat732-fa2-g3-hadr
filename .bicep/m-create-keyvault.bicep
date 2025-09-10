/*
    file: .bicep/keyvault.bicep
    purpose: We are making use of this module to create azure key vaults using Azure Verified Modules that are not written by us.
    link: https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/key-vault/vault
*/

//Parameters


//data type: string
param sVaultName string
param sLocation string
param sRoleAssignmentName string
param sRoleAssignmentPrincipalId string 
param sRoleAssignmentPrincipalType string
param sRoleDefinitionIdOrName string
//data type: bool
param bEnableSoftDelete bool



module vault 'br/public:avm/res/key-vault/vault:0.13.3' = {
    name: 'createazurekeyvault'
    params: {
        name: sVaultName
        enableSoftDelete: bEnableSoftDelete
        location: sLocation
        roleAssignments: [
            {
                name: sRoleAssignmentName
                principalId: sRoleAssignmentPrincipalId
                principalType: sRoleAssignmentPrincipalType
                roleDefinitionIdOrName: sRoleDefinitionIdOrName
            }
        ]
    }
} 


//  author: @willie-de-klerk
