#!/bin/bash

# As far as I can tell, this is somehow the best way to do it
# this gets the SSH privkey templated in inside of a heredoc and then writes it and sets the perms

cat << EOF > /home/savi/.ssh/id_rsa
${ssh_privkey}
EOF

chown savi.savi /home/savi/.ssh/id_rsa
chmod 0600 /home/savi/.ssh/id_rsa