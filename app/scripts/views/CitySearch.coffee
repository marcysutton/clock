Backbone = require 'backbone'
Backbone.$ = $

class CitySearchView extends Backbone.View

  events:
    "submit" : "citySubmitHandler"

  el: $('form.city-picker')

  initialize: ->

    @elCityPicker = $(@el)

    @elCityInput = @elCityPicker.find('input[type=text]')
    @elCityPickerSubmit = @elCityPicker.find('input[type=submit]')

  citySubmitHandler: (e) =>
    e.preventDefault()

    input = @elCityInput.val()

    if input isnt ""
      cityName = input
      @setCityName cityName
    else
      alert "Please enter a city."

  setCityName: (cityName) ->
    @cityName = cityName

    @dispatcher.trigger 'city_name_change'

  getCityName: () ->
    @cityName

module.exports = CitySearchView
