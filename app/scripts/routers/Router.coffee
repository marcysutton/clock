Backbone = require 'backbone'

class Router extends Backbone.Router

  routes:
    '' : 'default'
    'city/:cityName': 'searchCity'

  initialize: (searchView) ->
    # @bind "all", @searchCity

    @citySearch = searchView

    Backbone.history.start()

  default: () ->
    Backbone.history.navigate '/'

  searchCity: (param) ->
    @citySearch.setCityName(param)

module.exports = Router
