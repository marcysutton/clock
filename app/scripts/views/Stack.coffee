Backbone = require 'backbone'
Backbone.$ = $

class StackView extends Backbone.View

  options:
    initTopMargin: 230

  relevantTime: null

  formattedTime: null

  currentFrame: null

  constructor: (target) ->
    @elTarget = $(target)

    @id = target.attr 'id'

    @elList = @elTarget.find 'ul'
    @elLabel = @elTarget.find 'h3'

  setStackUlPosition: (element, relevantTime) ->
    topMargin = @options.initTopMargin - (relevantTime * 15)
    element.css "top", "#{topMargin}px"

  setTime: (relevantTime, formattedTime) ->
    @relevantTime = relevantTime
    @formattedTime = formattedTime

  updateClockUnit: () ->
    @elLabel.text(@formattedTime)

  positionClockNumbers: () ->
    currentFramePosition = @currentFrame.offset().top
    @elLabel.css 'top', currentFramePosition - (@options.initTopMargin / 2)

    @elLabel.fadeIn()

  setCurrentFrame: () ->
    @setStackUlPosition @elList, @relevantTime

    @currentFrame.removeClass 'current' if @currentFrame
    @currentFrame = $(@elListItems[@relevantTime])

    @currentFrame.addClass 'current'

  moveStack: () ->
    @setCurrentFrame()
    @updateClockUnit()

module.exports = StackView
