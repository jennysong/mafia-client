class Mafia.Game.Chat.MessageItemView extends Mafia.View
  className: 'message-item'
  templates:
    user: _.template '''
      <div class="item-label">
        <div class="avatar">
          <span class="mafia-avatar type-<%- user.avatarId %> bg-<%- user.avatarBg %>"></span>
        </div>
        <div class="item-name"><%- user.userName %></div>
        <div class="item-message"><%- msg %></div>
      </div>
    '''
    system: _.template '''
      <div class="item-label">
        <div class="bullet"><span class="entypo info-circled"></span></div>
        <div class="item-message"><%- msg %></div>
      </div>
    '''

  initialize: (options) ->
    {@$wrap} = options

    @model.view = this

    @_render()
    @_position()

    @_define_item_class()


  _render: ->
    data = @model.toJSON()
    if @model.get('type') is 'user'
      data.user = @model.user.toJSON()
      @$el.addClass if @model.user.get('alive') then 'from-village' else 'from-graveyard'
    @$el.html @templates[@model.get('type')] data

  _position: ->
    @$wrap.append @el

  _define_item_class: ->
    @$el.addClass @model.get('type')
    switch @model.get('type')
      when 'user'
        @$el.addClass 'my-message' if @model.user.id is @app.current_user.id