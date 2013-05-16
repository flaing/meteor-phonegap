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

console.log "Let's turn #{url} into a Phonegap app"

fs.mkdir dldir, ->
  execSync 'rm -rf cordovaapp ' + dldir
  exec "wget -nv --directory-prefix=#{dldir} -e robots=off -E -k -K -p #{url}", (e, o, err) ->
    puts e, o, err

    execSync 'mkdir -p cordovaapp'
    exec "cordova create cordovaapp", (e, o, err) ->
      puts e, o, err

      process.chdir 'cordovaapp'

      execSync "cp -a #{dldir}/#{url}/* www/"

      console.log "\nApplying the main hack: some JS that overrides _toSockjsUrl"
      exec 'sed -i.bak \'s#</head>#<script type="text/javascript">Meteor._Stream._toSockjsUrl = function(e) { return "http://$URL/sockjs" }</script></head>#g\' www/index.html', ->
        puts

        fs.readFile 'www/config.xml', (err, data) ->
          console.log data.toString()
          #sed -i.bak s/hellocordova/$NAME/ www/config.xml
          #sed -i.bak s/HelloCordova/$URL/g www/config.xml



