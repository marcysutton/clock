class Stack

  options:
    initTopMargin: 230

  relevantTime: null

  currentFrame: null

  constructor: (target) ->
    @elTarget = $(target)

    @id = target.attr 'id'

    @elList = @elTarget.find 'ul'
    @elLabel = @elTarget.find 'h3'


  setStackUlPosition: (element, relevantTime) ->
    topMargin = @options.initTopMargin - (relevantTime * 15)
    element.css "top", "#{topMargin}px"

  moveStack: () ->
    @setStackUlPosition @elList, @relevantTime

    @currentFrame.removeClass 'current' if @currentFrame
    @currentFrame = $(@elListItems[@relevantTime])
    @currentFrame.addClass 'current'

module.exports = Stack

  updateClockUnit: (value) ->
    @elLabel.text(value)

  positionClockNumbers: () ->
    currentFramePosition = @currentFrame.offset().top
    @elLabel.css 'top', currentFramePosition - (@options.initTopMargin / 2)

