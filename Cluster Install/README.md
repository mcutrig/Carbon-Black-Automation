# NOTES

Every environment is different and the package may need to be edited to accomodate your deployed linux image.

Update the IPs in nodes.txt and master.txt.

Update the needed values for the answer.sh (This creates the answerfile in the working directory).

These scripts have been developed to work together for a cluster install WITH internet connection.

The encrypted password referenced using OPENSSL in the Add_Cluster_Node script will need to be generated on your Ansible server and the passphrase updated in the script.

***EXAMPLES***

Note the password for server access is after the echo.  The passphrase used to encypt the password in this example is pass:test.  Update as needed.

echo "Passw0rD@#2" | openssl enc -aes-256-cbc -md sha512 -salt -pass pass:test > /root/.secret_vault
cat /root/.secret_valut | openssl enc -aes-256-cbc -md sha512 -d -salt -pass pass:test

You will need to place your EDR RPM and license in the filestore. You can name these files for what they are referenced in the YMLs or you can adjust the YMLs to use your filenames.


