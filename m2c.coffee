#!/usr/bin/env coffee


dldir='/tmp/meteor-phonegap-downloads'


fs = require 'fs'
sys = require 'sys'
# @TODO: cordova = require 'cordova'
optimist = require 'optimist'
exec = require('child_process').exec
execSync = require('execSync').exec



execPuts = (cmd, done) ->
  exec cmd, (error, stdout, stderr) ->
    sys.puts stderr
    sys.puts stdout
    done()


argv = optimist.argv

url = process.argv[2]
classname = argv.classname
appname = if argv.appname? then argv.appname else classname
versioncode = if argv.versioncode? then argv.versioncode else '1'
versionname = if argv.versionname? then argv.versionname else '1.0'



console.log argv

console.log "This is almost a CoffeeScript version of meteor2cordova.sh\n"
console.log "Let's turn #{url} into a Phonegap app\n"



initialize = ->
  fs.mkdir dldir, ->
    execSync 'rm -rf cordovaapp ' + dldir

download = (url, dldir, done) ->
  console.log 'Fetching', url
  execPuts "wget -nv --directory-prefix=#{dldir} -e robots=off -E -k -K -p #{url}", ->
    done()

cordovaCreate = (done) ->
    execPuts "cordova create cordovaapp", ->
      process.chdir 'cordovaapp'
      done()

copyApp = ->
  execSync "cp -a #{dldir}/#{url}/* www/"



fixConfigXml = (done) ->
  filename = 'www/config.xml'
  fs.readFile filename, (err, data) ->
    xml = data.toString()
    xml = xml.replace 'hellocordova', classname
    xml = xml.replace 'HelloCordova', appname
    fs.writeFile filename, xml
    done()

fixAndroidManifestXml = (done) ->
  filename = 'platforms/android/AndroidManifest.xml'
  fs.readFile filename, (err, data) ->
    xml = data.toString()
    xml = xml.replace 'versionCode="1" android:versionName="1.0"', "versionCode=\"#{versioncode}\" android:versionName=\"#{versionname}\""
    # also do something like: grep -v "CAMERA\|VIBRATE" AndroidManifest.xml
    fs.writeFile filename, xml
    done()


mainHack = (done) ->
  console.log "\nApplying the main hack: some JS that overrides _toSockjsUrl"
  execPuts 'sed -i.bak \'s#</head>#<script type="text/javascript">Meteor._Stream._toSockjsUrl = function(e) { return "http://$URL/sockjs" }</script></head>#g\' www/index.html', ->
    done()



main = ->
  initialize()
  download url, dldir, ->
    cordovaCreate ->
      copyApp()
      mainHack ->
        fixConfigXml ->
          console.log 'Building android platform'
          execPuts 'cordova platform add android', ->
            fixAndroidManifestXml ->
              console.log 'cordova build'
              execPuts 'cordova build', ->
                console.log 'compile android'
                execPuts 'cordova compile android', ->



main()

###
APK=$(find .|grep apk$|grep -v unaligned)
echo -e "\nTrying to install $APK on your phone"
adb install -r $APK
###
