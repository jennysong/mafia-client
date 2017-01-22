class Mafia.WaitingView extends Mafia.View
  id: 'mafia-waiting-view'
  template: _.template '''
    <div class="status-indicator-wrap"></div>
    <div class="waiting-users section-item">
      <div class="waiting-user-list"></div>
    </div>
    <div class="actions">
      <div class='ready-button'>
        <span class="visible-ready">Cancel</span>
        <span class="visible-waiting">Ready</span>
      </div>
    </div>
  '''

  current_status: 'waiting'

  initialize: (options = {}) ->
    @app.users = new Mafia.Collections.Users
    @app.users.addEmptySlots 12

    @_render()
    @_render_status_indicator()
    @_render_waiting_user_list()
    @_position()

    @app.socket.on 'ready status', (current_users) =>
      @app.users.updatesCollectionByIndex current_users
      if @app.users.isReady()
        @status_indicator.start_counting()
        @app.socket.on 'game start', (game_data) =>
          @app.socket.off 'game start'
          @app.trigger 'game started', game_data
      else
        @status_indicator.stop_counting()
        @app.socket.off 'game start'

    @_mark_as_waiting()

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
    @$status_indicator_wrap = @$(".status-indicator-wrap")

  _render_waiting_user_list: ->
    @$waiting_user_list.empty()
    @app.users.each (user) =>
      @_render_user_item user

  _render_user_item: (user) ->
    @new Mafia.Waiting.UserItemView,
      app: @app, parent: this, model: user
      $wrap: @$waiting_user_list

  _render_status_indicator: ->
    @status_indicator = @new Mafia.Waiting.StatusIndicatorView,
      app: @app, parent: this, $wrap: @$status_indicator_wrap

  #can be deleted below
  _render_game_view: ->
    new Mafia.GameView app: @app, parent: this, model: @app.current_user, collection: @app.users

  _render_result_view: ->
    new Mafia.ResultView app: @app, parent: this, report: @report