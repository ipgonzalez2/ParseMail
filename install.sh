#!/bin/sh

echo "Installing BCC..."
sudo apt-get install bpfcc-tools linux-headers-$(uname -r)
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4052245BD4284CDD
echo "deb https://repo.iovisor.org/apt/$(lsb_release -cs) $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/iovisor.list
sudo apt-get update
sudo apt-get install bcc-tools libbcc-examples linux-headers-$(uname -r)
echo "deb [trusted=yes] https://repo.iovisor.org/apt/$(lsb_release -cs) $(lsb_release -cs)-nightly main" | sudo tee /etc/apt/sources.list.d/iovisor.list
sudo apt-get update
sudo apt-get install bcc-tools libbcc-examples linux-headers-$(uname -r)

sudo apt install -y bison build-essential cmake flex git libedit-dev python zlib1g-dev libelf-dev

case $(lsb_release -cs) in:
    bionic)
        sudo apt install -y libllvm6.0 llvm-6.0-dev libclang-6.0-dev
        ;;
    eoan)
        sudo apt install -y libllvm7 llvm-7-dev libclang-7-dev
        ;;
    *)
        sudo apt install -y libllvm3.7 llvm-3.7-dev libclang-3.7-dev
esac

git clone https://github.com/iovisor/bcc.git
mkdir bcc/build; cd bcc/build
cmake ..
make
sudo make install
cmake -DPYTHON_CMD=python3 .. 
make
sudo make install
popd

sudo apt install python-pip
pip install pyinotify
pip install Jinja2
echo "Installing parse-mail..."
cd /usr/share/bcc/examples/networking/
sudo git clone https://github.com/ipgonzalez2/parse-mail
cd /usr/share/bcc/examples/networking/parse-mail
sudo rm -r test utils_test.py
echo "Installation completed"



