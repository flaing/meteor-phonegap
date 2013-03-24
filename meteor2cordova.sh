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

rm -rf cordovaapp $DLDIR

echo -e "Downloading $URL into $DLDIR\n"
mkdir -p $DLDIR
wget -nv --directory-prefix=$DLDIR -e robots=off -E -k -K -p $URL

if [ ! -d "$DLDIR/$URL" ]; then
    echo "Provide URL of the Meteor you want to convert or run a Meteor server locally"
    exit
fi

echo 'Creating cordovaapp/' 
cordova create cordovaapp
cd cordovaapp
cp -a $DLDIR/$URL/* www/


echo -e "\nApplying the main hack: some JS that overrides _toSockjsUrl"
sed -i.bak 's#</head>#<script type="text/javascript">Meteor._Stream._toSockjsUrl = function(e) { return "http://$URL/sockjs" }</script></head>#g' www/index.html


echo -e "\nChecking for public/cordvova/config.xml"
wget -nv --directory-prefix=$DLDIR -e robots=off $URL/cordova/config.xml
echo -e "checking for public/cordvova/AndroidManifest.xml"
wget -nv --directory-prefix=$DLDIR -e robots=off $URL/cordova/AndroidManifest.xml



if grep -Fq "<?xml version" $DLDIR/config.xml; then
    echo 'Found config.xml in public/cordova'
    cp $DLDIR/config.xml www/
else
    if [ -e ../config.xml ]; then
        echo 'Using local config.xml'
        cp ../config.xml www/
    else
        echo "Didn't find your config.xml, will hack the default one for you, you probably want to copy this to public/cordova/ of your Meteor project"
        NAME=$(echo $URL|sed s/\[\\.\:\]/\./g)
        echo "Widget id: $NAME"
        sed -i.bak s/hellocordova/$NAME/ www/config.xml
        sed -i.bak s/HelloCordova/$URL/g www/config.xml
    fi
fi

echo -e "\nNow building android platform"
cordova platform add android


if grep -Fq "<?xml version" $DLDIR/AndroidManifest.xml; then
    echo 'Found AndroidManifest.xml in public/cordova'
    cp $DLDIR/AndroidManifest.xml platforms/android/
else
    if [ -e ../AndroidManifest.xml ]; then
        echo 'Using local AndroidManifest.xml'
        cp ../AndroidManifest.xml www/
    fi
fi



echo 'Now building the APK'
cordova build
cordova compile android


APK=$(find .|grep apk$|grep -v unaligned)
echo -e "\nNow trying to install $APK"
adb install -r $APK