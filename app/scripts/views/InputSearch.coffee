Backbone.$ = $

class InputSearchView extends Backbone.View

  events:
    "submit" : "inputSubmitHandler"

  el: $('form.tag-input')

  initialize: () ->
    _.bindAll @, 'inputSubmitHandler'

    @elTagPicker = $(@el)

    @elTagInput = @elTagPicker.find('input[type=text]')
    @elTagPickerSubmit = @elTagPicker.find('input[type=submit]')

  inputSubmitHandler: (e) =>
    e.preventDefault()

    input = @elTagInput.val()

    if input isnt ""
      selectedTagName = input
      @tagToRoute(selectedTagName)
    else
      alert "Please enter a location."
  
  reset: () ->
    @elTagPicker.show()
    @elTagInput.val('')

  tagToRoute: (selectedTagName) ->
    Backbone.history.navigate "#/location/#{@encodeTagName(selectedTagName)}", trigger: true

  setTagName: (selectedTagName) ->
    @selectedTagName = selectedTagName

    @elTagInput.val @decodeTagName(selectedTagName)

  getTagName: () ->
    @selectedTagName

  encodeTagName: (selectedTagName = @selectedTagName) ->
    selectedTagName.replace(' ','+')

  decodeTagName: (selectedTagName = @selectedTagName) ->
    selectedTagName.replace('+', ' ')

module.exports = InputSearchView
