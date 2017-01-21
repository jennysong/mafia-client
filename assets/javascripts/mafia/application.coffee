#= require ./namespace
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./plugins
#= require_tree ./views
#= require_self

class Mafia.Application
  constructor: ->
    @_init_element()


  append_view: (view) ->
    @_current_view.remove() if @_current_view
    @_current_view = view
    @$el.html view.el


  _init_element: ->
    @$el = $("<div>")
    @$el.attr 'id', 'mafia-application'
    @$el.appendTo $("body")


