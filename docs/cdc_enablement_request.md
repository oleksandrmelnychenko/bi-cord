# CDC Enablement Request Package

Provide the following bundle to the database and network teams when requesting Change Data Capture (CDC) access for the BI platform.

## Cover Email Template

```
Subject: Request to Enable CDC for Cord Analytics Platform

Hi <DBA / Network>,

We are preparing the on-prem BI/AI platform and need Change Data Capture streams from the Cord SQL Server instance (<instance name>). Please see the attached checklist and information summary. Let us know if you need further details or if a meeting would help.

Thanks,
<Your Name>
```

## Summary Sheet

| Item | Value / Notes |
|------|---------------|
| Source SQL Server instance | |
| Databases | |
| Tables requested | `dbo.Product`, `dbo.[Order]`, `dbo.OrderItem`, `dbo.Sale`, `dbo.Client`, ... |
| Target connector hostnames | |
| Required ports | 1433/TCP (SQL Server), 9092/TCP (Kafka brokers), 8083/TCP (Kafka Connect REST) |
| Planned retention | min. 3 days (align with ingestion SLA) |
| Go-live timeline | |
| Primary contact | |
| Backup contact | |

## Attachments

1. `sql_server_cdc_checklist.md` — detailed steps for enabling CDC and configuring Debezium.
2. Network diagram (fill once available) showing connector placement and traffic flow.
3. Security requirements (who will own credentials, how they are stored).

## Meeting Agenda (If Required)

1. Review CDC scope and expected load.
2. Walk through firewall changes and monitoring hooks.
3. Confirm backup impact and log growth monitoring plan.
4. Establish test window and rollback procedure.

## Sign-offs

| Team | Representative | Approval Date | Notes |
|------|----------------|---------------|-------|
| DBA | | | |
| Network | | | |
| Security | | | |
| Platform | | | |
