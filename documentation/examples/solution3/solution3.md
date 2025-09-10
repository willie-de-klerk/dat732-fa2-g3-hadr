# Solution 3 using backup and restore
Since the company is making use of azure SQL databases we can leverage the automated backup feature for Azure SQL Databases. The backups allow us to restore to a point in time within the configured retention period, set via the respective retention policy. 

Azure SQL Database automatically creates the following backups:
1. [Full backups](https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/full-database-backups-sql-server?view=sql-server-ver17)
    - Frequency: weekly.
    - Purpose: Allows us to back up their entire logistics database. 
2. [Differential backups](https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/differential-backups-sql-server?view=sql-server-ver17)
    - Frequency: every 12 - 24 hours.
    - Purpose: Allows us to back up and restore only the data that has changed since the last full backup. It's beneficial since it will allow us to have backups without the overhead of full backups.
3. [Transaction log backups](https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/transaction-log-backups-sql-server?view=sql-server-ver17) 
    - Frequency: give or take every +10 minutes.
    - Purpose: After having our full backup we can use the transaction log backup to minimize work loss.
### Short term retention policy
![](/documentation/examples/solution3/images/az-cli/az-cli-ltr-policy-show.png)
### Long term retention policy
![](/documentation/examples/solution3/images/az-cli/az-cli-str-policy-show.png)


# Example Deployment
## Region Considerations 
My personal student azure subscription has expired. With the azure accounts that ctu has made for us, we are now limited to deployment in certain regions, via a policy that an administrator has implemented. 
![](/documentation/examples/solution3/images/region-restriction/policy-overview.png)

![](/documentation/examples/solution3/images/region-restriction/policy-assignment-view.png)

*Allowed regions*
```
["austriaeast","uaenorth","brazilsouth","italynorth","centralindia"]
```
## Deploy example
![](/documentation/examples/solution3/images/az-cli/az-cli-test-deployment.png)

```
 az deployment sub create --template-file solution3.main.bicep --location southafricanorth --parameters parameters/solution3/test.solution3.bicepparam
```

## Azure Portal view

### Resource Group Overview

![](/documentation/examples/solution3/images/az-portal/resource-group-overview.png)

### Backup retention policy on logistics-srv

![](/documentation/examples/solution3/images/az-portal/logistics-srv-backups-retention-policy.png)

### Restoring from long term retention policy backups
![](/documentation/examples/solution3/images/az-portal/restore-long-term-backup-retention.png)

We haven't had this running long enough to have a backup created by our long term retention policy, but if we did we would use it here. 

### Restoring using point in time restore ([PITR](https://docs.azure.cn/en-us/azure-sql/managed-instance/recovery-using-backups?tabs=azure-portal#point-in-time-restore))

#### Project details and Source Details

![](/documentation/examples/solution3/images/az-portal/point-in-time-restore-project-and-source-details.png)

#### Database details

![](/documentation/examples/solution3/images/az-portal/point-in-time-restore-database-details.png)

#### Review

![](/documentation/examples/solution3/images/az-portal/point-in-time-restore-review.png)

### Logistics SQL Server overview

![](/documentation/examples/solution3/images/az-portal/logistics-srv-overview.png)

# Cleanup

![](/documentation/examples/solution3/images/az-cli/cleanup.png)

```
az group delete --name group3hadr-rg
```