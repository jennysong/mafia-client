#= require ./namespace
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./plugins
#= require_tree ./views
#= require_self

class Mafia.AppStarter
  constructor: ->
    @socket = io.connect 'http://localhost:3000'
    @view = new Mafia.ApplicationView app: this

    gameStarted = false

    @socket.on 'connected', =>
      localStorage.setItem "userId", @socket.id
      if localStorage.getItem("roomId")
        if gameStarted
          new Mafia.GameView app: this
        else
          new Mafia.WaitingView app: this
      else
        new Mafia.LoginView app: this, parent: this


