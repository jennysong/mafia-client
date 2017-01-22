class Mafia.Dialogs.AlertView extends Mafia.Dialogs.DialogView
  id: 'mafia-alert-view'
  template: _.template '''
    <div class="dialog-title"><%- title %></div>
    <div class="dialog-body">
      <%- message %>
    </div>
  '''


  initialize: (options = {}) ->
    @options =  _.defaults options, {
      title: "Alert"
      message: "Something went wrong."
    }
    @_render()

  events:
    "click": "close"

  _render: ->
    @$el.html @template @options
