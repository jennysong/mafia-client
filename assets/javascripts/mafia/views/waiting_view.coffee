class Mafia.WaitingView extends Mafia.View
  id: 'mafia-waiting-view'
  template: _.template '''
    <div class="avatar-item-list"></div>
    <div class="waiting-user-list"></div>
    <button class='ready-button'>
      <span class="visible-ready">Cancel</span>
      <span class="visible-waiting">Ready</span>
    </button>
  '''

  current_status: 'waiting'

  initialize: (options = {}) ->
    @users = new Mafia.Collections.Users options.current_users

    @_render()
    @_render_waiting_user_list()
    @_mark_as_waiting()
    @_position()

  events:
    'click .ready-button': 'toggle_ready'

  toggle_ready: ->
    if @current_status is 'ready'
      @_mark_as_waiting()
    else
      @_mark_as_ready()

  _mark_as_waiting: ->
    @$el.addClass('status-waiting').removeClass 'status-ready'
    @current_status = 'waiting'
    @app.socket.emit('user is not ready')


  _mark_as_ready: ->
    @$el.addClass('status-ready').removeClass 'status-waiting'
    @current_status = 'ready'
    @app.socket.emit('user is ready')

  _render: ->
    @$el.html @template()
    @$waiting_user_list = @$(".waiting-user-list")
    @$avatar_item_list = @$(".avatar-item-list")


  _render_waiting_user_list: ->
    @users.each (user) =>
      @_render_user_item user


  _render_user_item: (user) ->
    @new Mafia.Waiting.UserItemView,
      app: @app, parent: this, model: user
      $wrap: @$waiting_user_list

  #can be deleted below
  _render_game_view: ->
    new Mafia.GameView app: @app, parent: this, model: @app.current_user, collection: @users
