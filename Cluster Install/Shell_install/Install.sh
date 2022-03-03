#!/bin/bash

Timeout=1800 # 30 minutes


echo "Installing RPM"
tar -xzvf /tmp/cb_auto/yumcache.tar.gz -C /
rpm -ivh /tmp/cb_auto/carbon-black-edr.rpm

echo "Installing Carbon Black EDR"
yum install cb-enterprise -y

echo "Installing Expect"
yum install expect -y

echo "Creating answerfile"
chmod 755 /tmp/cb_auto/answer.sh 
/tmp/cb_auto/answer.sh 

echo "Installing Carbon Black EDR Master"
/usr/share/cb/cbinit --no-solr-events /tmp/cb_auto/answer.txt

echo "Installing Carbon Black EDR Cluster Nodes"
chmod 755 /tmp/cb_auto/cluster.sh 
/bin/expect -f /tmp/cb_auto/cluster.sh        

echo "Placing License in /tmp director for use"
cp /tmp/cb_auto/carbon-black-edr.lic /tmp/

echo "Cleanup"
cp /tmp/cb_auto/cleanup.sh /tmp/
/tmp/cleanup.sh
  