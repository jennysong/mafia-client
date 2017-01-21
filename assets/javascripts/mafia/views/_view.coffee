class Mafia.View extends Backbone.View

  constructor: (options = {}) ->
    {@app, @parent} = options
    super options