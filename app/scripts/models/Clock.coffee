Backbone = require 'backbone'
moment = require 'moment'


class Clock extends Backbone.Model

  initialize: (stacks, cityName, options = {}) ->
    # stacks = [@hoursStack, @minutesStack, @secondsStack]
    @hoursStack = stacks[0]
    @minutesStack = stacks[1]
    @secondsStack = stacks[2]

    @currentHours = null
    @currentMinutes = null
    @currentSeconds = null

    @start = moment()
    @time = 0
    @elapsed = 0

  startInterval: () ->
    timeout = window.setTimeout(=>
      @intervalFunc()
    , 100)

  intervalFunc: () =>
    #check if it has been 1000 milliseconds
    @time += 100
    @elapsed = Math.floor(@time / 100) / 10

    @setTime() if Math.round(@elapsed) is @elapsed

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
    @currentSeconds = moment().format('s')
    @formattedSeconds = moment().format('ss')

  setMinutes: () ->
    @currentMinutes = moment().format('m')
    @formattedMinutes = moment().format('mm')

  setHours: () ->
    @currentHours = moment().format('h')
    @formattedHours = moment().format('hh')

module.exports = Clock
