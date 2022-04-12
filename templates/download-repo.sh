#!/bin/bash

REPO_PATH="/home/savi/SAVI-deployment"
git clone https://github.com/RIT-Election-Security/SAVI-deployment "$REPO_PATH"

echo "Repo downloaded. Status :$?"

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

sed -i -e 's/<facility-name>/${facility_name}/' "$REPO_PATH/group_vars/all.yaml"
sed -i -e 's/<launch-code-seed>/${launch_code_seed}/' "$REPO_PATH/group_vars/all.yaml"
sed -i -e 's/<shared-key>/${shared_key}/' "$REPO_PATH/group_vars/all.yaml"

# these are dependent on the location that reconstitute-files.sh puts these in
sed -i -e 's/election_manifest_file_path: /election_manifest_file_path: \/home\/savi\/manifest.json/' "$REPO_PATH/host_vars/ballotserver.yaml"
sed -i -e 's/voter_registration_data_file_path: /voter_registration_data_file_path: \/home\/savi\/voter_data.json/' "$REPO_PATH/host_vars/registrar.yaml"

echo "Repo templated. Final sed status: $?"

chown -R savi:savi /home/savi/SAVI-deployment
echo "Repo chowned to savi:savi. Status: $?"