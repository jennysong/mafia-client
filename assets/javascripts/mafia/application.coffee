#= require ./namespace
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./plugins
#= require_tree ./views
#= require_self

class Mafia.AppStarter
  constructor: ->
    @view = new Mafia.ApplicationView app: this
    @render_login()

  render_login: ->
    new Mafia.LoginView app: this, parent: this








