meteor-phonegap
===============

Can Meteor be used with PhoneGap?
http://stackoverflow.com/questions/10322723/can-meteor-be-used-with-phonegap

Now let's make it easy for everyone.



No Eclipse please
-----------------

As it's mostly a waste of time, cpu cycles and disk space for folks who prefer simple editors like vim and Emacs, we don't want Eclipse.

? First step is to install the Android SDK and Phonegap itself.

We presume you kinda know what `npm` is and you have it installed on your system. Now, make sure `node` is up-to-date (at least v0.8.20 around February 2013) and run the following:

    npm install -g cordova


Now you can

    cordova create Baz
    cd Baz
    cordova platform add android
    cordova build
    cordova serve android

Other useful cli stuff
----------------------


    adb devices
    adb logcat


Other resources

http://phonegap.com/2010/03/26/android-without-eclipse/
