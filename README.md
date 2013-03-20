meteor-phonegap
===============

**[Meteor](http://meteor.com/)** is awesome. **[Phonegap](http://phonegap.com/)** is cool. Now let's make it easy
for everyone to use both. At this point `meteor-phonegap` is a quick way to turn a Meteor project into an Android Phonegap app.


Some example Android apps
-------------------------
* [Meteor documentation](https://play.google.com/store/apps/details?id=io.cordova.cordovadocsmeteorcom)
* [Radio Meteor](https://play.google.com/store/apps/details?id=io.cordova.radio.meteor.com), internet radio player for Somafm and Radio Paradise


The docs
--------

**First step** is to install the Android SDK.
Since I did this a long time ago and all is still good I'm not
documenting this here now. jfgit.

I'm still not 100% sure about the relationship between Cordova and
Phonegap but the `cordova` cli tool is extremely useful. We presume you
kinda know what `npm` is and you have it installed on your system.
Now, make sure `node` is up-to-date (at least v0.8.20 around February
2013) and run the following:

    sudo npm install -g cordova

You possibly want to `chown -R `yourself` /usr/local/lib/node_modules/cordova` 


setupexample.sh
---------------

`setupexample.sh` installs the Meteor Leaderboard example and turns it into an app.


meteor2cordova.sh
-----------------

`meteor2cordova.sh` turns *any* Meteor app into a Phonegap app.


More detail
-----------

`setupexample.sh` will create a simple Meteor example project, fetch it
with `wget`.  Then it will set up a Cordova project, copy the wget
stuff into this and patch it based on the IP of the machine that this
stuff is running on.

`meteor2cordova.sh` will simply `wget` a Meteor project and apply some hackery on that.
Try `meteor2cordova.sh docs.meteor.com` for fun, and well, it might actually be useful.


There's tons of stuff to do and improve. Your patches, bug reports and feature requests are very welcome on github.




Keysigning
----------

*This is now also in `signapk.sh`*

Generate a key in the release-key.keystore file

    keytool -validity 9125 -sigalg MD5withRSA -keyalg RSA -keysize 1024 -genkey -v -alias YOURALIAS -keystore release-key.keystore

Create a release apk:

    ant release

Sign your apk:

    jarsigner -verbose -sigalg MD5withRSA -digestalg SHA1 -keystore release-key.keystore YOURAPPNAME-release-unsigned.apk YOURALIAS

zipalign it:

    Android-SDK/tools/zipalign YOURAPPNAME-release-unsigned.apk YOURAPPNAME-ready.apk

If you successfully jumped through these hoops you're ready for uploading to play.google.com

Some useful cli stuff
---------------------

    adb devices
    adb logcat


Other resources
---------------

* http://stackoverflow.com/questions/10322723/can-meteor-be-used-with-phonegap
* http://phonegap.com/2010/03/26/android-without-eclipse/
* http://blog.snowflax.com/meteor-on-mobile-device-using-phonegap/




