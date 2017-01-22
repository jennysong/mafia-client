class Mafia.Game.Chat.MessageItemView extends Mafia.View
  className: 'message-item'
  template: _.template '''
    <div class="item-label">
      <div class="avatar">
        <span class="mafia-avatar type-<%- user.avatarId %> bg-<%- user.avatarBg %>"></span>
      </div>
      <div class="item-name"><%- user.userName %></div>
      <div class="item-message"><%- msg %></div>
    </div>
  '''

  initialize: (options) ->
    {@$wrap} = options

    @_render()
    @_position()

    @$el.addClass 'my-message' if @model.user.id is @app.current_user.id


  _render: ->
    data = @model.toJSON()
    data.user = @model.user.toJSON()
    @$el.html @template data

  _position: ->
    @$wrap.append @el