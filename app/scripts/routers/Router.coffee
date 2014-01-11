class Router extends Backbone.Router

  routes:
    'location/:cityName': 'searchCity'
    'username/:username': 'userPhotos'
    'error': 'error'

  initialize: (searchView) ->
    @bind "all", @routeChange

    @app = window.timeframeApp

    @inputSearch = searchView

  routeChange: (route, router) ->
    @app.reloadUI()

  searchCity: (param) ->
    @inputSearch.setTagName(@inputSearch.locationMode, param)

    @app.mode = @inputSearch.locationMode

    @app.appStart()

  userPhotos: (param) ->
    @inputSearch.setTagName(@inputSearch.userMode, param)

    @app.mode = @inputSearch.userMode
    @app.getFlickrUserId(param)

  error: () ->
    @app.restart()

module.exports = Router
