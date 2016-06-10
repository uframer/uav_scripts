#!/bin/bash
if [ $# != "1" ] ; then
    printf "Usage:\n\t$0 <target_dir>\n"
    exit 0
fi
target_dir=$1
root_dir=$PWD
mkdir -p ${target_dir}
cd ${target_dir}
# make target_dir an absolute path
target_dir=$PWD

# install x86 runtimes for arm gcc needed by ardupilot
if [ `uname -m` == "x86_64" ] ; then
    sudo dpkg --add-architecture i386
    sudo apt update
    sudo apt install libc6-dev-i386
fi

ardupilot_dir="ardupilot"
if [ -d ${ardupilot_dir} ] ; then
    cd ${ardupilot_dir}
    git pull || (echo "failed to pull ${ardupilot_dir}" && exit 1)
else
    git clone https://github.com/ArduPilot/ardupilot.git ${ardupilot_dir}
    cd ${ardupilot_dir}
    git submodule init
fi
git submodule update
./Tools/scripts/install-prereqs-ubuntu.sh -y
cd ${target_dir}

echo "You can build for rover by: "
echo "cd ${ardupilot_dir}/APMrover2 && make px4-v2"

echo "You can build for multirotor by: "
echo "cd ${ardupilot_dir}/ArduCopter && make px4-v2"

apm_planner_dir="apm_planner"
if [ -d ${apm_planner_dir} ] ; then
    cd ${apm_planner_dir}
    git pull || (echo "failed to pull ${apm_planner_dir}" && exit 1)
else
    git clone https://github.com/ArduPilot/apm_planner.git ${apm_planner_dir}
    cd ${apm_planner_dir}
    git submodule init
fi
git submodule update
cd ${target_dir}

# sync done
cd ${root_dir}
