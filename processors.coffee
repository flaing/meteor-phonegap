
fs = require 'fs'
_ = require 'underscore'
sys = require 'sys'
exec = require('child_process').exec



execPuts = (cmd, done) ->
  console.log 'Executing', cmd
  exec cmd, (error, stdout, stderr) ->
    sys.puts stderr
    sys.puts stdout
    done()

exports.execPuts = execPuts


exports.mainHack = (done) ->
  console.log "\nApplying the main hack: some JS that overrides _toSockjsUrl"
  execPuts 'sed -i.bak \'s#</head>#<script type="text/javascript">Meteor._Stream._toSockjsUrl = function(e) { return "http://$URL/sockjs" }</script></head>#g\' www/index.html', ->
    done()


processFile = (filename, process, done) ->
  fs.readFile filename, (err, data) ->
    fs.writeFile filename, (process data.toString()), ->
      done()


exports.fixConfigXml = (classname, appname, done) ->
  processFile 'www/config.xml', (string) ->
    (string.replace 'hellocordova', classname).replace 'HelloCordova', appname
  , done


exports.fixAndroidManifestXml = (versioncode, versionname, rePermissions, done) ->
  processFile 'platforms/android/AndroidManifest.xml', (string) ->
    string = string.replace 'versionCode="1"', "versionCode=\"#{versioncode}\""
    string = string.replace 'android:versionName="1.0"', "android:versionName=\"#{versionname}\""

    lines = _.map string.split("\n"), (l) ->
      if l.indexOf('uses-permission') > -1
        if rePermissions and l.match rePermissions
          console.log 'Keeping permission: ', l
          l
        else
          console.log 'Ditching permission: ', l
          ''
      else
        l
    lines = _.filter lines, (l) -> l?.length > 0
    lines.join "\n"
  , done

