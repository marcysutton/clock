###
 * Timeframe
 * @author: Marcy Sutton
 * Version 2.0
 * 12/5/13
###

module.exports = class Timeframe
  constructor: (target, options = {}) ->
    $('body').removeClass 'no-js'

    @options =
      apiKey: 'beb8b17f735b6a404dbe120fd7300460'
      numImages: [12, 60, 60]
      topMargin: 230

    _.defaults(options, @options)

    @totalImages = @options.numImages.reduce (a, b) ->
      a + b

    @elTarget = $(target)

    @elCityPicker = @elTarget.find('form.city-picker')
    @elCityInput = @elCityPicker.find('input[type=text]')
    @elCityPickerSubmit = @elCityPicker.find('input[type=submit]')

    @elLoader = @elTarget.find('#loader')
    @elLoaderImg = @elLoader.find('.city-loading')

    @elImgContainer = @elTarget
    @elImgList = @elImgContainer.find('ul')
    @elImgListItems = @elImgList.find('li')

    @elCityPicker.on 'submit', @citySubmitHandler

  initialize: () ->
    @elImgListItems.each (index, value) ->
      $(this).append '<h3 /><ul />'

  citySubmitHandler: (e) =>
    e.preventDefault()

    input = @elCityInput.val()

    if input isnt ""
      @city = input
      @initialize()
    else
      alert "Please enter a city."
