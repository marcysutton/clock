config = require '../config'

class Sharing extends Backbone.View

  options:
    twitterUrl: 'https://twitter.com/share?url='
    facebookUrl: 'https://www.facebook.com/sharer/sharer.php?s=100&p[url]='
    id: 'ShareTimeframe'
    popupHeight: 490
    popupWidth: 600

  url: null

  el: '.share'

  events:
    "click a" : "openWindow"

  initialize: (router, options = {}) ->
    @router = router

    @$el = $(@el)

    _.defaults(options, @options)

    @setPopupOptions()

  getUrl: (linkId) ->
    if linkId is "twitter"
      shareUrl = @getTwitterUrl()
    else
      shareUrl = @getFacebookUrl()

    shareUrl

  getTwitterUrl: () ->
    text = config.tweetText

    @options.twitterUrl +
    @router.getPageUrl() +
    '&text=' + encodeURI text

  getFacebookUrl: () ->
    text = config.facebookText

    @options.facebookUrl +
    @router.getPageUrl() +
    '&p[title]=' + config.title +
    '&p[summary]=' + encodeURI text +
    '&p[images][0]=' + encodeURIComponent config.image

  setPopupOptions: (options) ->
    @optionsString = "width=#{@options.popupWidth},height=#{@options.popupHeight}"

  getPopupOptions: () ->
    @optionsString

  openWindow: (e) ->
    e.preventDefault()

    window.open(@getUrl(e.target.id), @options.id, @getPopupOptions())

module.exports = Sharing
