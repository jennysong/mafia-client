class Mafia.View extends Backbone.View

  constructor: (options = {}) ->
    {@app, @parent} = options
    @_child_views = []
    super options

  _position: ->
    @app.view.append_view this

  render_child_view: (view, options) ->
    new_view = new view options
    @_child_views.push new_view
    new_view

  new: ->
    @render_child_view.apply this, arguments