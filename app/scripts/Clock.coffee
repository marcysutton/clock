class Clock

  constructor: (stacks, options = {}) ->
    # stacks = [@hoursStack, @minutesStack, @secondsStack]
    @hoursStack = stacks[0]
    @minutesStack = stacks[1]
    @secondsStack = stacks[2]

    @date = new Date()
    # @timezone = @date.toString().replace(/^.*\(|\)$/g, "").replace(/[^A-Z]/g, "")

  setTime: () ->
    @date.setSeconds(@date.getSeconds() + 1)

    # TODO: visual representation of time zone: EST, PST, etc.
    @timezoneOffset = @date.getTimezoneOffset() / 60

  printTime: () ->
    @setTime()

    @printSeconds()
    @printMinutes()
    @printHours()

  printSeconds: () ->
    seconds = @date.getSeconds()
    formattedSeconds = @date.getFormattedSeconds()

    @secondsStack.relevantTime = seconds
    @secondsStack.updateClockUnit formattedSeconds
    @secondsStack.moveStack()

  printMinutes: () ->
    minutes = @date.getMinutes()
    formattedMinutes = @date.getFormattedMinutes()

    @minutesStack.relevantTime = minutes
    @minutesStack.updateClockUnit formattedMinutes
    @minutesStack.moveStack() if @date.getSeconds() == 0

  printHours: () ->
    hours = @date.getHours12()
    formattedHour = @date.getFormattedHours()

    @hoursStack.relevantTime = hours
    @hoursStack.updateClockUnit formattedHour
    @hoursStack.moveStack() if @date.getMinutes == 0

module.exports = Clock
