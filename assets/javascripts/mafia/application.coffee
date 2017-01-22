#= require ./namespace
#= require_tree ./models
#= require_tree ./collections
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

    @socket = io.connect socket_host
    @view = new Mafia.ApplicationView app: this
    @scene = 1
    # temporary
    gameStarted = false
    localStorage.clear()

    @socket.on 'connected', =>
      localStorage.setItem "userId", @socket.id
      if localStorage.getItem("roomId")
        if gameStarted
          new Mafia.GameView app: this
        else
          new Mafia.WaitingView app: this
      else
        new Mafia.LoginView app: this, parent: this


    @on 'game-started', (game_data) =>
      @users = new Mafia.Collections.Users
      @users.reset game_data.users
      @scene = game_data.scene
      @current_user = @users.get @socket.id

      new Mafia.Dialogs.GameStartDialogView
        app: this, model: @current_user
        after_show: =>
          new Mafia.GameView app: this, model: @current_user, collection: @users

    @on 'vote-result-received', (game_data) =>
      @scene = game_data.scene
      @users.check_and_reset_votes() if _(@scene).isOdd()
      deadUser = if game_data.deadUserId then @users.get(game_data.deadUserId) else null
      @trigger 'show-vote-result', deadUser
      #      @trigger 'next-scene-started'

    @on 'restart-game', =>
      new Mafia.LoginView app: this, parent: this

