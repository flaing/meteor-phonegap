#!/usr/bin/env coffee


fs = require 'fs'
sys = require 'sys'
exec = require('child_process').exec
# execSync = require 'execSync'

dldir='/tmp/meteor-phonegap-downloads'


puts = (error, stdout, stderr) ->
  sys.puts stderr
  sys.puts stdout

console.log 'This will be a CoffeeScript version of meteor2cordova.sh'

console.log process.argv

url = process.argv[2]

console.log "Let's turn #{url} into a Phonegap app"


fs.mkdir dldir, ->
  exec 'rm -rf cordovaapp ' + dldir, ->
    exec "wget -nv --directory-prefix=#{dldir} -e robots=off -E -k -K -p #{url}", (e, o, err) ->
      puts e, o, err
      exec 'mkdir -p cordovaapp', ->
        exec "cordova create cordovaapp", (e, o, err) ->
          puts e, o, err
          process.chdir 'cordovaapp'
          exec "cp -a #{dldir}/#{url}/* www/", ->
            console.log "\nApplying the main hack: some JS that overrides _toSockjsUrl"
            exec 'sed -i.bak \'s#</head>#<script type="text/javascript">Meteor._Stream._toSockjsUrl = function(e) { return "http://$URL/sockjs" }</script></head>#g\' www/index.html', ->
              puts


