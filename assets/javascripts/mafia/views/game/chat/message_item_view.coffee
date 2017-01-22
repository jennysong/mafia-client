class Mafia.Game.Chat.MessageItemView extends Mafia.View
  className: 'message-item'
  template: _.template '''
    <%- writer %>: <%- msg %>
  '''

  initialize: (options) ->
    {@$wrap} = options

    @_render()
    @_position()


  _render: ->
    @$el.html @template @model.toJSON()

  _position: ->
    @$wrap.append @el