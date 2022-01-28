#!/bin/expect -f

set password [exec cat /root/.secret_vault | openssl enc -aes-256-cbc -md sha512 -d -salt -pass pass:test]
set f [open "/root/filestore/nodes.txt"]
set nodes [split [read $f] "\n"]
close $f

# Launch for each node on the list
foreach node $nodes {
    spawn /usr/share/cb/cbcluster add-node
    expect "*?IP*"
    send "$node/r"
	expect "*?password*"
    send "$password/r"
    expect eof
}