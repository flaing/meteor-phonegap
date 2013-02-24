meteor-phonegap
===============

**[Meteor](http://meteor.com/)** is awesome. **[Phonegap](http://phonegap.com/)** is cool. Now let's make it easy
for everyone to use both. At this point `meteor-phonegap` is a quick way to turn a Meteor project into an Android Phonegap app.

Later on we'll support more platforms and possibly plug into build.phonegap.com.

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



Some useful cli stuff
---------------------

    adb devices
    adb logcat


Other resources
---------------

* http://stackoverflow.com/questions/10322723/can-meteor-be-used-with-phonegap
* http://phonegap.com/2010/03/26/android-without-eclipse/
* http://blog.snowflax.com/meteor-on-mobile-device-using-phonegap/




