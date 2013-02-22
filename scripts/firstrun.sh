set +o verbose

cd "(dirname "$0")"/..

# A bit crude but good for getting started
killall node mongod
rm -rf cordovaapp localhost3000 meteorapp

# First create the Meteor app 
meteor create meteorapp
cd meteorapp && meteor & 

cd "(dirname "$0")"/..

# Then fetch it
sleep 3
rm -rf localhost3000
wget -E -H -k -K -p localhost:3000 
mv localhost\:3000 localhost3000

cordova create cordovaapp
cd cordovaapp
mv www/index.html wwww/index-cordova-orig.html
cp -av ../localhost3000/* www/
cordova platform add android
cordova build
cordova compile android

# somehow I can't manage cordova to install stuff yet
adb install -r $(find .|grep apk$|grep -v unaligned)