###
 * Timeframe
 * @author: Marcy Sutton
 * Version 2.0
 * 12/5/13
###

module.exports = class Timeframe
  constructor: (target, options = {}) ->
    $('body').removeClass 'no-js'

    @target = target

    @options =
      apiKey: 'beb8b17f735b6a404dbe120fd7300460'
      numImages: [12, 60, 60]
      topMargin: 230

    _.defaults(options, @options)

    @totalImages = @options.numImages.reduce (a, b) ->
      a + b

