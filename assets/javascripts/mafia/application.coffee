#= require ./namespace
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./plugins
#= require_tree ./views
#= require_self

class Mafia.AppStarter
  constructor: ->
    _(this).extend Backbone.Events
    @socket = io.connect 'http://localhost:3000'
    @view = new Mafia.ApplicationView app: this

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


    @on 'game started', (game_data) =>
      @users = new Mafia.Collections.Users
      @users.reset game_data
      @current_user = @users.get @socket.id
      new Mafia.GameView app: this, model: @current_user, collection:  @users
