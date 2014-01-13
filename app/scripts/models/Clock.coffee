moment = require 'moment'

class Clock extends Backbone.Model

  initialize: (cityName, options = {}) ->
    @currentDay = null
    @currentHour = null
    @current24Hour = null
    @currentMinute = null
    @currentSecond = null

    @moment = moment()
    @start = @moment
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
    @setDate()

    @trigger 'change:time'

  setSeconds: () ->
    @currentSecond = moment().format('s')
    @formattedSecond = moment().format('ss')

    @trigger 'change:seconds10' if (@currentSecond % 10) is 0

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
      console.log 'hour change'

    @current24Hour = moment().format('H')

  setDate: () ->
    day = moment().format('D')

    if @currentDay isnt day
      @currentDay = moment().format('D')

      @trigger 'change:day'

module.exports = Clock
