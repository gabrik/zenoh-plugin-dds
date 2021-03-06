#!/bin/bash

pushd $PWD &>/dev/null

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     target=Linux;;
    *)          target=Other
esac

if [ ! -e /usr/local/include/dds/ddsc/dds_public_impl.h  ];
then
    mkdir deps &>/dev/null
    cd deps

    git clone https://github.com/eclipse-cyclonedds/cyclonedds.git
    mkdir cyclonedds/build
    cd cyclonedds/build
    cmake ..
    if [ $target == "Linux" ];
    then
        sudo make install
    else
        make install
    fi
else
    echo "Cyclone is already installed, skipping installation."
fi
popd &>/dev/null
pushd $PWD
if [ !  -e /usr/local/include/cdds/cdds_util.h  ];
then
    mkdir deps &>/dev/null
    cd deps

    git clone https://github.com/kydos/cyclocut.git
    mkdir cyclocut/build
    cd cyclocut/build
    cmake ..
    if [ $target == "Linux" ];
    then
        sudo make install
    else
        make install
    fi
    cd ../../..
else
    echo "Cyclocut is already installed, skipping installation."
fi
popd &>/dev/null
hash cargo 2>/dev/null
if [[ ( "$?" != 0 ) && $target == "Linux" ]];
then
    curl https://sh.rustup.rs -sSf | sh
else
    echo "Cargo is already installed, skipping installation."
fi
echo "Cleaning up."
rm -Rf deps
