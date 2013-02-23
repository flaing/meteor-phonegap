#!/bin/bash

set +o verbose

IP=$(python -c 'import socket; s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM); s.connect(("google.com", 80)); print s.getsockname()[0]')
URL=${1-$IP:3000}

echo Turning $URL into a Phonegap app
echo Make sure an unminified Meteor app is running on $URL
echo "(i.e. on localhost or through meteor deploy --debug)"
rm -rf cordovaapp $URL
wget -e robots=off -E -H -k -K -p $URL

cordova create cordovaapp
cd cordovaapp
mv www/index.html www/index-cordova-orig.html
cp -a ../$URL/* www/

cordova platform add android

echo "Patching the Meteor code based on this http://blog.snowflax.com/meteor-on-mobile-device-using-phonegap/"
echo 73a74 > stream_client_url.patch
echo ">     url = \"http://$URL/\"; // Hack to connect to a specific Meteor server" >> stream_client_url.patch
echo 102a104 >> stream_client_url.patch
echo ">     url = \"http://$URL/\"; // Hack to connect to a specific Meteor server" >> stream_client_url.patch

sed -i.bak s/HelloCordova/$URL/g www/config.xml

cat stream_client_url.patch

patch -p0 $(find www|grep stream_client) < stream_client_url.patch
echo 'Now building the .apk'
cordova build
cordova compile android

# somehow I can't manage cordova to install stuff yet
adb install -r $(find .|grep apk$|grep -v unaligned)