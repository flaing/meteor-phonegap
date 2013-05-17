#!/usr/bin/env coffee


dldir='/tmp/meteor-phonegap-downloads'


fs = require 'fs'
sys = require 'sys'
# @TODO: cordova = require 'cordova'
optimist = require 'optimist'
exec = require('child_process').exec
execSync = require('execSync').exec


processors = require './processors'


execPuts = (cmd, done) ->
  console.log 'Executing', cmd
  exec cmd, (error, stdout, stderr) ->
    sys.puts stderr
    sys.puts stdout
    done()


argv = optimist.argv
argDefault = (arg, def) ->
  if argv.hasOwnProperty arg then argv[arg] else def


url = process.argv[2]
classname = argv.classname
appname = argDefault 'appname', classname
versioncode = argDefault 'versioncode', '1'
versionname = argDefault 'versionname', '1.0'

console.log 'versioncode', versioncode

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







main = ->
  initialize()
  download url, dldir, ->
    cordovaCreate ->
      copyApp()
      processors.mainHack ->
        processors.fixConfigXml classname, appname, ->
          execPuts 'cordova platform add android', ->
            processors.fixAndroidManifestXml versioncode, versionname, ->
              execPuts 'cordova build', ->
                execPuts 'cordova compile android', ->

main()

###
APK=$(find .|grep apk$|grep -v unaligned)
echo -e "\nTrying to install $APK on your phone"
adb install -r $APK
###
