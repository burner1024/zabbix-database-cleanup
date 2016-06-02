# Zabbix SQL repo

This repo contains a few useful queries for Zabbix database, mostly to cleanup old and/or orphaned data.

- [Important notes] (#important-notes)
- [Usage] (#usage)
  * [Orphaned data] (#orphaned-data)
  * [Old data] (#old-data)
  * [Unused data] (#unused-data)
  * [Stop email flood] (#stop-email-flood)
  * [LLD triggers] (#lld-triggers)

### Important notes

* If you have a large database please note that these can take a while (a few hours is normal).
* Use the queries on your own risk. Take **backups** first. The queries were (mostly) tested against Zabbix 1.8-3.0.
* Some scripts are Mysql or Postgresql specific, they're named *.my.sql and *.pg.sql, respectively. Some are also Zabbix version specific. Filenames are self-explaining.
* Patches are welcome.

### Usage

#### Orphaned data

Orphaned data is history which belongs to deleted hosts and similar.

    mysql zabbix < check-orphaned-data.sql
    psql -A -R ' : ' -P 'footer=off' zabbix < check-orphaned-data.zbx2x.sql

    mysql zabbix < delete-orphaned-data.sql
    psql -A -R ' : ' -P 'footer=off' zabbix < delete-orphaned-data.zbx2x.sql

#### Old data

This set of queries allows you to delete all data older than a specified period. Default is 1 week for history, 3 months for trends - edit sql at your own discretion.

    mysql zabbix < check-old-data.my.sql
    psql -A -R ' : ' -P 'footer=off' zabbix < check-old-data.pg.sql

    mysql zabbix < delete-old-data.my.sql
    psql -A -R ' : ' -P 'footer=off' zabbix < delete-old-data.pg.sql

### A lot of old data

Speed of DELETE statement in MySQL is very low. Therefore, to remove a very large amount of old data is better to use ALTER, CREATE, INSERT and DROP statements with transfer required data. Another advantage of this method is that on disk frees occupied space without the need to run OPTIMIZE TABLE.

    mysql zabbix < delete-old-big-data.my.sql

#### Unused data

This deletes all history for disabled items. May come in handy when you disable a significant number of items and no longer need the collected data.

    mysql zabbix < check-unused-data.sql
    psql -A -R ' : '  -P 'footer=off' zabbix < check-unused-data.sql

    mysql zabbix < delete-unused-data.sql
    psql -A -R ' : '  -P 'footer=off' zabbix < delete-unused-data.sql

#### Stop email flood

(Use stop-and-delete-email-alerts.sql if you're not interested in alert history)

    sudo service zabbix-server stop
    psql zabbix < stop-email-alerts.sql
    sudo service zabbix-server start

#### LLD triggers

Zabbix will create automatically create "Mounted Filesystem Discovery" triggers, which you can't disable or delete from the web interface. These queries will allow you to delete them all at once (disk space and inodes). [Inspired by](https://www.zabbix.com/forum/showthread.php?t=44028).

    mysql zabbix < check-lld-triggers.my.sql
    psql -A -R ' : '  -P 'footer=off' zabbix < check-lld-triggers.pg.sql

    mysql zabbix < delete-lld-triggers.my.sql
    psql -A -R ' : '  -P 'footer=off' zabbix < delete-lld-triggers.pg.sql
