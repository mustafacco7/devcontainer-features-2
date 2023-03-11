#!/bin/bash

apt-get update -qq && \
    apt-get install openjdk-17-jdk graphviz gnuplot curl wget -y -qq > /dev/null

dir=$(mktemp -d)
echo "Downloading latest release to $dir"

curl -s https://api.github.com/repos/jepsen-io/maelstrom/releases/latest \
| grep "browser_download_url.*tar.bz2" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi - -P $dir

pushd $dir

tar -xf *.tar.bz2

mkdir -p /opt/maelstrom

cp maelstrom/maelstrom /opt/maelstrom/maelstrom
cp -r maelstrom/* /opt/maelstrom
chmod +x /opt/maelstrom/maelstrom

echo "PATH=/opt/maelstrom:$PATH" >> ~/.profile
source ~/.profile

popd
rm -rf $dir