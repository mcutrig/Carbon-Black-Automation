#!/bin/bash

#SET PASSWORD VARIABLE
passwd=$(cat /root/.secret_vault | openssl enc -aes-256-cbc -md sha512 -d -salt -pass pass:test)

echo "[Config]
root_storage_path=/var/cb/data
admin_username=cbadmin
admin_first_name=Michael
admin_last_name=Cutright
admin_email=mcutright@vmware.com
admin_password=$passwd
service_autostart=0
force_reinit=1
default_sensor_server_url=https://127.0.0.1:443
alliance_comms_enabled=1
alliance_statistics_enabled=1
alliance_bit9_hashes_enabled=1
alliance_bit9_binaries_enabled=1" > /tmp/cb_auto/answer.txt