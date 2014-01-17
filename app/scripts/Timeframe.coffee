###
 * Timeframe ViewController
 * @author: Marcy Sutton
 * Version 2.0
 * 12/5/13
###

# global $, Modernizr, Backbone

config = require './config'
Router = require './routers/Router'
InputSearchView = require './views/InputSearch'
StackView = require './views/Stack'
ImageQueue = require './models/ImageQueue'
Clock = require './models/Clock'
Sharing = require './views/Sharing'

class Timeframe extends Backbone.View
  constructor: (target, options = {}) ->
    @options =
      apiKey: 'beb8b17f735b6a404dbe120fd7300460'
      columnImageCounts: [12, 60, 60]
      dateFormat: 'dddd, MMM D YYYY'
      timesOfDay: [
        'night'
        'morning'
        'morning'
        'afternoon'
        'evening'
        'night'
      ]
      minimumImages: 72
      mobileImages: 36
      positionContext: 'time'

    _.defaults(options, @options)

    @started = false

    @target = target
    @mobile = false

    @loadUtility = skone.util.ImageLoader.LoadImageSet
    @imageQueue = new ImageQueue()

  initialize: () ->
    if window.matchMedia("(max-width: 64em)").matches and Modernizr.touch
      @mobileSetup()

    @inputSearch = new InputSearchView({mobile: @mobile})

    @router = new Router(@inputSearch)

    @elWrapper = $(@target)
    @elTarget = @elWrapper.find('.app')
    @elLoader = $('.loader')

    @elSiteCredit = $('.substantial')
    @elTagLoading = @elLoader.find('.tag-loading')
    @elNowShowing = @elTarget.find('.now-showing')
    @elDate = @elWrapper.find('.date')

    @setupClockUI()

    @sharing = new Sharing(@router)

    Backbone.history.start()

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

  getTotalImages: () ->
    if not @mobile
      @totalImages = @options.columnImageCounts.reduce (a, b) ->
        a + b
    else
      @totalImages = @options.mobileImages

    @totalImages

  mobileSetup: () ->
    console.log 'mobileSetup'
    @mobile = true

    $('body').addClass('mobile')

    @options.minimumImages = @getTotalImages()
    @options.columnImageCounts = [1, 1, 1]
    @options.positionContext = 'none'

  clockTextRepaint: () ->
    $('.stack').find('h3').css('z-index', 2)

  updateUIWithTagChange: (selectedTagName) ->
    @elTagLoading.text selectedTagName

  appStart: () ->
    @started = true

    @selectedTagName = @inputSearch.decodeTagName()
    @updateUIWithTagChange @selectedTagName

    @clock = new Clock(@selectedTagName)
    @imageQueue = new ImageQueue()

    @sharing.$el.fadeOut()

    @inputSearch.elTagPicker.fadeOut 400, () =>
      @elLoader.fadeIn()
      @elWrapper.addClass('clock-active')

      @clock.setTime()

      @imageQueue.on 'imagesloaded', () =>
        @handOutImages()

      @querySearchAPI()

  getFlickrUserId: (username) ->
    $.getJSON @getUserURL(username), (response) =>
      if response.stat is "ok"
        console.log response
        @userId = response.user.id

        @appStart()

      else if response.stat is "fail"
        @showErrorMessage response
    .fail (response) =>
      @showErrorMessage response

  querySearchAPI: () ->
    return unless @started

    $.getJSON @getJSONURL(), (response) =>
      console.log response

      if response.stat is "ok"
        console.log 'number of images: ', response.photos.photo.length

        @updateDisplay()

        @imageQueue.fetchImages response
      else
        @showErrorMessage response.message

    .fail (response) =>
      @showErrorMessage response

  showErrorMessage: (response) ->
    if response.message
      alert response.message
    else
      alert 'Sorry, there was a problem. Please try again!'

    console.log response

  getUserURL: (username) ->
    "http://api.flickr.com/services/rest/?method=flickr.people.findByUsername&" +
    "api_key=#{@options.apiKey}&" +
    "username=#{username}&" +
    "format=json&nojsoncallback=1"

  getJSONURL: () ->
    "http://api.flickr.com/services/rest/?method=flickr.photos.search&" +
    "api_key=#{@options.apiKey}&" +
    @getParams() +
    "sort=interestingness-desc&" +
    "per_page=" + @getTotalImages() +
    "&format=json&jsoncallback=?"

  getTimeTag: (hour = @clock.current24Hour) ->
    currentTimeTagIndex = Math.floor(@options.timesOfDay.length * (hour / 24))
    @options.timesOfDay[currentTimeTagIndex]

  setTimeTag: () ->
    @currentTimeTag = @getTimeTag(@clock.current24Hour)

  getParams: () ->
    if @mode is 'location'
      @setTimeTag()

      tagParams = "tag_mode=all&tags="
      tags = "#{@inputSearch.encodeTagName()}"
      tags += ",#{@currentTimeTag}&"

      tagParams + tags

    else
      "user_id=#{@userId}&"

  sortImageQueue: (n) ->
    _.shuffle @imageQueue.models, n

  setUrlList: () ->
    if not @mobile
      @options.columnImageCounts[0] + @options.columnImageCounts[1]
    else
      @getTotalImages()

  handOutImages: () ->
    return unless @started

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

  updateStackImages: (stack = @secondsStack) ->
    shuffledUrls = @sortImageQueue(@options.columnImageCounts[2])

    i = 0
    _.each shuffledUrls, (image) ->
      imageItem = stack.elListItems.eq(i).find('.img')
      imageItem.css('background-image', 'url('+image.url+')')
      i++

  updateImagesMobile: () ->
    shuffledUrls = @sortImageQueue(3)
    i = 0
    for stack in @stacks
      stackEl = $(stack.elList)
      stackEl.hide()

      stack.currentImg.css('background-image', 'url('+shuffledUrls[i].url+')')
      i++

      stackEl.fadeIn(600)

  insertImageInStack: (stack, imageUrl) ->
    stack.elList.append $('<li>')
      .append $("<div><div class='img' style='background-image:url(#{imageUrl})'></div></div>")

  startClock: () ->
    @elLoader.hide()
    @elNowShowing.fadeIn()
    @elDate.fadeIn()
    @clock.startInterval()

    @upDate()
    @sharing.$el.fadeIn()

    @clock.on "change:day", (event) =>
      @upDate()

    @clock.on "change:time", (event) =>
      @moveStacks()

    @clock.on "change:hour", (event) =>
      @checkHourForRefresh()

    @clock.on "change:minute", (event) =>
      if not @mobile
        @updateStackImages()

    if @mobile
      @clock.on "change:seconds10", (event) =>
        @updateImagesMobile() if @clock.secondsSinceRefresh >= 5

  moveStacks: () ->
    @updateStackTime()

    for stack in @stacks
      stack.moveStack()

  upDate: () ->
    @elDate.text(@clock.moment.format(@options.dateFormat))

  checkHourForRefresh: () ->
    # Refresh clock
    if window.navigator.onLine isnt false
      if @mode is "location" and @getTimeTag(@clock.current24Hour) isnt @currentTimeTag
        @refreshClock()

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

  updateDisplay: () ->
    if @mode is 'location'
      @elWrapper.attr 'id', 'locationClock'
      console.log('showing '+@selectedTagName+' in the '+ @currentTimeTag)
      @elNowShowing.text "#{@selectedTagName} #{@currentTimeTag}"
    else
      @elWrapper.attr 'id', 'userClock'
      console.log 'showing '+@selectedTagName+"'s photos"
      @elNowShowing.html @flickrUserLink @selectedTagName

  flickrUserLink: (tagName) ->
    "<a href='http://www.flickr.com/photos/#{@userId}/' target='_blank' title='link opens in a new window'>#{@selectedTagName}'s photos</a>"

  refreshClock: () ->
    console.log 'refreshing clock'
    Backbone.history.loadUrl Backbone.history.fragment

  reloadUI: () ->
    for stack in @stacks
      if stack.elListItems
        stack.elLabel.fadeOut()
        stack.elListItems.detach()

  restart: () ->
    @started = false

    @reloadUI()

    @elLoader.hide()
    @sharing.$el.fadeIn()
    @inputSearch.reset()
    @elWrapper.removeClass('clock-active')
    @elNowShowing.hide()
    @elDate.hide()

    Backbone.history.navigate '#', trigger: true

  module.exports = Timeframe
