cd $(dirname $0)
cd cordovaapp/platforms/android

YOURALIAS=$1

# to create keystore:
# keytool -validity 9125 -sigalg MD5withRSA -keyalg RSA -keysize 1024 -genkey -v -alias $YOURALIAS -keystore ~/release-key.keystore

ant release

UNSIGNED=$(find .|grep apk$|grep release-unsigned)
echo Signing $UNSIGNED

jarsigner -verbose -sigalg MD5withRSA -digestalg SHA1 -keystore ~/release-key.keystore $UNSIGNED $YOURALIAS

/opt/Android-SDK/tools/zipalign 4 $UNSIGNED ready.apk
