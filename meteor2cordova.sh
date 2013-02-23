#!/bin/bash

set +o verbose

IP=$(python -c 'import socket; s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM); s.connect(("google.com", 80)); print s.getsockname()[0]')
URL=${1-$IP:3000}

echo Turning $URL into a Phonegap app
echo Make sure an unminified Meteor app is running on $URL
echo "(i.e. on localhost or through meteor deploy --debug)"
rm -rf cordovaapp $URL

mkdir -p downloads
cd downloads  # There's probably a wget option for this, but what the hack
wget -e robots=off -E -k -K -p $URL
cd ..

cordova create cordovaapp
cd cordovaapp
mv www/index.html www/index-cordova-orig.html
cp -a ../downloads/$URL/* www/

cordova platform add android

sed -i.bak 's#</head>#<script type="text/javascript">Meteor._Stream._toSockjsUrl = function(e) { return "http://$URL/sockjs" }</script></head>#g' www/index.html

sed -i.bak s/HelloCordova/$URL/g www/config.xml

echo 'Now building the .apk'
cordova build
cordova compile android

# somehow I can't manage cordova to install stuff yet
adb install -r $(find .|grep apk$|grep -v unaligned)