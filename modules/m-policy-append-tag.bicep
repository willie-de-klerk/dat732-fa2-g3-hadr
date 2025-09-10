/* 
  file: modules/m-policy-append-tag.bicep
  purpose: We are making use of this bicep file as a module that can be used to create a policy to automatically append tags to our solution resources. 
  link: https://learn.microsoft.com/en-gb/azure/templates/microsoft.authorization/policyassignments?pivots=deployment-language-bicep
*/

param arrResourceTags array

resource append_tag 'Microsoft.Authorization/policyAssignments@2025-03-01' =  [for tag in arrResourceTags: {
  name: 'Policy-append-${tag.name}-tag'
  scope: resourceGroup()
  properties: {
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/2a0e14a6-b0a6-4fab-991a-187a4f81c498'
    description: 'Appends the specified tag and value when any resource which is missing this tag is created or updated. Does not modify the tags of resources created before this policy was applied until those resources are changed. Does not apply to resource groups.'
    displayName: 'Append ${tag.name} tag'
    nonComplianceMessages: [
      {
        message: 'Resource tag needed for ${tag.name}=${tag.value}'
      }
    ]
    parameters: {
      tagName: {value: tag.name}
      tagValue: {value: tag.value}

      }
  }
}]


// author: @willie-de-klerk
