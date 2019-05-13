#!/bin/bash
echo "Assuming you already executed setup.sh"
echo "Installing love to path..."
sudo ln -s $(pwd)/../love/love /usr/local/bin/love
echo "Done."
