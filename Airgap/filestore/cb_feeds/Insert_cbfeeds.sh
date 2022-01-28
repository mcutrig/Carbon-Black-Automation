#!/bin/bash


#Place the cbfeeds.tar.gz into /tmp before starting the script

echo "Untar the files to Complete the Transfer"
echo "*****Untar Directory*****"

tar -xzvf /tmp/cbfeeds.tar.gz -C /

echo "*****Untar SOLR for Restore*****"

tar -xzvf /tmp/cbfeeds/cbfeeds_solr.tar.gz -C /

echo "Insert Data into PostGres for CBFEEDS"
psql -p 5002 -d cb -c "delete from alliance_feeds"
psql -p 5002 -d cb -c "\copy alliance_feeds from /tmp/cbfeeds/alliance_feeds.csv delimiter ',' csv header;"

sleep 30

echo "Set Value for SOLR Snapshot"
snapshot=$(cat /tmp/cbfeeds/value)

echo "Insert Data into SOLR for CBFEEDS"
curl http://localhost:8080/solr/cbfeeds/replication?command=restore&name=$snapshot

sleep 30

#This is the URL to check the status of the SOLR restore
#curl http://localhost:8080/solr/cbfeeds/replication?command=restorestatus&wt=json

echo "Clean Up!!!"
rm -rf /tmp/cbfeeds