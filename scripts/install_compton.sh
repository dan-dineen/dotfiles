# This script needs to be run as root

rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
yum -y install epel-release && rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
yum install compton -y

mkdir -p ${HOME}/lib
mkdir -p ${HOME}/bin

cp /usr/bin/compton ${HOME}/bin
ldd /usr/bin/compton | grep -Po '/lib64\S+' | xargs -I {} -n 1 cp {} ${HOME}/lib
