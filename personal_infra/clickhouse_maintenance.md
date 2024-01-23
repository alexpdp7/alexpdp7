```
$ ssh clickhouse...
$ clickhouse-client
$ use system;
$ SELECT
    table,
    formatReadableSize(sum(bytes)) AS size,
    min(min_date) AS min_date,
    max(max_date) AS max_date
FROM system.parts
WHERE active
GROUP BY table
ORDER BY sum(bytes) ASC
$ truncate table ...
```
