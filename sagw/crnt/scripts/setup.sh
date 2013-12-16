#! /bin/bash
# Script to install the Context component using the library crnt
# it asumes ubuntu style operating system
sudo apt-get -y update
sudo apt-get -y install vim cmake-gui g++ subversion build-essential
sudo usermod -a -G dialout $(whoami)

svn co https://redmine.wearcom.org/svn/crnt/branches/toolbox_cmake crnt
cd crnt/

mkdir build
cd build
       -DFEATURE_DEVEL_TASKS_GESPAG_ENABLED=TRUE \
       -DFEATURE_DEVEL_TASKS_ACTLAB_ENABLED=TRUE \
       -DFEATURE_STDTASKS_MATHS_ENABLED=TRUE \
       -DFEATURE_DEVEL_TASKS_ACTLAB_ZOOKEEPER_ENABLED=TRUE ..
make -j5 crntoolbox

cd ../../


