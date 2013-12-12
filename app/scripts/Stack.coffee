class Stack
  constructor: (target) ->
    @elTarget = $(target)

    @elList = @elTarget.find 'ul'
    @elListItems = @elList.find 'li'
    @elLabel = @elTarget.find 'h3'

  updateClockUnit: (value) ->
    @elLabel.text value

module.exports = Stack
