# dat732-fa2-g3-hadr
![](/documentation/question.png)

We have created three solutions using [bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep) for resource deployment. Our solutions demonstrate three different azure features: 
1. [Failover groups](/documentation/examples/solution1/solution1.md)
2. [Geo-replication](/documentation/examples/solution2/solution2.md)
3. [Backup and restore](/documentation/examples/solution3/solution3.md)

**Best solution: Solution2-(Geo-replication)**
In an ideal scenario we recommend the use of geo-replication as it will help us meet their recovery time objectives.

*Cost considerations*
We have made it possible to implement budget friendly service tiers within our solution, with our examples using compute from the general purose tier, and our geo-replication utilizing both the Geo and Standby secondary types. 

In a production environment we would be able to achieve a secondary database instance cost reduction of 40% for the one secondary instance due to having one secondary as a Standby instead of both being Geo secondary types. 

*[Disaster recovery drill](https://learn.microsoft.com/en-us/azure/azure-sql/database/disaster-recovery-drills?view=azuresql)*
Within our documentation we executed a forced failover from the azure portal to verify that the solution works as intended. 

*Data Residency Considerations*
South Africa protect's it's citizens through the [POPIA](https://www.gov.za/sites/default/files/gcis_document/201409/3706726-11act4of2013protectionofpersonalinforcorrect.pdf) act. With this in consideration implemented our geo replicas in [azure regions](https://docs.azure.cn/en-us/reliability/regions-overview) that have similar personal data protection regulations. We chose to deploy our replicas within the borders of the european union, as it has the [GDPR](https://gdpr-info.eu/) regulations. 

Quick Links
- [Documentation](/documentation/documentation.md)