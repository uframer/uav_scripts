#!/bin/bash

################################################################################
# This script is used to send the same command issued as command line argument #
# to each piggy in the farm via ssh.                                           #
# NOTE:                                                                        #
#     * Each piggy should be configured as being able to login via ssh without #
#       password (i.e. authentication with certificates.                       #
#     * Each piggy should own the mDNS hostname in the pattern of              #
#       'piggyN.local'.                                                        #
#     * Each piggy should contain a user 'pi'.                                 #
################################################################################

if [ "$#" != "1" ]; then
	printf "Usage:\t$0 \'command name\'"
	exit 1
fi

for piggy in {1..4}; do
	prompt="[piggy${piggy}.local]"
	printf ${prompt}
	for i in $(seq ${#prompt} 80); do printf "="; done
	printf "\n"
	ssh pi@piggy${piggy}.local "$1"
	printf ${prompt}
	for i in $(seq ${#prompt} 80); do printf "-"; done
	printf "\n"
done

