# centralized dispatcher object added to all Backbone Collection, Model, View, and Router classes
(->
  return if this.isExtended
  # attaching the Events object to the dispatcher variable
  dispatcher = _.extend({}, Backbone.Events, cid: "dispatcher")
  _.each [ Backbone.Collection::, Backbone.Model::, Backbone.View::, Backbone.Router:: ], (proto) ->
    # attaching a global dispatcher instance
    _.extend proto, dispatcher: dispatcher
)()
