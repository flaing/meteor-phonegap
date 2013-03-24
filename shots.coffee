#
# Based on https://gist.github.com/nhoizey/4060568
#
# Takes provided URL passed as argument and make screenshots of this page with several viewport sizes.
# These viewport sizes are arbitrary, taken from iPhone & iPad specs, modify the array as needed
#
# Usage:
# $ casperjs shots.coffee http://example.com


casper = require("casper").create()

viewports = [
  viewport:
    width: 320
    height: 480
,
  viewport:
    width: 480
    height: 800
,
  viewport:
    width: 480
    height: 854
,
  viewport:
    width: 1280
    height: 720
,
  viewport:
    width: 1280
    height: 800
,
  viewport:
    width: 512
    height: 512
,
  viewport:
    width: 1024
    height: 500
,
  viewport:
    width: 180
    height: 120
]

if casper.cli.args.length < 1
  casper.echo("Usage: $ casperjs screenshots.js http://example.com").exit 1
else
  screenshotUrl = casper.cli.args[0]


casper.start screenshotUrl, ->
  @echo "Current location is " + @getCurrentUrl(), "info"

casper.each viewports, (casper, viewport) ->
  @then ->
    @viewport viewport.viewport.width, viewport.viewport.height

  @thenOpen screenshotUrl, ->
    @wait 5000

  @then ->
    @echo "Screenshot for (" + viewport.viewport.width + "x" + viewport.viewport.height + ")", "info"
    @capture "screenshots/" + viewport.viewport.width + "x" + viewport.viewport.height + ".png",
      top: 0
      left: 0
      width: viewport.viewport.width
      height: viewport.viewport.height


casper.run()
