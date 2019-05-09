#!/bin/bash

cd .. # jam-hammer root

echo "Cloning love2D v0.10.0..."
git clone https://github.com/jam-hammer/love2d.git
cd love2d

echo "Configuring and building love2D..."
./platform/unix/automagic
./configure
make

echo "Copying love binary..."
mkdir ../love
cp src/love ../love
cp -r src/.libs ../love

cd .. # jam-hammer root

echo "Removing love2D sources..."
rm -rf love2d



echo "Cloning love.js..."
git clone https://github.com/jam-hammer/love.js.git

echo "Updating submodules..."
cd love.js
git submodule update --init --recursive
cd ..



echo "Cloning SFF..."
git clone https://github.com/SuperFastFramework/sff-love

echo "Updating submodules..."
cd sff-love
git submodule update --init --recursive
cd ..


echo "Creating workspace directory..."
mkdir workspace


echo "Done."


