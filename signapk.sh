

# Read settings
source ~/.meteor2cordova

cd cordovaapp/platforms/android

echo We need your keystore alias
YOURALIAS=${1-$M2C_KEY_ALIAS}


# To create keystore:
# keytool -validity 9125 -sigalg MD5withRSA -keyalg RSA -keysize 1024 -genkey -v -alias $YOURALIAS -keystore $M2C_KEY_CERTFILE

echo Build release version of apk
ant release

UNSIGNED=$(find .|grep apk$|grep release-unsigned)
echo signing $2
echo $M2C_KEY_PASS | jarsigner -verbose -sigalg MD5withRSA -digestalg SHA1 -keystore $M2C_KEY_CERTFILE $UNSIGNED $YOURALIAS

echo 'zipalign your apk'
zipalign 4 $UNSIGNED ready.apk

echo 'Done. Check ready.apk'

aapt dump badging ready.apk
mv ready.apk ../../..

