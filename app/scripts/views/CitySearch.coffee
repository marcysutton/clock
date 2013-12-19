Backbone = require 'backbone'
Backbone.$ = $

class CitySearchView extends Backbone.View

  events:
    "submit" : "citySubmitHandler"

  el: $('form.city-picker')

  initialize: ->
    _.bindAll @, 'citySubmitHandler'

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

    @elCityInput.val @decodeCityName(cityName)

    @dispatcher.trigger 'city_name_change'

  getCityName: () ->
    @cityName

  encodeCityName: (cityName = @cityName) ->
    cityName.replace(' ','+')

  decodeCityName: (cityName = @cityName) ->
    cityName.replace('+', ' ')

module.exports = CitySearchView
