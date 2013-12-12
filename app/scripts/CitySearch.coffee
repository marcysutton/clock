Backbone = require 'backbone'
$ = require('../../bower_components/jquery/jquery')
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

    console.log cityName

  getCityName: () ->
    @cityName

module.exports = CitySearchView
