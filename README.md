meteor-phonegap
===============

**[Meteor](http://meteor.com/)** is a JS framework that makes it a
**snap to build realtime apps.  [Phonegap](http://phonegap.com/)** is
**a way to turn web apps into phone apps.

**meteor-phonegap** is a quick and convenient way to turn a Meteor
project into an Android Phonegap app that you can upload to the Google
Play Developer Console.

You could take the cordova project and continue to develop that but
that would be like forking your own project. We're trying to create a
way to allow you to keep developing your Meteor project with only
minor additions related phonegap settings, i.e. config.xml and
AndroidManifest.xml for Android.  Great for prototyping and in-house
apps.

Any help with adding more platforms and improving Android is welcome: 
* [Add more platforms](https://github.com/guaka/meteor-phonegap/issues/26)


Getting started
---------------

**First step** is to install the Android SDK.
Since I did this a long time ago and all is still good I'm not
documenting this here now. jfgit.

Make sure Android-SDK/tools is in your PATH. (And possibly more.)

I'm still not 100% sure about the relationship between Cordova and
Phonegap but the `cordova` cli tool is extremely useful. We presume
you kinda know what `npm` is and you have it installed on your system.
Now, make sure `node` is up-to-date (at least v0.8.20 around February
2013) and run the following:

    sudo npm install -g cordova

You possibly want to `chown -R `yourself` /usr/local/lib/node_modules/cordova` 




meteor2cordova.coffee
---------------------

`meteor2cordova.coffee` turns *any* Meteor app into a Phonegap app.


   ./meteor2cordova.coffee docs.meteor.com --classname docs.meteor.com --appname "Meteorjs documentation" --versioncode 5 --versionname 0.6.3.1




Keysigning
----------

You first need to generate a key, e.g. like this:

    keytool -validity 9125 -sigalg MD5withRSA -keyalg RSA -keysize 1024 -genkey -v -alias YOURALIAS -keystore release-key.keystore


The rest of the steps can be handled by `signapk.sh`, which looks for
an appropriate `.apk` and turns it into `aligned-signed.apk`, which is
ready to be be uploaded to http://play.google.com/apps/publish.
Unfortunately there doesn't seem to be a way to automate this last
step (May 2013).



Some example Android apps
-------------------------
* [Meteor documentation](https://play.google.com/store/apps/details?id=io.cordova.cordovadocsmeteorcom)
* [Radio Meteor](https://play.google.com/store/apps/details?id=io.cordova.radio.meteor.com), internet radio player for Somafm and Radio Paradise
* [Hitchwiki](https://play.google.com/store/apps/details?id=io.cordova.cordovahitchwikimeteorcom), offline version of Hitchwiki, based on [mediawikixml2meteor2phonegap](https://github.com/guaka/mediawikixml2meteor2phonegap)

There's tons of stuff to do and improve. Your patches, bug reports and
feature requests are very welcome on github.


