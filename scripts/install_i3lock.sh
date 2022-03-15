
_0=$(dirname "$0")
_0=$(realpath "$_0")
DOTFILES=$(dirname "$_0")

rm -rf ${DOTFILES}/build/i3lock
mkdir -p ${DOTFILES}/build/i3lock
cd ${DOTFILES}/build/i3lock
git clone https://github.com/i3/i3lock.git

sudo yum install -y http://mirror.centos.org/centos/7/extras/x86_64/Packages/libev-4.15-7.el7.x86_64.rpm
sudo yum install -y epel-release

mkdir -p ${HOME}/lib
mkdir -p ${HOME}/bin

cp /usr/bin/i3lock ${HOME}/bin
ldd /usr/bin/i3lock | grep -Po '/lib64\S+' | xargs -I {} -n 1 cp {} ${HOME}/lib
