cd $(dirname $0)
cd cordovaapp/platforms/android

echo We need your keystore alias
YOURALIAS=$1

# To create keystore:
# keytool -validity 9125 -sigalg MD5withRSA -keyalg RSA -keysize 1024 -genkey -v -alias $YOURALIAS -keystore ~/release-key.keystore

echo Build release version of apk
ant release

UNSIGNED=$(find .|grep apk$|grep release-unsigned)
echo signing $UNSIGNED
jarsigner -verbose -sigalg MD5withRSA -digestalg SHA1 -keystore ~/release-key.keystore $UNSIGNED $YOURALIAS

rm ready.apk
echo 'zipalign your apk'
zipalign 4 $UNSIGNED ready.apk

echo 'Done. Check ready.apk'