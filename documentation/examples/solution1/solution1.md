# Solution 1 (Failover Groups)
## Table of contents
1. [What is failover groups?](#what-is-failover-groups)
2. [Test deployment command](#test-deployment-command)
3. [Azure Portal Overview](#azure-portal-view)
4. [Failover Group View](#failover-group-view-logistics-srv-fog)
5. [Clean up resources](#clean-up-resources)
## What is failover groups?
Failover groups is a feature from [Microsoft Azure](https://portal.azure.com) that allows us to manage the replication and failover of the logistics company's database that is on a logical server (logistics-srv/logisticsdb) located in south africa to another logical server in another region (logistics-srv-bak-uksouth/logisticsdb). 

**Endpoint redirection**
The failover group functionality known as endpoint redirection allows us to create a read-write listener endpoint that remains unchanged during failover operations. Their applications and customers won't have to specify a different connection string in the event that a disaster occurs. 

**Failover Policy**
We are making use of the Microsoft Manged failover policy, instead of the customer managed failover policy. If there is an outage that impacts the company's database logically contained within their primary server hosted in south africa, microsoft will initiate a failover to the secondary database hosted within the logical server (logistics-srv-bak-uksouth). 

With automatic failover we are required to specify a ``failoverWithDataLossGracePeriodMinutes`` value, which is the grace period before failover with data loss will be attempted for our read-write endpoint.  We specified this value to be the minimal value of ``60`` minutes.

For more information on failover groups, please visit this [page](https://learn.microsoft.com/en-us/azure/azure-sql/database/failover-group-sql-db?view=azuresql).
## Test deployment command
![screenshot of deployment command on windows](/documentation/examples/solution1/images/azure-cli/deploy-with-test-variables.png)
```
az deployment sub create --template-file solution1.main.bicep --location southafricanorth --parameters parameters/solution1/test.solution1.bicepparam
```

## Azure Portal view

### Resource group (g3hadr-rg)

![An overview of the deployed resource gruops](/documentation/examples/solution1/images/azure-portal/overview/resource-groups-overview.png)

![](/documentation/examples/solution1/images/azure-portal/overview/resources-in-resource-group.png)
### Deployments in resource group

![A view of the deployments made within the resource group](/documentation/examples/solution1/images/azure-portal/overview/deployments.png)

## Failover Group View (logistics-srv-fog)
### Configuration details
![](/documentation/examples/solution1/images/azure-portal/failover-group-view/configuration-details.png)
### Databases within failover group
![](/documentation/examples/solution1/images/azure-portal/failover-group-view/databases-within-failover-group.png)

# Clean up resources
![](/documentation/examples/solution1/images/azure-cli/cleanup-resources.png)
```
az group delete --name g3hadr-rg
```