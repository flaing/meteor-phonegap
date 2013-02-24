#!/usr/bin/env coffee

fs = require 'fs'
sys = require 'sys'
exec = require('child_process').exec
# execSync = require 'execSync'

puts = (error, stdout, stderr) ->
  sys.puts stderr
  sys.puts stdout

console.log 'This will be a CoffeeScript version of meteor2cordova.sh'

console.log process.argv

url = process.argv[2]

console.log "Let's turn #{url} into a Phonegap app"

fs.mkdir 'downloads', ->
  process.chdir 'downloads'
  exec "wget -e robots=off -E -k -K -p #{url}", (e, o, err) ->
    puts e, o, err
    process.chdir '..'
    exec 'cordovaapp'
    exec "cordova create cordovaapp", puts
