I track some health metrics on self-hosted infrastructure.

[schema.sql](schema.sql) is a PostgreSQL database schema with the health metrics tables.
The `zqxjk` schema uses [zqxjkcrud](https://github.com/alexpdp7/zqxjkcrud/) to generate a frontend where I can input metrics.
Dashboards in Grafana display the metrics.
