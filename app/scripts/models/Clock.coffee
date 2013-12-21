moment = require 'moment'

class Clock extends Backbone.Model

  initialize: (cityName, options = {}) ->
    @currentHour = null
    @current24Hour = null
    @currentMinute = null
    @currentSecond = null

    @start = moment()
    @time = 0
    @secondsElapsed = 0

  startInterval: () ->
    timeout = window.setTimeout(=>
      @intervalFunc()
    , 100)

  intervalFunc: () =>
    @time += 100

    @secondsElapsed = Math.floor(@time / 100) / 10
    @setTime() if Math.round(@secondsElapsed) is @secondsElapsed

    diff = (moment() - @start) - @time
    window.setTimeout @intervalFunc, (100 - diff)

  setTime: () ->
    @setSeconds()
    @setMinutes()
    @setHours()

    @trigger 'change:time'

  setSeconds: () ->
    @currentSecond = moment().format('s')
    @formattedSecond = moment().format('ss')

  setMinutes: () ->
    minute = moment().format('m')

    if @currentMinute isnt minute
      @currentMinute = minute
      @formattedMinute = moment().format('mm')

      @trigger 'change:minute'

  setHours: () ->
    hour = moment().format('h')

    if @currentHour isnt hour
      @currentHour = hour
      @formattedHour = moment().format('hh')

      @trigger 'change:hour'

    @current24Hour = moment().format('H')

module.exports = Clock
