class Mafia.WaitingView extends Mafia.View
  id: 'mafia-waiting-view'
  template: _.template '''
    <div class='title'> Room Number: 1234 </div>
    <button class='ready-button'>
      <span class="visible-ready">Cancel</span>
      <span class="visible-waiting">Ready</span>
    </button>
    <div class='waiting-user-list-wrap'></div>
    <div class='chating-view-wrap'</div>
  '''

  current_status: 'waiting'

  initialize: ->
    @_get_users =>
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
    @$waiting_user_list_wrap = @$(".waiting-user-list-wrap")


  _get_users: (callback) ->
    # TODO: should get user collection
    @users = new Mafia.Collections.Users
    @users.unshift @model
    callback()

  _render_waiting_user_list: ->
    @users.each (user) =>
      new Mafia.Waiting.ItemView app: @app, parent: this, model: user, $wrap: @$waiting_user_list_wrap


