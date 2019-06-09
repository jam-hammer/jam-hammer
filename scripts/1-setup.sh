#!/bin/bash

cd .. # jam-hammer root

echo "Cloning love2D v0.10.0..."
git clone https://github.com/jam-hammer/love2d.git
cd love2d

# TODO: install love dependencies

echo "Configuring and building love2D..."
./platform/unix/automagic
./configure
make

echo "Copying love binary..."
mkdir ../love
cp src/love ../love
cp -r src/.libs ../love

cd .. # jam-hammer root

echo "Downloading love win32.zip for the .exe export..."
cd love
wget https://bitbucket.org/rude/love/downloads/love-0.10.0-win32.zip

cd .. # jam-hammer root

echo "Removing love2D sources..."
rm -rf love2d



echo "Cloning love.js..."
git clone https://github.com/jam-hammer/love.js.git

echo "Updating submodules..."
cd love.js
git submodule update --init --recursive
cd .. # jam-hammer root



echo "Cloning SFF..."
git clone https://github.com/SuperFastFramework/sff-love

echo "Updating submodules..."
cd sff-love
git submodule update --init --recursive
cd .. # jam-hammer root

echo "Building Jam Hammer UI"
cd ui
../love/love .
cd .. # jam-hammer root

echo "Creating workspace directory..."
mkdir workspace

echo "Copying newProject script to root..."
cp scripts/4-newProject.sh newProject.sh

echo "Done."


