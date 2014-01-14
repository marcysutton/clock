ImageUrl = require './ImageUrl'

class ImageQueue extends Backbone.Collection

  model: ImageUrl

  loadUtility: skone.util.ImageLoader.LoadImageSet

  urlArray: []

  imageSize: 'z'

  initialize: () ->
    @app = window.timeframeApp

  getPhotoURL: (photo) ->
    "http://farm#{photo.farm}.static.flickr.com/" +
    "#{photo.server}/" +
    "#{photo.id}_#{photo.secret}_#{@imageSize}.jpg"

  fetchImages: (response) ->
    @urlArray.length = 0

    $.each response.photos.photo, (n, item) =>
      photo = response.photos.photo[n]

      t_url = @getPhotoURL(photo)

      image = new ImageUrl(t_url)

      @add image

      @urlArray.push t_url

    if @urlArray.length >= @app.options.minimumImages
      @loadImages()
    else
      console.log 'Not enough images'

      customMessage = "User didn't have enough images. Please try a different username!" if @app.mode is 'username'
      customMessage = "There weren't enough images. Please try a broader term." if @app.mode is 'location'

      alert customMessage

      Backbone.history.navigate '#/error', trigger: true

  loadImages: () ->
    @loadUtility this.urlArray, () =>
      @trigger 'imagesloaded'

module.exports = ImageQueue
