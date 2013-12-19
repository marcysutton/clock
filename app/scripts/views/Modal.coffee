class ModalWindow extends Backbone.Modal
  template: _.template $('#modal-template').html()
  cancelEl: '.btn-close'

  close: () ->
    super()

    Backbone.history.start()


module.exports = ModalWindow
