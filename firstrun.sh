#!/bin/bash

set +o verbose

# cd "(dirname "$0")"

# A bit crude but good for getting started
killall node mongod
rm -rf cordovaapp localhost3000 meteorapp

# First create the Meteor app 
meteor create --example leaderboard meteorapp
cd meteorapp && meteor && cd .. & 

# cd "(dirname "$0")"

# Then fetch it
sleep 3
rm -rf localhost3000
wget -E -H -k -K -p localhost:3000 
mv localhost\:3000 localhost3000

cordova create cordovaapp
cd cordovaapp
mv www/index.html www/index-cordova-orig.html
cp -a ../localhost3000/* www/

cordova platform add android

IP=$(python -c 'import socket; s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM); s.connect(("google.com", 80)); print s.getsockname()[0]')
echo "Your IP is probably $IP, let's use this for the app for now"
echo 73a74 > stream_client_url.patch
echo ">     url = \"http://$IP:3000/\"; // Hack to connect to a specific Meteor server" >> stream_client_url.patch
echo 102a104 >> stream_client_url.patch
echo ">     url = \"http://$IP:3000/\"; // Hack to connect to a specific Meteor server" >> stream_client_url.patch
 
cat stream_client_url.patch

patch -p0 $(find www|grep stream_client) < stream_client_url.patch
echo 'Now building the .apk'
cordova build
cordova compile android

# somehow I can't manage cordova to install stuff yet
adb install -r $(find .|grep apk$|grep -v unaligned)