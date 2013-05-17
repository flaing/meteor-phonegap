#!/usr/bin/env coffee


dldir='/tmp/meteor-phonegap-downloads'


fs = require 'fs'
sys = require 'sys'
exec = require('child_process').exec
execSync = require('execSync').exec


puts = (error, stdout, stderr) ->
  sys.puts stderr
  sys.puts stdout


console.log 'This is almost a CoffeeScript version of meteor2cordova.sh'
console.log 'parameters: ', process.argv

url = process.argv[2]
appname = classname = 'testing'

console.log "Let's turn #{url} into a Phonegap app"








initialize = ->
  fs.mkdir dldir, ->
    execSync 'rm -rf cordovaapp ' + dldir

download = (url, dldir, done) ->
  exec "wget -nv --directory-prefix=#{dldir} -e robots=off -E -k -K -p #{url}", (e, o, err) ->
    puts e, o, err
    done()

cordovaCreate = (done) ->
    exec "cordova create cordovaapp", (e, o, err) ->
      puts e, o, err
      process.chdir 'cordovaapp'
      done()

copyApp = ->
  execSync "cp -a #{dldir}/#{url}/* www/"


fixConfigXml = ->
        fs.readFile 'www/config.xml', (err, data) ->
          confxml = data.toString()
          confxml = confxml.replace 'hellocordova', classname
          confxml = confxml.replace 'HelloCordova', appname
          fs.writeFile 'www/config.xml', confxml

mainHack = ->
  console.log "\nApplying the main hack: some JS that overrides _toSockjsUrl"
  exec 'sed -i.bak \'s#</head>#<script type="text/javascript">Meteor._Stream._toSockjsUrl = function(e) { return "http://$URL/sockjs" }</script></head>#g\' www/index.html', (e, o, err) ->
    puts e, o, err


main = ->
  initialize()
  download url, dldir, ->
    cordovaCreate ->
      copyApp()
      mainHack()
      fixConfigXml()


main()