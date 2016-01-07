#!/bin/bash
echo "You must enable universe, multiverse and restricted sources in /etc/apt/sources.list before running this script. Press ENTER to continue, or press CTRL-C to quit:"
read
sudo apt-get update
sudo apt-get install python-pip
sudo pip install --upgrade setuptools

# Build from source because ROS armhf prebuilts can only support 14.04
sudo pip install -U rosdep rosinstall_generator wstool rosinstall

sudo rosdep init
rosdep update
