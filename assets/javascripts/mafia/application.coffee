#= require ./namespace
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./helpers
#= require_tree ./plugins
#= require_tree ./views
#= require_self

class Mafia.AppStarter
  constructor: ->
    _(this).extend Backbone.Events
    socket_host = if /^localhost/.test(location.host)
                    'http://localhost:3000'
                  else
                    'http://mafia-socket.jennysong.ca'

    @current_user = new Mafia.Models.User
    @socket = io.connect socket_host
    @view = new Mafia.ApplicationView app: this
    @config = new Mafia.Helpers.Configuration
    @scene = 1

    @_bind_events()
    @_start()

  events:
    'user-initialized': (sUserId) ->
      @config.set 'userId', sUserId
      @current_user.set 'id', sUserId
      @socket.emit 'load user', sUserId

    'user-found': (oUserAttrs) ->
      @current_user.set oUserAttrs
      if @current_user.get('roomId')
        @socket.emit('resume current game')
      else
        new Mafia.LoginView app: this, parent: this

    'cannot-find-user': ->
      @config.unset 'userId'
      @socket.emit 'init new user'

    'user-joined': (current_users) ->
      new Mafia.WaitingView
        app: this, parent: this, model: @user, current_users: current_users

    'game-already-started': ->
      new Mafia.Dialogs.AlertView
        title: "Alert"
        message: "Game already started"

    'game-started': (game_data) ->
      users = new Mafia.Collections.Users
      users.reset game_data.users
      @scene = game_data.scene

      @current_user = users.get @current_user.id

      new Mafia.Dialogs.GameStartDialogView
        app: this, model: @current_user
        after_show: =>
          new Mafia.GameView app: this, model: @current_user, collection: users

    'game-resumed': (game_data) ->
      users = new Mafia.Collections.Users
      users.reset game_data.users
      @scene = game_data.scene

      new Mafia.GameView app: this, model: @current_user, collection: users

    'restart-game': ->
      new Mafia.LoginView app: this, parent: this

  _start: ->
    if sUserId = @config.get('userId')
      @socket.emit 'load user', sUserId
    else
      @socket.emit 'init new user'


  _bind_events: ->
    # creating '*' events
    onevent = @socket.onevent;
    @socket.onevent = (packet) ->
      args = packet.data or [];
      onevent.call(this, packet);
      packet.data = ["*"].concat(args);
      onevent.call(this, packet);

    # forward
    @socket.on '*', (event, data) =>
      args = _(arguments).toArray()
      event = args.shift()
      callback = @events[event.replace(/\s/g, '-')]
      @events[event.replace(/\s/g, '-')].apply this, args if _(callback).isFunction()