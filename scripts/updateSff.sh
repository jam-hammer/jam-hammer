#!/bin/bash

echo "Updating SFF..."
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $DIR/../sff-love
git pull

echo "Done."
