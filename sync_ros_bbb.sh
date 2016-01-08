#!/bin/bash
echo "You must enable universe, multiverse and restricted sources in /etc/apt/sources.list before running this script or you fill encounter install failure of some packages. Press ENTER to continue, or press CTRL-C to quit:"
read

if  [ $# != 1 ] ; then
    printf "Usage:\n\t$0 <workspace dir>"
    exit 1
fi

workspace_dir=$1

sudo apt-get update
sudo apt-get install python-pip
sudo pip install --upgrade setuptools

# Build from source because ROS armhf prebuilts can only support 14.04
sudo pip install -U rosdep rosinstall_generator wstool rosinstall

sudo rosdep init
rosdep update

mkdir -p ${workspace_dir}
cd ${workspace_dir}

# Uncomment the following lines to install ROS-Comm: ROS package, build, and communication libraries. No GUI tools.
rosinstall_generator ros_comm --rosdistro jade --deps --wet-only --tar > jade-ros_comm-wet.rosinstall
wstool init -j8 src jade-ros_comm-wet.rosinstall

# Uncomment the following lines to install Desktop: ROS, rqt, rviz, and robot-generic libraries
#rosinstall_generator desktop --rosdistro jade --deps --wet-only --tar > jade-desktop-wet.rosinstall
#wstool init -j8 src jade-desktop-wet.rosinstall

# Uncomment the following lines to install Desktop-Full: ROS, rqt, rviz, robot-generic libraries, 2D/3D simulators, navigation and 2D/3D perception
# rosinstall_generator desktop_full --rosdistro jade --deps --wet-only --tar > jade-desktop-full-wet.rosinstall
# wstool init -j8 src jade-desktop-full-wet.rosinstall

# Check build dependencies
rosdep install --from-paths src --ignore-src --rosdistro jade -y

# Build!
./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release

# Source environments, you may want to add this to your .bashrc or .bash_profile
source ~/ros_catkin_ws/install_isolated/setup.bash
