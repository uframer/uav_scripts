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

# remove modemmanager for conflicts of serial tools
sudo apt remove modemmanager
# for building
sudo apt install python-argparse git wget zip python-empy qtcreator cmake \
    genromfs -y
# for simulation
sudo apt install ant protobuf-compiler libeigen3-dev libopencv-dev \
    default-jdk default-jre clang lldb -y

px4_hardware_dir="px4_hardware"
px4_bootloader_dir="px4_bootloader"
px4_firmware_dir="px4_firmware"
px4flow_firmware_dir="px4flow_firmware"

if [ -d ${px4_hardware_dir} ] ; then
    cd ${px4_hardware_dir}
    git pull || (echo "failed to pull ${px4_hardware_dir}" && exit 1)
else
    git clone https://github.com/PX4/Hardware.git ${px4_hardware_dir}
fi
cd ${target_dir}

if [ -d ${px4_bootloader_dir} ] ; then
    cd ${px4_bootloader_dir}
    git pull || (echo "failed to pull ${px4_bootloader_dir}" && exit 1)
else
    git clone https://github.com/PX4/Bootloader.git ${px4_bootloader_dir}
    cd ${px4_bootloader_dir}
    git submodule init
fi
git submodule update
cd ${target_dir}

if [ -d ${px4_firmware_dir} ] ; then
    cd ${px4_firmware_dir}
    git pull || (echo "failed to pull ${px4_firmware_dir}" && exit 1)
else
    git clone https://github.com/PX4/Firmware.git ${px4_firmware_dir}
    cd ${px4_firmware_dir}
    git submodule init
fi
git submodule update
cd ${target_dir}

if [ -d ${px4flow_firmware_dir} ] ; then
    cd ${px4flow_firmware_dir}
    git pull || (echo "failed to pull ${px4flow_firmware_dir}" && exit 1)
else
    git clone https://github.com/PX4/Flow.git ${px4flow_firmware_dir}
    cd ${px4flow_firmware_dir}
    git submodule init
fi
git submodule update
cd ${target_dir}

# sync done
cd ${root_dir}
