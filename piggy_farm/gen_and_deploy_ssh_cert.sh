#!/bin/bash

################################################################################
# This script generate RSA key pair and deploy the public key to each piggy.   #
# NOTE                                                                         #
#     # This script should be run on alpha piggy.                              #
################################################################################

echo "Generating RSA key pair ..."
echo "[Please do NOT change key file name]"
echo "[Please do NOT set passphrase]"
ssh-keygen

for piggy in {1..4}; do
	echo "Deploy to piggy${piggy}.local"
	ssh-copy-id -i ~/.ssh/id_rsa.pub piggy${piggy}.local
done

echo "Done"

