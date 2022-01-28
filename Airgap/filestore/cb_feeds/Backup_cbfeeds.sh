#!/bin/bash

echo "Create Working Directories"
mkdir /tmp/cbfeeds/
mkdir /var/cb/data/solr/cbfeeds/data/archive/

echo "Move Existing Snapshots to Archive"
mv /var/cb/data/solr/cbfeeds/data/snapshot* /var/cb/data/solr/cbfeeds/data/archive/

echo "Backup CBFEEDS from SOLR"
curl http://localhost:8080/solr/cbfeeds/replication?command=backup&wt=json

sleep 30

#The following command can be used to check the status of the solr backup
#curl http://localhost:8080/solr/cbfeeds/replication?command=details&wt=json

echo "Set Snapshot Variable for Use"
ls /var/cb/data/solr/cbfeeds/data/ | grep snapshot.20 | cut -d'.' -f 2 > /tmp/cbfeeds/value
snapshot=$(ls /var/cb/data/solr/cbfeeds/data/ | grep snapshot.20 | cut -d'.' -f 2)

echo "Tar the SOLR Backup for Transfer"
tar -czvf /tmp/cbfeeds_solr.tar.gz /var/cb/data/solr/cbfeeds/data/snapshot.$snapshot
mv /tmp/cbfeeds_solr.tar.gz /tmp/cbfeeds/

echo "Backup CBFEEDS from POSTGRES"
psql -p 5002 -d cb -c "\copy alliance_feeds to /tmp/cbfeeds/alliance_feeds.csv delimiter ',' csv header;"

sleep 30

echo "Tar the CBFEEDS Directory for Transfer"
tar -czvf /tmp/cbfeeds.tar.gz /tmp/cbfeeds

echo "Clean Up!!!"
mv /var/cb/data/solr/cbfeeds/data/archive/snapshot* /var/cb/data/solr/cbfeeds/data/
rmdir /var/cb/data/solr/cbfeeds/data/archive/
rm -rf /tmp/cbfeeds