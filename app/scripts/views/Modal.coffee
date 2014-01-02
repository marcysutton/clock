class ModalWindow extends Backbone.Modal
  template: _.template $('#modal-template').html()
  cancelEl: '.btn-close'

  targetEl: '.modal'

  initialize: () ->
    console.log @

    $('.info-icon').on 'click', @toggleModal

  toggleModal: () =>
    @show()

  show: () ->
    $(@targetEl).html @render().el

module.exports = ModalWindow
