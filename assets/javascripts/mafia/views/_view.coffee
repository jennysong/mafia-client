class Mafia.View extends Backbone.View

  constructor: (options = {}) ->
    {@app, @parent} = options
    super options

  _position: ->
    @app.view.append_view this