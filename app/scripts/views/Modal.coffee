class ModalWindow extends Backbone.Modal
  template: _.template $('#modal-template').html()
  cancelEl: '.btn-close'

  targetEl: '.modal'

  show: () ->
    $(@targetEl).html @render().el

  close: () ->
    super()

    Backbone.history.start()

module.exports = ModalWindow
