#!/bin/bash

REPO_PATH="/home/savi/SAVI-deployment"
git clone https://github.com/RIT-Election-Security/SAVI-deployment "$REPO_PATH"

echo "Repo downloaded. Status: $?"

# and then we do a bunch of sed replacements to get everything right
sed -i -e 's/<registrar-ip>/${registrar_ip}/' "$REPO_PATH/inventory.yaml"
sed -i -e 's/<ballotbox-ip>/${ballotbox_ip}/' "$REPO_PATH/inventory.yaml"
sed -i -e 's/<ballotserver-ip>/${ballotserver_ip}/' "$REPO_PATH/inventory.yaml"
sed -i -e 's/<resultserver-ip>/${resultserver_ip}/' "$REPO_PATH/inventory.yaml"

sed -i -e 's/<admin-user>/savi/' "$REPO_PATH/group_vars/all.yaml"
sed -i -e 's/<registrar-address>/${registrar_ip}/' "$REPO_PATH/group_vars/all.yaml"
sed -i -e 's/<ballot-box-address>/${ballotbox_ip}/' "$REPO_PATH/group_vars/all.yaml"
sed -i -e 's/<ballot-server-address>/${ballotserver_ip}/' "$REPO_PATH/group_vars/all.yaml"
sed -i -e 's/<result-server-address>/${resultserver_ip}/' "$REPO_PATH/group_vars/all.yaml"
sed -i -e '/ansible_password/d' "$REPO_PATH/group_vars/all.yaml"
sed -i -e '/ansible_become_pass/d' "$REPO_PATH/group_vars/all.yaml"

sed -i -e 's/<facility-name>/${facility_name}/' "$REPO_PATH/group_vars/all.yaml"
sed -i -e 's/<launch-code-seed>/${launch_code_seed}/' "$REPO_PATH/group_vars/all.yaml"
sed -i -e 's/<shared-key>/${shared_key}/' "$REPO_PATH/group_vars/all.yaml"

# these are dependent on the location that reconstitute-files.sh puts these in
sed -i -e 's/election_manifest_file_path:/election_manifest_file_path: \/home\/savi\/manifest.json/' "$REPO_PATH/host_vars/ballotserver.yaml"
sed -i -e 's/voter_registration_data_file_path:/voter_registration_data_file_path: \/home\/savi\/voter_data.json/' "$REPO_PATH/host_vars/registrar.yaml"

echo "Repo templated. Final sed status: $?"

chown -R savi:savi /home/savi/SAVI-deployment
echo "Repo chowned to savi:savi. Status: $?"

echo "${registrar_ip} registrar" >> /etc/hosts
echo "${ballotbox_ip} ballotbox" >> /etc/hosts
echo "${ballotserver_ip} ballotserver" >> /etc/hosts
echo "${resultserver_ip} resultserver" >> /etc/hosts
echo "Added hostnames for other VMs to /etc/hosts"

cat << EOF > /home/savi/.ssh/id_rsa
${ssh_privkey}
EOF
cp /home/savi/.ssh/id_rsa /root/.ssh/id_rsa
echo "Created SSH private key"

cat << EOF > /home/savi/manifest.json
${election_manifest}
EOF
echo "Created election manifest"

# TODO: pass voter data in through some other GCP feature (current setup won't scale)
cat << EOF > /home/savi/voter_data.json
${voter_data}
EOF
echo "Created voter data"

chown savi:savi /home/savi/.ssh/id_rsa
chown savi:savi /home/savi/manifest.json
chown savi:savi /home/savi/voter_data.json
chmod 0600 /home/savi/.ssh/id_rsa
echo "Set permissions and ownership on created files"

pip install --upgrade pip
pip install cryptography netaddr
echo "Updated pip, cryptography, netaddr"

su -c 'ansible-galaxy collection install community.crypto' -l savi
echo "Installed community.crypto for the savi user"

STIG_PATH="/home/savi/ubuntu1804STIG-ansible"
wget https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/U_CAN_Ubuntu_18-04_LTS_V2R7_STIG_Ansible.zip -O /tmp/U_CAN_Ubuntu_18-04_LTS_V2R7_STIG_Ansible.zip
unzip /tmp/U_CAN_Ubuntu_18-04_LTS_V2R7_STIG_Ansible.zip -d /tmp/STIG
unzip /tmp/STIG/ubuntu1804STIG-ansible.zip -d $STIG_PATH
sed -i -e 's/ubuntu1804STIG_stigrule_219167_Manage: True/ubuntu1804STIG_stigrule_219167_Manage: False/' "$STIG_PATH/roles/ubuntu1804STIG/defaults/main.yml"
sed -i -e 's/ubuntu1804STIG_stigrule_219170_Manage: True/ubuntu1804STIG_stigrule_219170_Manage: False/' "$STIG_PATH/roles/ubuntu1804STIG/defaults/main.yml"
chown -R savi:savi /home/savi/ubuntu1804STIG-ansible
mv "$STIG_PATH/roles/ubuntu1804STIG" "$REPO_PATH/roles/ubuntu1804STIG"
cp "$REPO_PATH/inventory.yaml" "$REPO_PATH/inventory-STIG.yaml"
sed -i -e 's/ansible_become: false/ansible_become: true/' "$REPO_PATH/inventory-STIG.yaml"
echo "Downloaded STIG ansible"