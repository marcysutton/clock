class Stack
  constructor: (target) ->
    @elTarget = $(target)

    @id = target.attr 'id'

    @elList = @elTarget.find 'ul'
    @elLabel = @elTarget.find 'h3'

  updateClockUnit: (value) ->
    @elLabel.text value

module.exports = Stack
