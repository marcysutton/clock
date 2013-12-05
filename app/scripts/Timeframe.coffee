###
 * Timeframe
 * @author: Marcy Sutton
 * Version 2.0
 * 12/5/13
###

module.exports = class Timeframe
  constructor: (target, options = {}) ->
    @options =
      apiKey: 'beb8b17f735b6a404dbe120fd7300460'
      numImages: [12, 60, 60]
      topMargin: 230
      timesOfDay: [
        [0, 4, 'night']
        [4, 12, 'morning']
        [12, 17, 'afternoon']
        [17, 20, 'evening']
        [20, 24, 'night']
      ]

    _.defaults(options, @options)

    @totalImages = @options.numImages.reduce (a, b) ->
      a + b

    @elTarget = $(target)

    @elCityPicker = @elTarget.find('form.city-picker')
    @elCityInput = @elCityPicker.find('input[type=text]')
    @elCityPickerSubmit = @elCityPicker.find('input[type=submit]')

    @elLoader = @elTarget.find('#loader')
    @elCityLoading = @elLoader.find('.city-loading')

    @elImgContainer = @elTarget
    @elImgList = @elImgContainer.find('ul')
    @elImgListItems = @elImgList.find('li')

    @setup()

  setup: () ->
    $('body').removeClass('no-js')
      .addClass('initialized')

    @elCityPicker.on 'submit', @citySubmitHandler

    @elImgListItems.each (index, value) ->
      $(this).append '<h3 /><ul />'

    @elHours = @elImgListItems.eq 0
    @elMinutes = @elImgListItems.eq 1
    @elSeconds = @elImgListItems.eq 2

    @elHoursList = @elHours.find 'ul'
    @elHoursLabel = @elHours.find 'h3'
    @elMinutesList = @elMinutes.find 'ul'
    @elMinutesLabel = @elMinutes.find 'h3'
    @elSecondsList = @elSeconds.find 'ul'
    @elSecondsLabel = @elSeconds.find 'h3'

  initialize: () ->
    @elCityLoading.text @cityName

    @date = new Date
    @timezone = @date.toString().replace(/^.*\(|\)$/g, "").replace(/[^A-Z]/g, "")

    @elCityPicker.fadeOut().remove()
    @elLoader.fadeIn()

    @setTime()
    @getFlickr()

  citySubmitHandler: (e) =>
    e.preventDefault()

    input = @elCityInput.val()

    if input isnt ""
      @cityName = input
      @initialize()
    else
      alert "Please enter a city."

  setTime: () ->
    @date.setSeconds(@date.getSeconds() + 1)

    # NEED: string representation of each Time Zone: EST, PST, etc.
    @timezoneOffset = @date.getTimezoneOffset() / 60

    currentTagArr = undefined
    currentHour = @date.getHours()
    tags = @options.timesOfDay
    numTags = tags.length

    i = 0

    while i < numTags
      currentTagArr = tags[i]
      if currentHour >= currentTagArr[0] and currentHour < currentTagArr[1]
        @currentTag = currentTagArr[2]
        break
      i++

  getTime: () ->
    @currentTag

  getFlickr: () ->
    console.log('showing '+@cityName+' in the '+ @getTime())

  printTime: () ->

  moveStack: () ->
