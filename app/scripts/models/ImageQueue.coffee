ImageUrl = require './ImageUrl'

class ImageQueue extends Backbone.Collection

  model: ImageUrl

  loadUtility: skone.util.ImageLoader.LoadImageSet

  urlArray: []

  initialize: () ->

  getPhotoURL: (photo) ->
    "http://farm#{photo.farm}.static.flickr.com/" +
    "#{photo.server}/" +
    "#{photo.id}_#{photo.secret}_z.jpg"

  fetchImages: (response) ->
    @urlArray.length = 0
    
    $.each response.photos.photo, (n, item) =>
      photo = response.photos.photo[n]

      t_url = @getPhotoURL(photo)

      image = new ImageUrl(t_url)

      @add image

      @urlArray.push t_url
    
    if @urlArray.length > window.timeframeApp.options.minimumImages
      @loadImages()
    else
      console.log 'Not enough images'
      alert "There weren't enough images. Please try a broader term."
      Backbone.history.navigate '#/error', trigger: true

  loadImages: () ->
    @loadUtility this.urlArray, () =>
      @trigger 'imagesloaded'

module.exports = ImageQueue
