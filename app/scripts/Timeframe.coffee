###
 * Timeframe ViewController
 * @author: Marcy Sutton
 * Version 2.0
 * 12/5/13
###

# global $, Modernizr, Backbone

Router = require './routers/Router'
Modal = require './views/Modal'
InputSearchView = require './views/InputSearch'
StackView = require './views/Stack'
ImageQueue = require './models/ImageQueue'
Clock = require './models/Clock'

class Timeframe extends Backbone.View
  constructor: (target, options = {}) ->
    @options =
      apiKey: 'beb8b17f735b6a404dbe120fd7300460'
      columnImageCounts: [12, 60, 60]
      timesOfDay: [
        [0, 4, 'night']
        [4, 12, 'morning']
        [12, 17, 'afternoon']
        [17, 20, 'evening']
        [20, 24, 'night']
      ]
      minimumImages: 72

    _.defaults(options, @options)

    @target = target
    @mobile = false

    @loadUtility = skone.util.ImageLoader.LoadImageSet
    @imageQueue = new ImageQueue()

  initialize: () ->
    @inputSearch = new InputSearchView()
    @router = new Router(@inputSearch)

    @elTarget = $(@target)
    @elLoader = $('.loader')

    @elTagLoading = @elLoader.find('.tag-loading')
    @elNowShowing = @elTarget.find('.now-showing')

    @setupClockUI()

    @modal = new Modal()

    if Modernizr.touch
      @modal.show()
  getTotalImages: () ->
    if not @mobile
      @totalImages = @options.columnImageCounts.reduce (a, b) ->
        a + b
    else
      Backbone.history.start()

    @totalImages

  setupClockUI: () ->
    $('body').removeClass('no-js')
      .addClass('initialized')

    @elImgContainer = @elTarget
    @elImgList = @elImgContainer.find('ul.imgStacks')
    @elImgListItems = @elImgList.find('li')

    @elImgListItems.each (index, value) ->
      $(this).append '<h3 /><ul />'

    @elHours = @elImgListItems.eq 0
    @elMinutes = @elImgListItems.eq 1
    @elSeconds = @elImgListItems.eq 2

    @hoursStack = new StackView @elHours
    @minutesStack = new StackView @elMinutes
    @secondsStack = new StackView @elSeconds
    @stacks = [@hoursStack, @minutesStack, @secondsStack]

    $(window)
      .on 'resize', (event) =>
        @clockTextRepaint()

  appStart: () ->
    @selectedTagName = @inputSearch.decodeTagName()
    @updateUIWithTagChange @selectedTagName

    @inputSearch.elTagPicker.fadeOut()
    @elLoader.fadeIn()

    @clock = new Clock(@selectedTagName)
    @clock.setTime()

    @imageQueue = new ImageQueue()
    @imageQueue.on 'imagesloaded', () =>
      @handOutImages()

    @queryAPI()

  clockTextRepaint: () ->
    $('.stack').find('h3').css('z-index', 1)

  updateUIWithTagChange: (selectedTagName) ->
    @elTagLoading.text selectedTagName

  setTags: () ->
    currentTagArr = []
    currentHour = @clock.current24Hour
    tags = @options.timesOfDay
    numTags = tags.length

    i = 0
    while i < numTags
      currentTagArr = tags[i]
      if currentHour >= currentTagArr[0] and currentHour < currentTagArr[1]
        @currentTag = currentTagArr[2]
        break
      i++

  queryAPI: () ->
    @setTags()

    $.getJSON(@getJSONURL(), (response) =>
      console.log response

      if response.stat == "ok"
        console.log('showing '+@selectedTagName+' in the '+ @currentTag)
        console.log 'number of images: ', response.photos.photo.length

        @elNowShowing.text "#{@selectedTagName} #{@currentTag}"
        @imageQueue.fetchImages response
      else
        @showErrorMessage response.message

    ).fail (response) =>
      @showErrorMessage response

  showErrorMessage: (response) ->
    if response.message
      alert response.message
    else
      alert 'Sorry, there was a problem. Please try again!'

    console.log response

  getJSONURL: () ->
    "http://api.flickr.com/services/rest/?method=flickr.photos.search&" +
    "api_key=#{@options.apiKey}&" +
    @getURLTags() +
    "sort=interestingness-desc&" +
    "per_page=" + @getTotalImages() +
    "&format=json&jsoncallback=?"

  getURLTags: () ->
    tagParams = "tag_mode=all&tags="

    tags = "#{@inputSearch.encodeTagName()}"
    tags += ",#{@currentTag}&"

    tagParams + tags

  sortImageQueue: (n) ->
    _.shuffle @imageQueue.models, n

  setUrlList: () ->
    if not @mobile
      @options.columnImageCounts[0] + @options.columnImageCounts[1]
    else
      @getTotalImages()

  handOutImages: () ->
    photoUrls = @sortImageQueue @setUrlList()

    secondColRangeTop = @options.columnImageCounts[0] + @options.columnImageCounts[1]

    i = 0
    _.each photoUrls, (image) =>
      if i < @options.columnImageCounts[0]
        @insertImageInStack @hoursStack, image.url

      else if i >= @options.columnImageCounts[0] && i < secondColRangeTop
        @insertImageInStack @minutesStack, image.url

      if (@mobile is false and i < @options.columnImageCounts[2]) or (@mobile is true and i > secondColRangeTop and i <= secondColRangeTop + 1)
        @insertImageInStack @secondsStack, image.url

      i++

    @initPhotoStacks()
    @startClock()

  updateSecondsImages: () ->
    shuffledUrls = @sortImageQueue(@options.columnImageCounts[2])
    stack = @secondsStack

    i = 0
    _.each shuffledUrls, (image) ->
      imageItem = stack.elListItems.eq(i).find('img')
      imageItem.attr('src', image.url)
      i++

  insertImageInStack: (stack, imageUrl) ->
    stack.elList.append $('<li>')
      .append $("<div><img src='#{imageUrl}' /></div>")

  reload: () ->
    for stack in @stacks
      if stack.elListItems
        stack.elListItems.detach()
        stack.elLabel.fadeOut()

  restart: () ->
    @reload()

    @elLoader.hide()
    @inputSearch.reset()
    @elNowShowing.hide()

    Backbone.history.navigate ''

  startClock: () ->
    @elLoader.hide()
    @elNowShowing.fadeIn()
    @clock.startInterval()

    @clock.on "change:time", (event) =>
      @moveStacks()

    @clock.on "change:minute", (event) =>
      @updateSecondsImages()

  initPhotoStacks: () ->
    @updateStackTime()

    for stack in @stacks
      stack.elListItems = stack.elList.find('li')
      stack.setCurrentFrame()
      stack.positionClockNumbers()

  updateStackTime: () ->
    @secondsStack.setTime @clock.currentSecond, @clock.formattedSecond
    @minutesStack.setTime @clock.currentMinute, @clock.formattedMinute
    @hoursStack.setTime (@clock.currentHour - 1), @clock.formattedHour

  moveStacks: () ->
    @updateStackTime()

    for stack in @stacks
      stack.moveStack()

  module.exports = Timeframe
