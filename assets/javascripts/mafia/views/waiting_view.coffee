class Mafia.WaitingView extends Mafia.View
  className: 'waiting-view'
  template: _.template '''
    <div class='title'> Room Number: 1234 </div>
    <div class='waiting-user-list-wrap'></div>
    <div class='chating-view-wrap'</div>
  '''

  initialize: ->
    @_get_users =>
      @_render()
      @_render_waiting_user_list()
      @_position()

    @_render_game_view()


  _render: ->
    @$el.html @template()
    @$waiting_user_list_wrap = @$(".waiting-user-list-wrap")


  _get_users: (callback) ->
    # TODO: should get user collection
    @users = new Mafia.Collections.Users
    @users.unshift @model
    callback()

  _render_waiting_user_list: ->
    @users.each (user) =>
      new Mafia.Waiting.ItemView app: @app, parent: this, model: user, $wrap: @$waiting_user_list_wrap

  _render_game_view: ->
    new Mafia.GameView app: @app, parent: this, model: @app.current_user, collection: @users
