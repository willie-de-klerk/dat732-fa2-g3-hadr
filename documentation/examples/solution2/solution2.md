# Table of contents
1. [Solution: using geo-replication](#solution-using-geo-replication)
2. [Deploy Example](#deploy-example)
3. [Deployment Results in Azure Portal](#deployment-results-in-azure-portal)
4. [Testing Failover with a Forced Failover](#testing-failover-with-a-forced-failover)
5. [Cleanup](#cleanup)
# Solution: using geo-replication
![alt_text](images/solution-2-resources.jpg)

**Introduction**
In this example we are using [geo-replication](https://learn.microsoft.com/en-us/azure/azure-sql/database/active-geo-replication-overview?view=azuresql&tabs=tsql) to replicate the company's main logistics database, hosted on azure. This helps us to provide high availability and will prove helpful in the event of a disaster recovery. 

We create two replica instances of ``logisticsdb`` hosted on the following servers:
- logistics-srv-bak-germanywestcentral (Standby , Non-Readable)
- logistics-srv-bak-uksouth (Standby , Readable)
## Prerequisites
The repository should be cloned, azure cli installed and login performed. Should be within the root folder of the repository.

## SQL Admin Login Details
```
Username: AzureAdmin
Password: R78Y9iRo71A5710
```

# Deploy Example
``Please note: This deployment will take some time, please be patient.``

![alt text](images/example-deployment.png)
```
az deployment sub create --template-file solution2.main.bicep --location southafricanorth --parameters parameters/solution2/test.solution2.bicepparam
```

# Deployment Results in Azure Portal

## Deployed resource group
![alt_text](images/portal%20view/portal-view-resource-groups.png)

## Resource Group Overview
![alt_text](images/portal%20view/resource-group-overview.png)

## Logistics database
### Overview
![alt_text](images/portal%20view/portal-view-logistics-db-overview.png)
### Replicas
![alt_text](images/portal%20view/portal-view-replicas.png)

# Testing Failover with a Forced Failover
## Click on ... in replica view
![alt_text](images/portal%20view/navigate-to-forced-failover.png)
## Confirm Forced failover
![](images/portal%20view/portal-view-failover-request-notification.png)
![alt_text](images/portal%20view/confirm-forced-failover.png)

## Verify Replica state
### Pending
![](images/portal%20view/replica-state-pending.png)
### Online
![](images/portal%20view/replica-state-online.png)

# Cleanup
## Navigate to the resource group view
![](images/portal%20view/cleanup-home-view-navigate-resource-groups.png)
## Click on the resource group
![](images/portal%20view/cleanup-resource-group-view-navigate-resource-group.png)
## Click on delete resource group
![](images/portal%20view/cleanup-delete-resource-group.png)
## Enter resoruce group name for deletion
![](images/portal%20view/delete-resource-group-deletion.png)
## Confirm resource group deletion
![](images/portal%20view/confirm-resource-group-deletion.png)