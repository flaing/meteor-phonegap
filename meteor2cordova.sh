#!/bin/bash

# Turn Meteor app into Phonegap app.
#
# (c) 2013 Kasper Souren
# See LICENSE
#
#

# Fetch IP address that is probably accessible on local network
IP=$(python -c 'import socket; s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM); s.connect(("www.eff.org", 80)); print s.getsockname()[0]')
URL=${1-$IP:3000}

echo "Let's turn $URL into a Phonegap app"

rm -rf cordovaapp downloads/$URL

mkdir -p downloads
cd downloads  # There's probably a wget option for this, but what the hack
wget -e robots=off -E -k -K -p $URL
cd ..

cordova create cordovaapp
cd cordovaapp
mv www/index.html www/index-cordova-orig.html
cp -a ../downloads/$URL/* www/


sed -i.bak 's#</head>#<script type="text/javascript">Meteor._Stream._toSockjsUrl = function(e) { return "http://$URL/sockjs" }</script></head>#g' www/index.html

sed -i.bak s/HelloCordova/$URL/g www/config.xml
NAME=$(echo $URL|sed s/\[\\.\:\]/\./g)   # Remove dots
echo "Widget id: $NAME"
# This time no backup
sed -i.bak s/hellocordova/$NAME/ www/config.xml

cordova platform add android

echo 'Now building the .apk'
cordova build
cordova compile android

# Somehow I can't get cordova to install stuff
APK=$(find .|grep apk$|grep -v unaligned)
echo -e "\nNow trying to install $APK"
adb install -r $APK