Backbone = require 'backbone'

class Router extends Backbone.Router

  routes:
    '' : 'default'
    'city/:cityName': 'searchCity'

  initialize: (searchView) ->
    # @bind "all", @searchCity


    Backbone.history.start()
    @inputSearch = searchView

  default: () ->
    Backbone.history.navigate '/'

  searchCity: (param) ->
    @citySearch.setCityName(param)
    @inputSearch.setTagName(param)

module.exports = Router
