
fs = require 'fs'


processors.mainHack = (done) ->
  console.log "\nApplying the main hack: some JS that overrides _toSockjsUrl"
  execPuts 'sed -i.bak \'s#</head>#<script type="text/javascript">Meteor._Stream._toSockjsUrl = function(e) { return "http://$URL/sockjs" }</script></head>#g\' www/index.html', ->
    done()


exports.fixConfigXml = (classname, appname, done) ->
  filename = 'www/config.xml'
  fs.readFile filename, (err, data) ->
    xml = data.toString()
    xml = xml.replace 'hellocordova', classname
    xml = xml.replace 'HelloCordova', appname
    fs.writeFile filename, xml
    done()


exports.fixAndroidManifestXml = (versioncode, versionname, done) ->
  filename = 'platforms/android/AndroidManifest.xml'
  fs.readFile filename, (err, data) ->
    xml = data.toString()
    xml = xml.replace 'versionCode="1"', "versionCode=\"#{versioncode}\""
    xml = xml.replace 'android:versionName="1.0"', "android:versionName=\"#{versionname}\""

    # also do something like: grep -v "CAMERA\|VIBRATE" AndroidManifest.xml
    # xml = xml.
    fs.writeFile filename, xml
    done()


