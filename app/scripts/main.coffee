# global $

Timeframe = require './Timeframe'

$(document).ready ->
  window.timeframeApp = new Timeframe '.app'
  timeframeApp.initialize()
