#!/bin/expect -f

#SET VARIABLES

set timeout -1
set password [exec cat /root/.secret_vault | openssl enc -aes-256-cbc -md sha512 -d -salt -pass pass:test]
set f [open "/tmp/cb_auto/nodes.txt"]
set nodes [split [read -nonewline $f] "\n"]
close $f
set f [open "/tmp/cb_auto/master.txt"]
set master [split [read -nonewline $f] "\n"]
close $f

#CREATE SSH KEY

spawn ssh-keygen
expect "*?root/.ssh/id_rsa*"
send "\r"
expect "*?passphrase*"
send "\r"
expect "*?passphrase*"
send "\r"
expect eof

# Copy Key to Nodes

foreach node $nodes {
    set node [string trim $node]
    set length [string length $node]
    if {$length > 0} {
    spawn ssh-copy-id $node
    match_max 1000000
    expect "*?connecting*"
    send "yes\r"
    expect "*?password*"
    send "$password\r"
    } else {break}
}
expect eof

#Add Nodes

foreach node $nodes {
    set node [string trim $node]
    set length [string length $node]
    if {$length > 0} {
    exec /usr/share/cb/cbcluster add-node --hostname=$node -m $master
    } else {break}
}

#Start the Cluster

exec /usr/share/cb/cbcluster start

#Clean Up

foreach node $nodes {
    set node [string trim $node]
    set length [string length $node]
    if {$length > 0} {
    spawn ssh $node
    expect "*?#*"
    send "rm -f /root/.ssh/authorized_keys\r"
    expect "*?#*"
    send "exit\r"
    } else {break}
}
expect eof

exec rm -f /root/.secret_vault