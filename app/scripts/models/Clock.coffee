Backbone = require 'backbone'
moment = require 'moment'


class Clock extends Backbone.Model

  initialize: (cityName, options = {}) ->
    @currentHour = null
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
    #check if it has been 1000 milliseconds
    @time += 100

    @secondsElapsed = Math.floor(@time / 100) / 10
    @setTime() if Math.round(@secondsElapsed) is @secondsElapsed

    diff = (moment() - @start) - @time
    window.setTimeout @intervalFunc, (100 - diff)

  setTime: () ->
    # TODO: visual representation of time zone: EST, PST, etc.
    # @timezoneOffset = @date.getTimezoneOffset() / 60

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

module.exports = Clock
