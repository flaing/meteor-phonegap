meteor-phonegap
===============

**Meteor** is awesome. **Phonegap** is cool. Now let's make it easy
for everyone to use both.  We don't want Eclipse as it's mostly a
waste of time, cpu cycles and disk space for folks who prefer simple
editors like vim and Emacs.

We'll first focus on Android here, although it's probably not too hard
to add support for other platforms as well.

**First step** is to install the Android SDK and Phonegap itself.
Since I did this a long time ago and all is still good I'm not
documenting this here now.

I'm still not 100% sure about the relationship between Cordova and
Phonegap but I came across a pretty cool cli tool. We presume you
kinda know what `npm` is and you have it installed on your system.
Now, make sure `node` is up-to-date (at least v0.8.20 around February
2013) and run the following:

    sudo npm install -g cordova

You possibly want to `chown -R `yourself` /usr/local/lib/node_modules/cordova` 


setupexample.sh
---------------

`setupexample.sh` will install the Meteor Leaderboard example and turn it into an app.


meteor2cordova.sh
-----------------

`meteor2cordova.sh` will turn *any* Meteor app that is not minified into a Phonegap app.
So use `meteor deploy --debug` for now.


More detail
-----------

`setupexample.sh` will create a simple Meteor example project, fetch it
with `wget`.  Then it will set up a Cordova project, copy the wget
stuff into this and patch it based on the IP of the machine that this
stuff is running on.

`meteor2cordova.sh` will simply `wget` a Meteor project and apply some hackery on that.
Try `meteor2cordova.sh docs.meteor.com` for fun, and well, it might actually be useful.


Some useful cli stuff
---------------------

    adb devices
    adb logcat


Other resources
---------------

* http://stackoverflow.com/questions/10322723/can-meteor-be-used-with-phonegap
* http://phonegap.com/2010/03/26/android-without-eclipse/
* http://blog.snowflax.com/meteor-on-mobile-device-using-phonegap/




