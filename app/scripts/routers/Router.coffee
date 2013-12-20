Backbone = require 'backbone'

class Router extends Backbone.Router

  routes:
    'location/:cityName': 'searchCity',
    'error': 'error'

  initialize: (searchView) ->
    @bind "all", @routeChange

    @app = window.timeframeApp

    @inputSearch = searchView
    
  routeChange: (route, router) ->
    @app.reload()

  searchCity: (param) ->
    @inputSearch.setTagName(param)

    @app.appStart()
  
  error: () ->
    @app.restart()

module.exports = Router
