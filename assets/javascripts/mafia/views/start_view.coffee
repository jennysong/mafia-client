class Mafia.StartView extends Mafia.View
  id: 'mafia-start-view'
  className: 'start-view'
  template: _.template '''
    <div class="role"> Your role is <%- role %></div>
  '''

  initialize: ->
    @_render()
    @_position()

    setTimeout @_game_start, 10000


  events:
    'click': "_game_start"

  _render: ->
    @$el.html @template @model.toJSON()

  _game_start: =>
    new Mafia.GameView app: @app, model: @model, collection:  @collection
