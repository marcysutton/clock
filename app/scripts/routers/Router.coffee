Backbone = require 'backbone'

class Router extends Backbone.Router

  routes:
    '' : 'default'
    'location/:cityName': 'searchCity'

  initialize: (searchView) ->
    @bind "all", @routeChange

    @app = window.timeframeApp

    @inputSearch = searchView

  default: () ->
    Backbone.history.navigate '/'

  routeChange: (route, router) ->
    @app.reset()

  searchCity: (param) ->
    @inputSearch.setTagName(param)

    @app.appStart()

module.exports = Router
