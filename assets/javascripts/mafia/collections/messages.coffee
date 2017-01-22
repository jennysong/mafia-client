class Mafia.Collections.Messages extends Backbone.Collection
  model: Mafia.Models.Message

  add_system_message: (message) ->
    @add type: 'system', msg: message