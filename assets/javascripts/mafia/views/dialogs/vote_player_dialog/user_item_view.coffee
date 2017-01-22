class Mafia.Dialogs.VotePlayerDialog.UserItemView extends Mafia.View
  className: 'user-item'
  template: _.template '''
    <span class="mafia-avatar type-<%- avatarId %> bg-<%- avatarBg%>"></span>
    <div class="item-name"><% userName %></div>
  '''

  initialize: (options) ->
    {@$wrap} = options
    @_render()
    @_position()

  _render: ->
    @$el.html @template @model.toJSON()

  _position: ->
    @$wrap.append @el