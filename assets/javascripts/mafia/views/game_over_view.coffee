class Mafia.GameOverView extends Mafia.View
  id: 'mafia-game-over-view'
  template: _.template '''
    <div class="finish">
      Game Finished!!!!!!!!!!!!!!!!!!!!!!!!!!!
    </div>
    <div class="result">
      <%- result %>
    </div>
  '''

  initialize: ->
    @_render()
    @_position()

  events:
    'click': '_restart_game'

  _render: ->
    @$el.html @template result: @model.get_result(@app.scene)

  _restart_game: ->
    @app.triger "restart-game"
