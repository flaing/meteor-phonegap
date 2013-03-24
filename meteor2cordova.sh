#!/bin/bash

# Turn Meteor app into Phonegap app.
#
# (c) 2013 Kasper Souren
# See LICENSE
#
#


DLDIR=/tmp/meteor-phonegap-downloads

# Fetch IP address that is probably accessible on local network
IP=$(python -c 'import socket; s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM); s.connect(("www.eff.org", 80)); print s.getsockname()[0]')
URL=${1-$IP:3000}

echo "Let's turn $URL into a Phonegap app"

rm -rf cordovaapp $DLDIR

mkdir -p $DLDIR
wget --directory-prefix=$DLDIR -e robots=off -E -k -K -p $URL

cordova create cordovaapp
cd cordovaapp
cp -a $DLDIR/$URL/* www/


echo "Applying the main hack: some JS that overrides _toSockjsUrl"
sed -i.bak 's#</head>#<script type="text/javascript">Meteor._Stream._toSockjsUrl = function(e) { return "http://$URL/sockjs" }</script></head>#g' www/index.html


echo 'checking for public/cordvova/config.xml'
wget --directory-prefix=$DLDIR -e robots=off $URL/cordova/config.xml
echo 'checking for public/cordvova/AndroidManifest.xml'
wget --directory-prefix=$DLDIR -e robots=off $URL/cordova/AndroidManifest.xml



if grep -Fq "<?xml version" $DLDIR/config.xml; then
    echo 'Found your config.xml'
    cp $DLDIR/config.xml www/
else
    echo "Didn't find your config.xml, will hack the default one for you, you probably want to copy this to public/cordova/ of your Meteor project"
    NAME=$(echo $URL|sed s/\[\\.\:\]/\./g)
    echo "Widget id: $NAME"
    sed -i.bak s/hellocordova/$NAME/ www/config.xml
    sed -i.bak s/HelloCordova/$URL/g www/config.xml
fi

echo 'Now building android platform'
cordova platform add android


if grep -Fq "<?xml version" $DLDIR/AndroidManifest.xml; then
    echo 'Found your AndroidManifest.xml'
    cp $DLDIR/AndroidManifest.xml platforms/android/
fi



echo 'Now building the .apk'
cordova build
cordova compile android


APK=$(find .|grep apk$|grep -v unaligned)
echo -e "\nNow trying to install $APK"
adb install -r $APK