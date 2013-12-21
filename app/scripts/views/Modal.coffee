class ModalWindow extends Backbone.Modal
  template: _.template $('#modal-template').html()

  viewContainer: '.content-container'
  cancelEl: '.btn-close'

  targetEl: '.modal'

  views:
    'load document':
      name: 'mobile'
      view: _.template $('#mobile-view-template').html()
      onActive: 'setActive'

    'click .info':
      name: 'info'
      view: _.template $('#info-view-template').html()
      onActive: 'setActive'

  show: () ->
    $(@targetEl).html @render().el

  setActive: (options) ->
    @.$("##{options.name}").addClass 'active'

  close: () ->
    super()

    Backbone.history.start()

module.exports = ModalWindow
