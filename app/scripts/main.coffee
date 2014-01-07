# global $

Timeframe = require './Timeframe'

$(document).ready ->
  window.timeframeApp = new Timeframe '.timeframe'
  timeframeApp.initialize()
