class Mafia.Waiting.UserItemView extends Mafia.View
  className: "user-item-view"
  tagName: "li"
  template: _.template '''
    <%- avatarId %>
    <%- avatarBg %>
    <%- userName %>
  '''

  initialize: (options) ->
    {@$wrap} = options

    @_render()
    @_position()

  _render: ->
    @$el.html @template @model.toJSON()

  _position: ->
    @$wrap.append @$el



