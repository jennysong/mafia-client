class Mafia.Game.ChatView extends Mafia.View
  id: 'mafia-game-chat-view'
  class: 'chat-view'
  template: _.template '''
    Chat View
  '''

  initialize: ->
    @_render()
    @_position()

  _render: ->
    @$el.html @template()

  _position: ->
    @parent.$section_wrap.append @$el