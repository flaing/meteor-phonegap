meteor-phonegap
===============

Can Meteor be used with PhoneGap?
http://stackoverflow.com/questions/10322723/can-meteor-be-used-with-phonegap

Now let's make it easy for everyone. As it's mostly a waste of time, cpu cycles and 
disk space for folks who prefer simple editors like vim and Emacs, we don't want Eclipse.

*First step* is to install the Android SDK and Phonegap itself.  Since I did this a long time
ago and all is still good I'm not documenting this here now.

We presume you kinda know what `npm` is and you have it installed on your system. 
Now, make sure `node` is up-to-date (at least v0.8.20 around February 2013) and run the following:

    sudo npm install -g cordova

You possibly want to `chown -R `yourself` /usr/local/lib/node_modules/cordova` 

Now you can

    cordova create Baz
    cd Baz
    
    
This one might break, in which case you can try the following. Note that it might not work straight away, just google your errors and try e.g. 
`/usr/local/lib/node_modules/cordova/lib/cordova-android/framework; ant jar`.

    cordova platform add android
    
You can probably add some other platforms as well but we'll first focus on android in this project. Now you can...

    cordova build  # build stuff
    cordova compile android  # install the .apk on your android device
    cordova serve android  # test stuff on your desktop by going to localhost:8000
    


Other useful cli stuff
----------------------

    adb devices
    adb logcat


Other resources

http://phonegap.com/2010/03/26/android-without-eclipse/
