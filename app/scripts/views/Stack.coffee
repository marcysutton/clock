Backbone.$ = $

class StackView extends Backbone.View

  options:
    initTopMargin: 230

  relevantTime: null

  formattedTime: null

  currentFrame: null

  positionContext: null

  constructor: (target) ->
    @el = $(target)

    @id = target.attr 'id'

    @elList = @el.find 'ul'
    @elLabel = @el.find 'h3'

    @positionContext = window.timeframeApp.options.positionContext
    @changeRelativePosition()

  changeRelativePosition: () ->
    if @positionContext is 'time'
      @relevantPosition = @relevantTime
    else
      @options.initTopMargin = 0
      @relevantPosition = 0

    @relevantPosition

  setStackUlPosition: (element, relevantTime) ->
    @ulTopMargin = @options.initTopMargin - (relevantTime * 15)
    element.css "top", "#{@ulTopMargin}px"

  setTime: (relevantTime, formattedTime) ->
    @relevantTime = relevantTime
    @formattedTime = formattedTime

    @changeRelativePosition()

  updateClockUnit: () ->
    @elLabel.text(@formattedTime)

  positionClockNumbers: () ->
    currentFramePosition = @ulTopMargin + @currentFrame.position().top
    @elLabel.css 'top', currentFramePosition

    @elLabel.fadeIn()

  setCurrentFrame: () ->
    @setStackUlPosition @elList, @relevantPosition

    @currentFrame.removeClass 'current' if @currentFrame
    @currentFrame = $(@elListItems[@relevantPosition])

    @currentFrame.addClass 'current'

  moveStack: () ->
    @setCurrentFrame()
    @updateClockUnit()

module.exports = StackView
