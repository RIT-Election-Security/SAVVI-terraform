#!/bin/bash

# As far as I can tell, this is somehow the best way to do it
# this gets all the files we need templated in inside of a heredoc and then writes it and sets the perms

cat << EOF > /home/savi/.ssh/id_rsa
${ssh_privkey}
EOF
echo "Created SSH private key"

cat << EOF > /home/savi/manifest.json
${election_manifest}
EOF
echo "Created election manifest"

cat << EOF > /home/savi/voter_data.json
${voter_data}
EOF
echo "Created voter data"

chown savi:savi /home/savi/.ssh/id_rsa
chown savi:savi /home/savi/manifest.json
chown savi:savi /home/savi/voter_data.json
chmod 0600 /home/savi/.ssh/id_rsa
echo "Set permissions and ownership on created files"